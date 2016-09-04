//
//  DetailImgEntity.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/4/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class DetailImgEntity: NSObject {
    var src: String = ""
    // size of the image
    var pixel: String = ""
    // location of the image
    var ref: String = ""
    
    class func detailImg(withDict dict: [String: String]) -> DetailImgEntity {
        let imgModel = DetailImgEntity()
        imgModel.src = dict["src"] ?? ""
        imgModel.pixel = dict["pixel"] ?? ""
        imgModel.ref = dict["ref"] ?? ""
        return imgModel
    }
}
