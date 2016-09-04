//
//  ReplyCell.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/4/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class ReplyCell: UITableViewCell {
    
    // MARK: - Properties
    
    var replyModel: ReplyEntity! {
        didSet {
            configureCell(withModel: replyModel)
        }
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var sayLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var supposeLabel: UILabel!
    
    
    // MARK: - Private Methods
    
    private func configureCell(withModel model: ReplyEntity) {
        nameLabel.text = replyModel.name
        
        addressLabel.text = replyModel.address
        if let rangeAddress = replyModel.address.range(of: "&nbsp") {
            addressLabel.text = replyModel.address.substring(to: rangeAddress.lowerBound)
        }
        
        sayLabel.text = replyModel.say
        if let _ = replyModel.say.range(of: "<br>") {
            var temp = replyModel.say
            temp = temp.replacingOccurrences(of: "<br>", with: "\n",
                                      options: .caseInsensitive, range: temp.startIndex..<temp.endIndex)
            sayLabel.text = temp
        }
        supposeLabel.text = replyModel.suppose
        selectionStyle = .none
    }
}
