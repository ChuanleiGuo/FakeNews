//
//  UIImageView+DownloadImage.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/28/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(withURL url: URL, placeHolderImage: UIImage) {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url) {
            [weak self] (url, response, error) in
            if error == nil, let url = url {
                
                let data = try? Data(contentsOf: url)
                let image: UIImage?
                if let data = data {
                    image = UIImage(data: data)
                } else {
                    image = placeHolderImage
                }
                
                let queue = DispatchQueue.main
                queue.async {
                    if let strongSelf = self {
                        strongSelf.image = image
                    }
                }
            }
        }
        
        downloadTask.resume()
    }
}
