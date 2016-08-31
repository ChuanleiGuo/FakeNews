//
//  PhotoSetPage.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/31/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class PhotoSetPage: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var contentText: UITextView!
    
    // MARK: - Properties
    var newsModel: NewsEntity!
    
    private lazy var news: Array<[String: String]>! = {
        guard let filePath = Bundle.main.path(forResource: "NewsURLs.plist", ofType: nil) else {
            return nil
        }
        return NSArray(contentsOfFile: filePath) as! Array<[String: String]>
    }()
    
    // MARK: - IBAction Method
    
    @IBAction func returnBtnClicked(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
        navigationController!.setNavigationBarHidden(false, animated: true)
    }
    
}

extension PhotoSetPage: UIScrollViewDelegate {
    
}
