//
//  NewsTableViewPage.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/29/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

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
        loadData()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            [weak self] (arrayM) in
            if let strongSelf = self {
                if let arrayM = arrayM as? [NewsEntity] {
                    if type == 1 {
                        strongSelf.arrayList = arrayM
                        queue.async {
                            strongSelf.tableView.reloadData()
                        }
                        // strongSelf.tableView.reloadData()
                    } else if type == 2 {
                        strongSelf.arrayList.append(contentsOf: arrayM)
                        queue.async {
                            strongSelf.tableView.reloadData()
                        }
                        //strongSelf.tableView.reloadData()
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
