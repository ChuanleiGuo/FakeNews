//
//  AdManager.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/22/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

struct AdManager {
    
    private static let kCachedCurrentImage = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                                          .userDomainMask,
                                                                          true)[0].appending("/adcurrent.png")
    private static let kCachedNewImage = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                                      .userDomainMask,
                                                                      true)[0].appending("/adnew.png")
    static var shouldDisplayAd: Bool {
        return FileManager.default.fileExists(atPath: kCachedCurrentImage) ||
            FileManager.default.fileExists(atPath: kCachedNewImage)
    }
    
    static func getAdImage() -> UIImage? {
        if FileManager.default.fileExists(atPath: kCachedNewImage) {
            try? FileManager.default.removeItem(atPath: kCachedCurrentImage)
            try? FileManager.default.moveItem(atPath: kCachedNewImage, toPath: kCachedCurrentImage)
        }
//        if let imgData = try? Data(contentsOf: URL(string: kCachedCurrentImage)!) {
//            return UIImage(data: imgData)
//        } else {
//            return nil
//        }
        let imgData = NSData(contentsOfFile: kCachedCurrentImage)
        return UIImage(data: imgData as! Data)
    }
    
    static func loadLatestAdImage() {
        let now = Date().timeIntervalSince1970
        let path = String(format: "http://g1.163.com/madr?app=7A16FBB6&platform=ios&category=startup&location=1&timestamp=%ld", now)
        
        let session = URLSession.shared
        session.dataTask(with: URL(string: path)!) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data {
                
                let cfEnc = CFStringEncodings.GB_18030_2000
                let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
                let gb2312String = NSString(data: data, encoding: enc)!
                let utf8Data = gb2312String.data(using: String.Encoding.utf8.rawValue)!
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: utf8Data, options: []) as? [String: Any],
                        let ads = json["ads"] as? Array<[String: Any]>,
                        let res_urls1 = ads[0]["res_url"] as? [String] {
                        
                        let imgUrl = res_urls1[0]
                        var imgUrl2: String? = nil
                        
                        if ads.count > 1 {
                            if let res_urls2 = ads[1]["res_url"] as? [String] {
                                imgUrl2 = res_urls2[0]
                            }
                        }
                        
                        let one = UserDefaults.standard.bool(forKey: "one")
                        if let imgUrl2 = imgUrl2 {
                            if one {
                                downloadImage(imgUrl: imgUrl)
                            } else {
                                downloadImage(imgUrl: imgUrl2)
                            }
                            UserDefaults.standard.set(!one, forKey: "one")
                        } else {
                            downloadImage(imgUrl: imgUrl)
                        }
                    }
                        
                    
                } catch let jsonError {
                    print(jsonError)
                }
                
            }
        }.resume()
    }
    
    private static func downloadImage(imgUrl url: String) {
        guard let imgUrl = URL(string: url) else {
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: imgUrl) { (data, response, error) in
            if let data = data {
                let d = data as NSData
                d.write(toFile: kCachedNewImage, atomically: true)
            }
        }
        dataTask.resume()
    }
}
