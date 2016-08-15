//
//  TabBar.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/13/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

protocol TabBarDelegate: class {
    func changeSelectedIndex(from: Int, to: Int)
}

class TabBar: UIView {

    weak var delegate: TabBarDelegate?
    
    var selectedButton: BarButton!
    var imgView: UIImageView!
    
    func addImageView() {
        imgView = UIImageView(image: UIImage(named: ""))
        self.addSubview(imgView)
    }
    
    
    func addBarButton(withNorName nor: String, disName dis: String, title: String) {
        let btn = BarButton()
        btn.setImage(UIImage(named: nor), for: .normal)
        btn.setImage(UIImage(named: dis), for: .disabled)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor(red: 149/255.0, green: 149/255.0, blue: 149/255.0, alpha: 1),
                          for: .normal)
        btn.setTitleColor(UIColor(red: 183/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1),
                          for: .disabled)
        
        btn.addTarget(self, action: #selector(btnClicked(btn:)), for: .touchDown)
        
        self.addSubview(btn)
        
        if self.subviews.count == 2 {
            btn.tag = 1
            selectedButton = btn
            btnClicked(btn: btn)
        }
    
    }
    
    override func layoutSubviews() {
        let imageView = subviews[0]
        imageView.frame = bounds
        
        for i in 1..<subviews.count {
            let btn = subviews[i]
            
            let btnW: CGFloat = UIScreen.main.bounds.size.width / 5
            let btnH: CGFloat = 49
            let btnX: CGFloat = CGFloat(i - 1) * btnW
            let btnY: CGFloat = 0
            btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            
            btn.tag = i - 1
        }
    }
    
    func btnClicked(btn: BarButton) {
        delegate?.changeSelectedIndex(from: selectedButton.tag, to: btn.tag)
        
        selectedButton.isEnabled = true
        selectedButton = btn
        btn.isEnabled = false
    }
}
