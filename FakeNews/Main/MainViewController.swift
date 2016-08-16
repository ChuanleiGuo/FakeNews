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
    
    // MARK: lazy load
    
    private lazy var arrayLists: NSArray! = {
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Methods
    
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
            
            let item = arrayLists[i] as! [String: String]
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
}



extension MainViewController {
    
    
    // MARK: scroll to top
    
    
}
