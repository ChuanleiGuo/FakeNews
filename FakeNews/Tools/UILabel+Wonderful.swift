//
//  UILabel+Wonderful.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/19/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

fileprivate var ColorLabelAnotherColor: UIColor = UIColor.red
fileprivate var ColorLabelAnoterFont: UIFont = UIFont.boldSystemFont(ofSize: 18)

enum LabelType {
    case color
    case font
}

extension UILabel {
    
    /// Set text which contains color mark
    ///
    /// - parameter text: Text with color mark
    func setColoredText(_ text: String) {
        if text.range(of: "<") != nil {
            var mStr = text
            let ranges = scan(beginString: "<", endString: ">", inText: &mStr)
            var attributedStr = NSMutableAttributedString(string: mStr)
            attributedStr = add(attributedString: attributedStr, withRanges: ranges, type: .color)
            attributedText = attributedStr
        } else {
            self.text = text
        }
    }
    
    /// Set text which contains font mark
    ///
    /// - parameter text: Text with font mark
    func setFontedText(_ text: String) {
        if text.range(of: "[") != nil {
            var mStr = text
            let ranges = scan(beginString: "[", endString: "]", inText: &mStr)
            var attributedStr = NSMutableAttributedString(string: mStr)
            attributedStr = add(attributedString: attributedStr, withRanges: ranges, type: .font)
            attributedText = attributedStr
        } else {
            self.text = text
        }
    }
    
    /// Set text which contains color and font mark
    ///
    /// - parameter text: Text with color and font mark
    func setColoredFontedText(_ text: String) {
        if text.range(of: "<") != nil || text.range(of: "[") != nil {
            var mStr1 = text
            var mStr2 = text
            
            mStr1 = mStr1.replacingOccurrences(of: "[",
                                               with: "",
                                               options: .caseInsensitive,
                                               range: mStr1.startIndex..<mStr1.endIndex)
            mStr1 = mStr1.replacingOccurrences(of: "]",
                                               with: "",
                                               options: .caseInsensitive,
                                               range: mStr1.startIndex..<mStr1.endIndex)
            
            mStr2 = mStr1.replacingOccurrences(of: "<",
                                               with: "",
                                               options: .caseInsensitive,
                                               range: mStr2.startIndex..<mStr2.endIndex)
            mStr2 = mStr1.replacingOccurrences(of: ">",
                                               with: "",
                                               options: .caseInsensitive,
                                               range: mStr2.startIndex..<mStr2.endIndex)
            
            var attributedString = NSMutableAttributedString(string: mStr1)
            let colorRanges = scan(beginString: "<", endString: ">", inText: &mStr1)
            let fontRanges = scan(beginString: "[", endString: "]", inText: &mStr2)
            attributedString = add(attributedString: attributedString,
                                   withRanges: colorRanges,
                                   type: .color)
            attributedString = add(attributedString: attributedString,
                                   withRanges: fontRanges,
                                   type: .font)
            attributedText = attributedString
        } else {
            self.text = text
        }
    }
    
    /// Set a highlight color to show emphasis between the beginmark and endmark
    ///
    /// - parameter color: A color different from label.TextColor
    class func setAnotherColor(_ color: UIColor) {
        ColorLabelAnotherColor = color
    }
    
    /// Set a highlight font to show emphasis between the beginmark and endmark
    ///
    /// - parameter font: A font different from label.font
    class func setAnotherFont(_ font: UIFont) {
        ColorLabelAnoterFont = font
    }
    
    // MARK: - private methods
    
    private func scan(beginString: String,
                      endString: String,
                      inText text: inout String) -> [NSRange] {
        
        var mString = text as NSString
        var range1 = NSMakeRange(0, 0)
        var range2 = NSMakeRange(0, 0)
        var ranges = [NSRange]()
        
        while range1.location != NSNotFound {
            range1 = mString.range(of: beginString)
            range2 = mString.range(of: endString)
            var location = 0, length = 0
            if range1.location != NSNotFound {
                location = range1.location
                length = range2.location - range1.location - 1
                
                if length > 5000 {
                    break
                }
                mString = mString.replacingOccurrences(of: beginString,
                                                       with: "",
                                                       options: .caseInsensitive,
                                                       range: range1) as NSString
                mString = mString.replacingOccurrences(of: endString,
                                                       with: "",
                                                       options: .caseInsensitive,
                                                       range: range2) as NSString
                ranges.append(NSMakeRange(location, length))
            }
        }
        
        text = mString as String
        
        return ranges
    }
    
    private func add(attributedString: NSMutableAttributedString,
                     withRanges ranges: [NSRange],
                     type: LabelType) -> NSMutableAttributedString {
        let key: String
        let value: AnyObject
        switch type {
        case .color:
            key = NSForegroundColorAttributeName
            value = ColorLabelAnotherColor
        case .font:
            key = NSFontAttributeName
            value = ColorLabelAnoterFont
        }
        
        for range in ranges {
            attributedString.addAttribute(key, value: value, range: range)
        }
        return attributedString
    }
}
