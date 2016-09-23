//
//  NewsCell.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/29/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit
import Kingfisher

class NewsCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imgOther1: UIImageView!
    @IBOutlet weak var imgOther2: UIImageView!
    
    // MARK: - Properties
    
    var newsModel: NewsEntity! {
        didSet {
            configureCell()
        }
    }
    
    private func configureCell() {
        imgIcon.kf.setImage(with: URL(string: newsModel.imgsrc),
                            placeholder: UIImage(named: "302"))
        
        if titleLabel != nil {
            titleLabel.text = newsModel.title
        }
        
        if subtitleLabel != nil {
            subtitleLabel.text = newsModel.scource
        }
        
        let count = Float(newsModel.replyCount.intValue)
        let displayCount: String
        if count > 10000 {
            displayCount = String(format: "%.1f万跟帖", count / 10000)
        } else {
            displayCount = String(format: "%.0f跟帖", count)
        }
        if replyLabel != nil {
            replyLabel.text = displayCount
        }
        
        if newsModel.imgextra.count == 2 && imgOther1 != nil && imgOther2 != nil {
            imgOther1.kf.setImage(with: URL(string: newsModel.imgextra[0]["imgsrc"]!),
                                  placeholder: UIImage(named: "302"))
            imgOther2.kf.setImage(with: URL(string: newsModel.imgextra[1]["imgsrc"]!),
                                  placeholder: UIImage(named: "302"))
        }
    }
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /**
     *  Return the reuseable id
     */
    class func idForRow(newModel: NewsEntity) -> String {
        if newModel.hasHead.boolValue && newModel.photosetID != "" {
            return "TopImageCell"
        } else if newModel.hasHead.boolValue {
            return "TopTxtCell"
        } else if newModel.imgType.intValue != 0 {
            return "BigImageCell"
        } else if newModel.imgextra.count > 0 {
            return "ImagesCell"
        } else {
            return "NewsCell"
        }
    }
    
    class func heightForRow(newModel: NewsEntity) -> CGFloat {
        if newModel.hasHead.boolValue && newModel.photosetID != "" {
            return 215
        } else if newModel.hasHead.boolValue {
            return 215
        } else if newModel.imgType.intValue != 0 {
            return 170
        } else if newModel.imgextra.count > 0 {
            return 130
        } else {
            return 80
        }
    }

}
