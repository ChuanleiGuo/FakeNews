//
//  UIView+Frame.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/14/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

// MARK: - Frame

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

// MARK: - Gesture

extension UIView {
    func addTapAction(_ tapAction: Selector, target: AnyObject) {
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: target, action: tapAction)
        addGestureRecognizer(gesture)
    }
}
