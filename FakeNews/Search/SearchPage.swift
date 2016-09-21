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
    @IBOutlet weak var beginView: UIView!
    @IBOutlet weak var hotWordView: UIScrollView!
    
    // MARK: - Properties
    
    var keyword: String! = ""
    private var maxRight: CGFloat!
    private var maxBottom: CGFloat!
    private var searchLists: [SearchListEntity] = []
    private var hotwords: Array<[String: String]> = []
    
    private lazy var viewModel: SearchViewModel = {
        return SearchViewModel()
    }()
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        hotWordView.bounces = true
        maxRight = 0
        maxBottom = 10
        hotWordView.contentSize = hotWordView.frame.size
        hotWordView.showsHorizontalScrollIndicator = false
        hotWordView.showsVerticalScrollIndicator = false
        
        if keyword.characters.count > 0 {
            searchBar.text = keyword
            searchBarSearchButtonClicked(searchBar)
        }
        requestForHotWord()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController!.navigationBar.barTintColor = UIColor.white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchListCell.cell(with: tableView)!
        cell.model = searchLists[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("SearchListCell", owner: nil, options: nil)![1] as! UIView
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = NewsEntity()
        model.docid = searchLists[indexPath.row].docid
        
        let sb = UIStoryboard(name: "News", bundle: nil)
        let devc = sb.instantiateViewController(withIdentifier: "DetailPage") as! DetailPage
        devc.newsModel = model
        navigationController!.pushViewController(devc, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
        if searchText.characters.count < 1 {
            tableView.isHidden = true
            beginView.isHidden = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        viewModel.fetchSearchResultCommand.execute(nil).subscribeNext { [unowned self] (x) in
            self.searchLists = (SearchListEntity.mj_objectArray(withKeyValuesArray: x) as NSArray) as! [SearchListEntity]
            
            let q = DispatchQueue.main
            q.async {
                self.tableView.reloadData()
                self.beginView.isHidden = true
                self.tableView.isHidden = false
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func requestForHotWord() {
        viewModel.fetchHotWordCommand.execute(nil).subscribeNext { [unowned self] (x) in
            let q = DispatchQueue.main
            
            self.hotwords = x as! Array<[String: String]>
            q.async {
                self.addHotWordInHotWordView()
            }
        }
    }
    
    private func addHotWordInHotWordView() {
        for dict in hotwords {
            addKeyWordBtn(withTitle: dict["hotWord"]!)
        }
    }
    
    private func addKeyWordBtn(withTitle title: String) {
        let button = UIButton(frame: CGRect(x: maxRight, y: maxBottom, width: 0, height: 0))
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(red: 220 / 225.0,
                                           green: 220 / 225.0,
                                           blue: 220 / 225.0,
                                           alpha: 1.0).cgColor
        button.layer.cornerRadius = 2
        button.layer.masksToBounds = true
        button.sizeToFit()
        
        button.width += 15
        button.height += 34

        button.addTarget(self, action: #selector(self.buttonClick(_:)), for: .touchUpInside)
        
        hotWordView.addSubview(button)
        maxRight = button.width + button.x + 10
        
        if maxRight > hotWordView.width {
            maxRight = 0
            maxBottom = maxBottom + CGFloat(48.0)
            button.x = maxRight
            button.y = maxBottom
            maxRight = button.width + button.x + 10
        }
    }
    
    @objc func buttonClick(_ sender: UIButton) {
        searchBar.text = sender.currentTitle
        searchBar(searchBar, textDidChange: sender.currentTitle!)
        searchBarSearchButtonClicked(searchBar)
    }
    
}
