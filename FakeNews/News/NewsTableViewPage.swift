//
//  NewsTableViewPage.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/29/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit
import MJRefresh

class NewsTableViewPage: UITableViewController {

    /**
     *  url interface
     */
    
    var urlString: String!
    var index: Int!
    
    // MARK: - Properties
    
    private var arrayList = [NewsEntity]()
    private var update = false
    private lazy var viewModel: NewsViewModel = {
        return NewsViewModel()
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        // TODO: - Refresh
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [unowned self] in
            self.loadData()
        })
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: { 
            [unowned self] in
            self.loadMoreData()
        })
        self.update = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(welcome),
                                               name: NSNotification.Name("AdvertisementKey"),
                                               object: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard UserDefaults.standard.bool(forKey: "update") else {
            return
        }
        
        if update == true {
            tableView.mj_header.beginRefreshing()
            update = false
        }
        NotificationCenter.default.post(Notification(name: Notification.Name("contentStart"),
                                                     object: nil, userInfo: nil))
    }
    
    @objc private func welcome() {
        UserDefaults.standard.set(true, forKey: "update")
        tableView.mj_header.beginRefreshing()
    }
    
    func loadData() {
        let allUrlString = String(format: "/nc/article/%@/0-20.html", urlString)
        loadData(forType: 1, withURL: allUrlString)
    }
    
    func loadMoreData() {
        let allUrlString = String(format: "/nc/article/%@/%ld-20.html",
                                  urlString, (arrayList.count - arrayList.count%10))
        loadData(forType: 2, withURL: allUrlString)
    }
    
    func loadData(forType type: Int, withURL url: String) {
        let urlString = url as NSString
        let queue = DispatchQueue.main
        viewModel.fetchNewsEntityCommand.execute(urlString).subscribeNext({
            [unowned self] (arrayM) in
            
            if let arrayM = arrayM as? [NewsEntity] {
                if type == 1 {
                    self.arrayList = arrayM
                    queue.async {
                        self.tableView.mj_header.endRefreshing()
                        self.tableView.reloadData()
                    }
                } else if type == 2 {
                    self.arrayList.append(contentsOf: arrayM)
                    queue.async {
                        self.tableView.mj_header.endRefreshing()
                        self.tableView.reloadData()
                    }
                }
            }
        }, error: {
            error in
            print(error)
        })
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailPage, let x = tableView.indexPathForSelectedRow?.row {
            let dc = segue.destination as! DetailPage
            dc.newsModel = arrayList[x]
            dc.index = self.index
            
        } else if let x = tableView.indexPathForSelectedRow?.row {
            let pc = segue.destination as! PhotoSetPage
            pc.newsModel = arrayList[x]
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newModel = arrayList[indexPath.row]
        var id = NewsCell.idForRow(newModel: newModel)
        if indexPath.row % 20 == 0 && indexPath.row != 0 {
            id = "NewsCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! NewsCell
        cell.newsModel = newModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newsModel = arrayList[indexPath.row]
        var rowHeight = NewsCell.heightForRow(newModel: newsModel)
        if indexPath.row % 20 == 0 && indexPath.row != 0 {
            rowHeight = 80
        }
        return rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
