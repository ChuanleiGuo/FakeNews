//
//  DetailPage.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/12/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit
import ReactiveCocoa
import WebImage

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
    var temImgPara: [String: String]!
    
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
            print(error)
        }, completed: {
            self.showInWebView()
            self.requestForFeedbackList()
        })
        
        let signals: NSArray = [viewModel.fetchHotFeedbackCommand.executing.skip(1), viewModel.fetchNewsDetailCommand.executing.skip(1)]
        (RACSignal.combineLatest(signals).filter { (x) -> Bool in
            if let x  = x as? RACTuple {
                return (!(x.first as! NSNumber).boolValue) && (!(x.last as! NSNumber).boolValue)
            }
            return false
        }).subscribeNext({ [unowned self] (x) in
            self.tableView.reloadData()
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
        if url.range(of: "sx:") != nil {
            showPicture(withAbsoluteUrl: url)
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
            return head
        } else if section == 2 {
            let head = NewsDetailBottomCell.theSectionHeaderCell()
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
                model.docid = viewModel.sameNews[indexPath.row].id
                
                let sb = UIStoryboard(name: "News", bundle: nil)
                let devc = sb.instantiateViewController(withIdentifier: "SXDetailPage") as! DetailPage
                devc.newsModel = model
                navigationController!.pushViewController(devc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return NewsDetailBottomCell.theShareCell()
        } else if indexPath.section == 1 {
            if indexPath.row == viewModel.replyModels.count {
                let foot = NewsDetailBottomCell.theSectionBottomCell()
                return foot
            } else {
                let hotReply = NewsDetailBottomCell.theHotReplyCell(withTableView: tableView)
                hotReply.replyModel = viewModel.replyModels[indexPath.row]
                return hotReply
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = NewsDetailBottomCell.theKeywordCell()
                cell.contentView.addSubview(addKeywordButton())
                return cell
            } else {
                let other = NewsDetailBottomCell.theContactNewsCell()
                other.sameNewsEntity = viewModel.sameNews[indexPath.row]
                return other
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 126
        } else if indexPath.section == 1 {
            if indexPath.row == viewModel.replyModels.count {
                return 50
            } else {
                return 110.5
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return 60
            } else {
                return 81
            }
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 126
        } else if indexPath.section == 1 {
            if indexPath.row == viewModel.replyModels.count {
                return 50
            } else {
                return 110.5
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return 60
            } else {
                return 81
            }
        }
        return CGFloat.leastNormalMagnitude
    }
    
    // MARK: - Private Methods
    
    private func requestForFeedbackList() {
        viewModel.fetchHotFeedbackCommand.execute(nil)
    }
    
    private func addKeywordButton() -> UIView {
        var maxRight: CGFloat = 20
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60))
        for i in 0..<viewModel.keywordSearch.count {
            let button = UIButton(frame: CGRect(x: maxRight, y: 10, width: 0, height: 0))
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitleColor(UIColor(red: 74, green: 133, blue: 198, alpha: 1.0),
                                 for: .normal)
            button.setTitle(viewModel.keywordSearch[i]["word"], for: .highlighted)
            button.setBackgroundImage(UIImage(named: "choose_city_normal"), for: .normal)
            button.setBackgroundImage(UIImage(named: "choose_city_highlight"), for: .highlighted)
            button.sizeToFit()
            button.width += 20
            button.height = 35
            
            maxRight = button.x + button.width + 10
            view.addSubview(button)
        }
        return view
    }
    
    private func showPicture(withAbsoluteUrl url: String) {
        view.isUserInteractionEnabled = false
        let range = url.range(of: "github.com/dsxNiubility?")!
        let path = range.upperBound
        let tail = url.substring(from: path)
        let keyValues = tail.components(separatedBy: "&")
        var parameters = [String: String]()
        for str in keyValues {
            let keyValue = str.components(separatedBy: "=")
            if keyValue.count == 2 {
                parameters[keyValue[0]] = keyValue[1]
            } else if keyValues.count > 2 {
                if let range = str.range(of: "src=") {
                    let value = str.substring(from: range.upperBound)
                    parameters["src"] = value
                }
            }
        }
        temImgPara = parameters
        let cache = URLCache.shared
        if let srcPath = parameters["src"] {
            let request = URLRequest(url: URL(string: srcPath)!)
            
            var imgView = UIImageView()
            
            if let imgData = cache.cachedResponse(for: request)?.data,
                let image = UIImage(data: imgData) {
                
                var top: CGFloat = tableView.y - tableView.contentOffset.y
                var height: CGFloat = 0.0
                if let t = parameters["top"] {
                    top  += CGFloat((t as NSString).floatValue)
                }
                
                if let s = parameters["whscale"] {
                    height = (SCREEN_WIDTH - 15) / CGFloat((s as NSString).floatValue)
                }
                
                temImgPara["top"] = "\(top)"
                temImgPara["height"] = "\(height)"
                
                imgView = UIImageView(image: image)
                imgView.frame = CGRect(x: 8, y: top, width: SCREEN_WIDTH - 15, height: height)
                bigImg = imgView
                
                hoverView.alpha = 0
                navigationController!.view.addSubview(hoverView)
                navigationController!.view.addSubview(imgView)
            
            } else {
                imgView = UIImageView()
                imgView.sd_setImage(with: URL(string: srcPath)!, completed: {
                    (image, error, type, url) in
                    self.moveToCenter()
                })
            }
            moveToCenter()
        }
    }
    
    private func moveToCenter() {
        let w: CGFloat = SCREEN_WIDTH
        let h: CGFloat = SCREEN_WIDTH / CGFloat((temImgPara["whscale"]! as NSString).floatValue)
        let x: CGFloat = 0
        let y: CGFloat = (SCREEN_HEIGHT - h) / 2
        
        UIView.animate(withDuration: 0.5, animations: { 
            self.hoverView.alpha = 1.0
            self.bigImg.frame = CGRect(x: x, y: y, width: w, height: h)
        }, completion: { finished in
            self.view.isUserInteractionEnabled = true
        })
    }
}
