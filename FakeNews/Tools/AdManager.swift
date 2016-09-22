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
        if let imgData = try? Data(contentsOf: URL(string: kCachedCurrentImage)!) {
            return UIImage(data: imgData)
        } else {
            return nil
        }
    }
    
    static func loadLatestAdImage() {
        let now = Date().timeIntervalSince1970
        let path = "http://g1.163.com/madr?app=7A16FBB6&platform=ios&category=startup&location=1&timestamp=\(now)"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: URL(string: path)!) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
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
        }
        dataTask.resume()
    }
    
    private static func downloadImage(imgUrl url: String) {
        guard let imgUrl = URL(string: url) else {
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: imgUrl) { (data, response, error) in
            if let data = data {
                try? data.write(to: URL(string: kCachedNewImage)!, options: [.atomic])
            }
        }
        dataTask.resume()
    }
}
