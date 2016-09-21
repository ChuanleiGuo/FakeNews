//
//  SearchListCell.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/19/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class SearchListCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Properties
    
    var model: SearchListEntity! {
        didSet {
            var s = model.title
            var replaceRange = s.startIndex..<s.endIndex
            s = s.replacingOccurrences(of: "<em>", with: "<", options: .caseInsensitive, range: replaceRange)
            
            replaceRange = s.startIndex..<s.endIndex
            s = s.replacingOccurrences(of: "</em>", with: ">", options: .caseInsensitive, range: replaceRange)
            titleLabel.setColoredText(s)
            timeLabel.text = model.ptime
        }
    }
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func cell(with tableView: UITableView) -> SearchListCell! {
        let ID = "SearchListCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ID) as? SearchListCell else {
            let cell = Bundle.main.loadNibNamed("SearchListCell", owner: nil, options: nil)![0] as! SearchListCell
            return cell
        }
        
        return cell
    }
}
