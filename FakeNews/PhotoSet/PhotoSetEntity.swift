//
//  PhotoSetEntity.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/1/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class PhotoSetEntity: NSObject {
    
    var postid: String = ""
    var series: String = ""
    var desc: String = ""
    var datatime: String = ""
    
    var createdate: String = ""
    var relatedids: String = ""
    
    var scover: String = ""
    var autoid: String = ""
    var url: String = ""
    var creator: String = ""
    
    var photos: NSArray = []
    var reporter: String = ""
    var setname: String = ""
    var cover: String = ""
    var commenturl: String = ""
    var source: String = ""
    var settag: String = ""
    
    var boardid: String = ""
    var tcover: String = ""
    
    var imgsum: NSNumber = 0
    var clientadurl: String = ""
    
    //class func photoSet(withDict dict: [String: Any]) -> PhotoSetEntity {
    //    let photoSet = PhotoSetEntity()
    //    photoSet.setValuesForKeys(dict)
        
    //    let photoArray = photoSet.photos
    //    var temArray = [PhotosDetailEntity]()
        
    //    for d in photoArray {
    //        let photoModel = PhotosDetailEntity.photoDetail(withDict: d as! [String: Any])
    //        temArray.append(photoModel)
    //    }
    //    photoSet.photos = temArray as NSArray
    //    return photoSet
    //}
}
