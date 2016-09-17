//
//  SearchPage.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/17/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class SearchPage: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var benginView: UIView!
    @IBOutlet weak var hotWordView: UIScrollView!
    
    // MARK: - Properties
    
    var keyword: String!
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
