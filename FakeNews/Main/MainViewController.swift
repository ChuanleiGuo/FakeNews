//
//  MainViewController.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/15/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    /* title scroll view */
    @IBOutlet weak var smallScorllView: UIScrollView!
    
    /* content scroll view*/
    @IBOutlet weak var bigScrollView: UIScrollView!
    
    var rightItem: UIButton!
    
    // MARK: lazy load
    
    private lazy var urlEntities: NSArray! = {
        guard let filePath = Bundle.main.path(forResource: "NewsURLs.plist", ofType: nil) else {
            return nil
        }
        return NSArray(contentsOfFile: filePath)
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        smallScorllView.showsVerticalScrollIndicator = false
        smallScorllView.showsHorizontalScrollIndicator = false
        smallScorllView.scrollsToTop = false
        addTitleLabels()
        
        rightItem = UIButton()
        if let win = UIApplication.shared.windows.first {
            win.addSubview(rightItem)
            rightItem.y = 20
            rightItem.width = 45
            rightItem.height = 45
            rightItem.addTarget(self, action: #selector(rightItemClicked), for: .touchUpInside)
            rightItem.x = UIScreen.main.bounds.size.width - rightItem.width
            rightItem.setImage(UIImage(named:"top_navigation_square"), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rightItem.isHidden = false
        if UserDefaults.standard.bool(forKey: "rightItem") {
            rightItem.isHidden = true
            UserDefaults.standard.set(false, forKey: "rightItem")
        }
        rightItem.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.rightItem.alpha = 1
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        rightItem.isHidden = true
        rightItem.transform = .identity
        rightItem.setImage(UIImage(named:"top_navigation_square"), for: .normal)
    }
    
    // MARK: - Private Methods
    
    private func showRightItem() {
        rightItem.isHidden = false
    }
    
    // MARK: add components
    
    private func addControllers() {
        
    }
    
    private func addTitleLabels() {
        for i in 0..<8 {
            let labelWidth: CGFloat = 70
            let labelHeight: CGFloat = 40
            let labelX: CGFloat = CGFloat(i) * labelWidth
            let labelY: CGFloat = 0
            
            let label = TitleLabel()
            //let vc = childViewControllers[i]
            //label.text = vc.title
            
            let item = urlEntities[i] as! [String: String]
            label.text = item["title"]
            
            label.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
            label.font = UIFont(name: "HYQiHei", size: 19)
            smallScorllView.addSubview(label)
            label.tag = i
            label.isUserInteractionEnabled = true
            
            label.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(titleLabelClickd(recognizer:))))
        }
        smallScorllView.contentSize = CGSize(width: 70 * 8, height: 0)
    }
    
    @objc private func titleLabelClickd(recognizer: UITapGestureRecognizer) {
        if let titleLabel = recognizer.view as? TitleLabel {
            let offsetX: CGFloat = CGFloat(titleLabel.tag) * bigScrollView.width
            let offsetY = bigScrollView.contentOffset.y
            let offset = CGPoint(x: offsetX, y: offsetY)
            
            bigScrollView.setContentOffset(offset, animated: true)
            
            // TODO: Scroll to Top
        }
    }
    
    @objc private func rightItemClicked() {
        // TODO:
    }
}



extension MainViewController {
    
    
    // MARK: scroll to top
    
    
}
