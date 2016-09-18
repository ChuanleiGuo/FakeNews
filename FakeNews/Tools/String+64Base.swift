//
//  String+64Base.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/18/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import Foundation

extension String {
    
    var base64encode: String? {
        if let encodedData = data(using: .utf8) {
            return encodedData.base64EncodedString()
        }
        return nil
    }
    
    var base64decode: String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    var basicAuthString: String? {
        if let base64encode = base64encode {
            return "BASIC " + base64encode
        }
        return nil
    }
}
