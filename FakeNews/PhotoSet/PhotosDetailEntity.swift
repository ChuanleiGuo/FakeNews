//
//  PhotosDetailEntity.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/31/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class PhotosDetailEntity: NSObject {
    // url of image
    var timgurl: String = ""
    // website linked by url
    var photohtml: String = ""
    var newsurl: String = ""
    var squareimgurl: String = ""
    var cimgurl: String = ""
    
    var imgtitle: String = ""
    var simgurl: String = ""
    
    var note: String = ""
    var photoid: String = ""
    
    var imgurl: String = ""
    
    class func photoDetail(withDict dict: [String: Any]) -> PhotosDetailEntity {
        let photoDetail = PhotosDetailEntity()
        photoDetail.setValuesForKeys(dict)
        
        return photoDetail
    }
}
