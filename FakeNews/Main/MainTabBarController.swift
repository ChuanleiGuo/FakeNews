//
//  MainTabBarController.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/12/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AdManager.loadLatestAdImage()
        
        if AdManager.shouldDisplayAd {
            UserDefaults.standard.set(true, forKey: "top20")
            UserDefaults.standard.set(true, forKey: "rightItem")
            
            let adView = UIView(frame: UIScreen.main.bounds)
            let adImg = UIImageView(image: AdManager.getAdImage())
            let adBottomImg = UIImageView(image: UIImage(named: "adBottom.png"))
            adView.addSubview(adBottomImg)
            adView.addSubview(adImg)
            adBottomImg.frame = CGRect(x: 0, y: view.height - 135, width: view.width, height: 135)
            adImg.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height - 135)
            
            adView.alpha = 0.99
            view.addSubview(adView)
            UIApplication.shared.isStatusBarHidden = true
            
            UIView.animate(withDuration: 3, animations: { 
                adView.alpha = 1.0
            }, completion: { (finished) in
                UIApplication.shared.isStatusBarHidden = false
                
                UIView.animate(withDuration: 0.5, animations: { 
                    adView.alpha = 0.0
                }, completion: { (finished) in
                    adView.removeFromSuperview()
                })
                NotificationCenter.default.post(name: NSNotification.Name("AdvertisementKey"), object: nil)
            })
        } else {
            UserDefaults.standard.set(true, forKey: "update")
        }       
        let tabBar = TabBar()
        tabBar.frame = self.tabBar.bounds
        tabBar.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
        self.tabBar.addSubview(tabBar)
        tabBar.delegate = self
        
        tabBar.addImageView()
        
        tabBar.addBarButton(withNorName: "tabbar_icon_news_normal", disName: "tabbar_icon_news_highlight", title: "新闻")
        tabBar.addBarButton(withNorName: "tabbar_icon_reader_normal", disName: "tabbar_icon_reader_highlight", title: "阅读")
        tabBar.addBarButton(withNorName: "tabbar_icon_media_normal", disName: "tabbar_icon_media_highlight", title: "视听")
        tabBar.addBarButton(withNorName: "tabbar_icon_found_normal", disName: "tabbar_icon_found_highlight", title: "发现")
        tabBar.addBarButton(withNorName: "tabbar_icon_me_normal", disName: "tabbar_icon_me_highlight", title: "我")
        
        self.selectedIndex = 0
    }
}

extension MainTabBarController: TabBarDelegate {
    func changeSelectedIndex(from: Int, to: Int) {
        self.selectedIndex = to
    }
}
