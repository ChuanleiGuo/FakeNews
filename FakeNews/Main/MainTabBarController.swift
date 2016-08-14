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
        
        let tabBar = TabBar()
        tabBar.frame = self.tabBar.bounds
        tabBar.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
        self.tabBar.addSubview(tabBar)
        tabBar.delegate = self
        
        tabBar.addImageView()
        
        tabBar.addBarButton(withNorName: "tabbar_icon_news_normal", disName: "tabbar_icon_news_highlight", title: "新闻")
        //tabBar.addBarButton(withNorName: "tabbar_icon_reader_normal", disName: "tabbar_icon_reader_highlight", title: "阅读")
        //tabBar.addBarButton(withNorName: "tabbar_icon_media_normal", disName: "tabbar_icon_media_highlight", title: "视听")
        //tabBar.addBarButton(withNorName: "tabbar_icon_found_normal", disName: "tabbar_icon_found_highlight", title: "发现")
        //tabBar.addBarButton(withNorName: "tabbar_icon_me_normal", disName: "tabbar_icon_me_highlight", title: "我")
        
        self.selectedIndex = 0
    }
}

extension MainTabBarController: TabBarDelegate {
    func changeSelectedIndex(from: Int, to: Int) {
        self.selectedIndex = to
    }
}
