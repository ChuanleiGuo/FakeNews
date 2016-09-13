//
//  DetailPage.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/12/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class DetailPage: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {
    
    // MARK: - Properties
    
    var newsModel: NewsEntity!
    var index: Int!
    
    var webView: UIWebView!
    var news = [NewsEntity]()
    var bigImg: UIImageView!
    var hoverView: UIView!
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var replyCountBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MAKR: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
