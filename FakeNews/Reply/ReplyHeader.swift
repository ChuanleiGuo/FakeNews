//
//  ReplyHeader.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/4/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class ReplyHeader: UIView {

    class func hottestReplyView() -> UIView {
        let views = Bundle.main.loadNibNamed("ReplyHeader", owner: nil, options: nil) as! [UIView]
        return views.first!
    }
    
    class func lastestReplyView() -> UIView {
        let views = Bundle.main.loadNibNamed("ReplyHeader", owner: nil, options: nil) as! [UIView]
        return views.last!
    }

}
