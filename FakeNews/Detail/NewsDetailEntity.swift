//
//  NewsDetailEntity.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/4/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class NewsDetailEntity: NSObject {
    var title: String = ""
    var ptime: String = ""
    var body: String = ""
    var imgs: [DetailImgEntity] = []
    var replyBoard: String = ""
    var replyCount: Int = 0

    class func detail(withDict dict: [String: Any]) -> NewsDetailEntity {
        let detail = NewsDetailEntity()
        detail.title = (dict["title"] as? String) ?? ""
        detail.ptime = (dict["ptime"] as? String) ?? ""
        detail.body = (dict["body"] as? String) ?? ""
        detail.replyBoard = (dict["replyBoard"] as? String) ?? ""
        if let count = dict["replyCount"] as? NSNumber {
            detail.replyCount = count.intValue
        } else {
            detail.replyCount = 0
        }
        
        var tempArray = [DetailImgEntity]()
        let imgArray = dict["img"] as! Array<[String: String]>
        
        for d in imgArray {
            let imgModel = DetailImgEntity.detailImg(withDict: d)
            tempArray.append(imgModel)
        }
        detail.imgs = tempArray
        
        return detail
    }
}
