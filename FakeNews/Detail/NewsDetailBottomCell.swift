//
//  NewsDetailBottomCell.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/12/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit
import Kingfisher

class NewsDetailBottomCell: UITableViewCell {

    // MARK: - Properties
    
    var replyModel: ReplyEntity! {
        didSet {
            configureReplyCell()
        }
    }
    var sameNewsEntity: SimilarNewsEntity! {
        didSet {
            configureSameNewsCell()
        }
    }
    var isClosing: Bool = false {
        didSet {
            closeImg.image = UIImage(named: isClosing ? "newscontent_drag_return" : "newscontent_drag_arrow")
            closeLabel.text = isClosing ? "松手关闭当前页" : "上拉关闭当前页"
        }
    }
    
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
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
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
    
    // MARK: - Private Methods
    
    private func configureReplyCell() {
        userLabel.text = replyModel.name
        
        if let range = replyModel.address.range(of: "&") {
            replyModel.address = replyModel.address.substring(to: range.lowerBound)
        }
        userLocationLabel.text = "\(replyModel.address), \(replyModel.rtime)"
        replyDetail.text = replyModel.say
        goodLabel.text = "\(replyModel.suppose)顶"
        iconImg.kf.setImage(with: URL(string: replyModel.icon),
                            placeholder: UIImage(named: "comment_profile_mars"))
        iconImg.layer.cornerRadius = iconImg.width / 2
        iconImg.layer.masksToBounds = true
        iconImg.layer.shouldRasterize = true
    }
    
    private func configureSameNewsCell() {
        newsIcon.kf.setImage(with: URL(string: sameNewsEntity.imgsrc),
                             placeholder: UIImage(named: "303"))
        newsIcon.layer.cornerRadius = 2
        newsIcon.layer.masksToBounds = true
        newsIcon.layer.shouldRasterize = true
        newsTitleLabel.text = sameNewsEntity.title
        newsFromLabel.text = sameNewsEntity.title
        newsTimeLabel.text = sameNewsEntity.ptime
    }
    
}
