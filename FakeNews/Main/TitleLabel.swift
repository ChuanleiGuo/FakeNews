//
//  TitleLabel.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/13/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class TitleLabel: UILabel {
    var scale: CGFloat = 0.0 {
        didSet {
            self.textColor = UIColor(red: scale, green: 0.0, blue: 0.0, alpha: 1)
            let minScale: CGFloat = 0.7
            let trueScale = minScale + (1 - minScale) * scale
            transform = CGAffineTransform(scaleX: trueScale, y: trueScale)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 18)
        scale = 0.0
    }
    
}
