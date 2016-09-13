//
//  NewsDetailBottomCell.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/12/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class NewsDetailBottomCell: UITableViewCell {

    // MARK: - Properties
    
    var replyModel: ReplyEntity!
    var sameNewsEntity: SimilarNewsEntity!
    var isClosing: Bool = false
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var sectionHeaderLabel: UILabel!
    
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var goodLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var replyDetail: UILabel!
    
    @IBOutlet weak var newsIcon: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsFromLabel: UILabel!
    @IBOutlet weak var newsTimeLabel: UILabel!
    
    @IBOutlet weak var closeImg: UIImageView!
    @IBOutlet weak var closeLabel: UILabel!
    
    // MAKR: - Cell
    
    
    private static let nibFileName = "NewsDetailBottomCell"
    
    class func theShareCell() -> NewsDetailBottomCell {
        return Bundle.main.loadNibNamed(nibFileName, owner: nil, options: nil)![0] as! NewsDetailBottomCell
    }
    
    class func theSectionHeaderCell() -> NewsDetailBottomCell {
        return Bundle.main.loadNibNamed(nibFileName, owner: nil, options: nil)![1] as! NewsDetailBottomCell
    }
    
    class func theSectionBottomCell() -> NewsDetailBottomCell {
        return Bundle.main.loadNibNamed(nibFileName, owner: nil, options: nil)![2] as! NewsDetailBottomCell
    }
    
    class func theHotReplyCell(withTableView tableView: UITableView) -> NewsDetailBottomCell {
        let id = "horreplycell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: id) as? NewsDetailBottomCell else {
            let cell = Bundle.main.loadNibNamed(nibFileName, owner: nil, options: nil)![3] as! NewsDetailBottomCell
            return cell
        }
        
        return cell
    }
    
    class func theContactNewsCell() -> NewsDetailBottomCell {
        return Bundle.main.loadNibNamed(nibFileName, owner: nil, options: nil)![4] as! NewsDetailBottomCell
    }
    
    class func theCloseCell() -> NewsDetailBottomCell {
        return Bundle.main.loadNibNamed(nibFileName, owner: nil, options: nil)![5] as! NewsDetailBottomCell
    }
    
    class func theKeywordCell() -> NewsDetailBottomCell {
        return Bundle.main.loadNibNamed(nibFileName, owner: nil, options: nil)![6] as! NewsDetailBottomCell
    }
    
}
