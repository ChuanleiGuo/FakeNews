//
//  NewsEntity.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/29/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class NewsEntity: NSObject {
    
    var tname: String = ""
    
    /**
     *  The publish time of the news
     */
    var ptime: String = ""
    
    /**
     *  Title
     */
    var title: String = ""
    
    /**
     *  The array of images
     */
    var imgextra: Array<[String: String]> = []
    var photosetID: String = ""
    var hasHead: NSNumber = false
    var hasImg: NSNumber = false
    var lmodify: String = ""
    var template: String = ""
    var skipType: String = ""
    
    /**
     *  The number of people who followed the thread
     */
    var replyCount: NSNumber = 0
    var votecount: NSNumber = 0
    var voteCount: NSNumber = 0
    var alias: String = ""
    
    /**
     *  The ID of the news
     */
    var docid: String = ""
    var hasCover: Bool = false
    var hasAD: NSNumber = false
    var priority: NSNumber = false
    var cid: String = ""
    var videoID: [String] = []
    
    /**
     *  The links to pictures
     */
    var imgsrc: String = ""
    var hasIcon: Bool = false
    var ename: String = ""
    var skipID: String = ""
    var order: NSNumber = 0
    
    /**
     *  Descriptions
     */
    var digest: String = ""
    var editor: [String] = []
    var url_3w: String = ""
    var specialID: String = ""
    var timeConsuming: String = ""
    var subtitle: String = ""
    var adTitle: String = ""
    var url: String = ""
    var scource: String = ""
    
    var TAGS: String = ""
    var TAG: String = ""
    
    /**
     *  The style of big picture
     */
    var imgType: NSNumber = 0
    var specialextra = [String]()
    
    var boardid: String = ""
    var commentid: String = ""
    var speciallogo: NSNumber = 0
    var specialtip: String = ""
    var specialadlogo: String = ""
    
    var pixel: String = ""
    var applist: [String] = []
    
    var wap_portal: String = ""
    var live_info: String = ""
    var ads: String = ""
    var videosource: String = ""
    
    class func newsModel(withDict dict: [String: Any]) -> NewsEntity {
        let model = NewsEntity()
        model.setValuesForKeys(dict)
        return model
    }
}
