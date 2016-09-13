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
}
