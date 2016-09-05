//
//  ReplyPage.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/4/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit
import FDTemplateLayoutCell

class ReplyPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let ID = "ReplyCell"
    
    // MARK: - Properties
    
    var newsModel: NewsEntity! {
        didSet {
            viewModel.newsModel = newsModel
        }
    }
    var source: ReplyPageFrom! {
        didSet {
            viewModel.source = source
        }
    }
    var photoSetId: String! {
        didSet {
            viewModel.photoSetPostID = photoSetId
        }
    }
    
    private lazy var viewModel: ReplyViewModel = {
        return ReplyViewModel()
    }()
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        let mainQueue = DispatchQueue.main
        
        viewModel.fetchHotReplyCommand.execute(nil).subscribeError({ (error) in
            if let error = error as? NSError {
                print("error occurred! -- %@", error.userInfo)
            }
        }, completed: {
            mainQueue.async {
                self.tableView.reloadData()
            }
        })
        
        viewModel.fetchNormalReplyCommand.execute(nil).subscribeError({ (error) in
            if let error = error as? NSError {
                print("error occurred! -- %@", error.userInfo)
            }
        }, completed: {
            mainQueue.async {
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - IBAction Methods
    
    @IBAction func back(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? ReplyHeader.hottestReplyView() : ReplyHeader.lastestReplyView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.replyModels.count == 0 {
            return 40
        } else {
            return tableView.fd_heightForCell(withIdentifier: ID, cacheBy: indexPath, configuration: { (cell) in
                if let cell = cell as? ReplyCell {
                    self.configureCell(cell, atIndexPath: indexPath)
                }
            })
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.replyModels.count == 0 {
            return 1
        } else {
            return section == 0 ? viewModel.replyModels.count : viewModel.replyNormalModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.replyModels.count == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "     评论加载中..."
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ID, for: indexPath) as! ReplyCell
            configureCell(cell, atIndexPath: indexPath)
            return cell
        }
    }
    
    private func configureCell(_ cell: ReplyCell, atIndexPath indexPath: IndexPath) {
        let model: ReplyEntity
        if indexPath.section == 0 {
            model = viewModel.replyModels[indexPath.row]
        } else {
            model = viewModel.replyNormalModels[indexPath.row]
        }
        cell.replyModel = model
    }
    
}
