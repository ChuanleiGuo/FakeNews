//
//  DetailPage.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/12/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit
import ReactiveCocoa

fileprivate let SCREEN_WIDTH = UIScreen.main.bounds.width
fileprivate let SCREEN_HEIGHT = UIScreen.main.bounds.height

class DetailPage: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {
    
    // MARK: - Properties
    
    var newsModel: NewsEntity! {
        didSet {
            viewModel.newsModel = newsModel
        }
    }
    var index: Int!
    
    var bigImg: UIImageView!
    var hoverView: UIView!
    var closeCell: NewsDetailBottomCell!
    
    private var news: Array<[String: String]>! = {
        guard let filePath = Bundle.main.path(forResource: "NewsURLs.plist", ofType: nil) else {
            return nil
        }
        return NSArray(contentsOfFile: filePath) as! Array<[String: String]>
    }()
    
    private var webView: UIWebView = {
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 700))
        return webView
    }()
    
    private var viewModel: NewsDetailViewModel = {
        return NewsDetailViewModel()
    }()
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var replyCountBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
        hoverView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        hoverView.backgroundColor = UIColor.black
        let downLoad = UIButton(frame: CGRect(x: SCREEN_WIDTH - 60, y: SCREEN_HEIGHT - 60,
                                              width: 50, height: 50))
        downLoad.setImage(UIImage(named: "203"), for: .normal)
        self.hoverView.addSubview(downLoad)
        
        downLoad.rac_signal(for: .touchUpInside).subscribeNext { [unowned self] (x) in
            if let image = self.bigImg.image {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
        
        viewModel.fetchNewsDetailCommand.execute(nil).subscribeError({ (error) in
            
        }, completed: {
            self.showInWebView()
            self.requestForFeedbackList()
        })
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - IBAction
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    // MARK: - webView + html
    
    private func showInWebView() {
        webView.loadHTMLString(viewModel.htmlString, baseURL: nil)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url!.absoluteString
        if let range = url.range(of: "sx:") {
            showPicture(url: url)
            return false
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.height = webView.scrollView.contentSize.height
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let replyVC = segue.destination as! ReplyPage
        replyVC.source = .newsDetail
        replyVC.newsModel = newsModel
        
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "contentStart"),
                                                     object: nil, userInfo: nil))
    }
    
    
    
    // MAKR: - UITableViewDataSource, UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return webView
        } else if section == 1 {
            let head = NewsDetailBottomCell.theSectionHeaderCell()
            head.sectionHeaderLabel.text = "热门跟贴"
        } else if section == 2 {
            let head = NewsDetailBottomCell.theSectionBottomCell()
            head.sectionHeaderLabel.text = "相关新闻"
            return head
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return webView.height
        } else if section == 1 {
            return viewModel.replyModels.count > 0 ? 40 : CGFloat.leastNormalMagnitude
        } else if section == 2 {
            return viewModel.sameNews.count > 0 ? 40 : CGFloat.leastNormalMagnitude
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            closeCell = NewsDetailBottomCell.theCloseCell()
            return closeCell
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 64
        }
        return 15
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1 + viewModel.replyModels.count
        } else if section == 2 {
            return viewModel.sameNews.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == viewModel.replyModels.count {
                performSegue(withIdentifier: "toReply", sender: nil)
            }
        } else if indexPath.section == 2 {
            if indexPath.row > 0 {
                let model = NewsEntity()
                model.docid = viewModel.sameNews[indexPath.row].docid
                
                let sb = UIStoryboard(name: "News", bundle: nil)
                let devc = sb.instantiateViewController(withIdentifier: "SXDetailPage") as! DetailPage
                devc.newsModel = model
                navigationController!.pushViewController(devc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
