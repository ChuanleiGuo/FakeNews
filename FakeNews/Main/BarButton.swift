//
//  BarButton.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/13/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class BarButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                isHighlighted = false
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let imageView = imageView, let titleLabel = titleLabel {
            imageView.frame = CGRect(x: (frame.width - imageView.width) / 2,
                                     y: 5, width: 25, height: 25)
            imageView.contentMode = .scaleAspectFit
            
            titleLabel.frame.origin = CGPoint(x: imageView.x - (titleLabel.width - imageView
                .width) / 2.0,
                                              y: imageView.frame.maxY + 2)
            titleLabel.font = UIFont(name: "HYQiHei", size: 10)
            titleLabel.shadowColor = UIColor.clear
            titleLabel.textAlignment = .center
        }
        
    }

}
