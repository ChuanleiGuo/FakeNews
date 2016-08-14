//
//  UIView+Frame.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/14/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

extension UIView {
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newX) {
            var frame = self.frame
            frame.origin.x = newX
            self.frame = frame
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newY) {
            var frame = self.frame
            frame.origin.y = newY
            self.frame = frame
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newW) {
            var frame = self.frame
            frame.size.width = newW
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newH) {
            var frame = self.frame
            frame.size.height = newH
            self.frame = frame
        }
    }
}
