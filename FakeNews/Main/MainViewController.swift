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
    var weatherView: WeatherView!
    var isWeatherShown = false
    var transImageView: UIImageView!
    
    @IBOutlet weak var topToTop: NSLayoutConstraint!
    var needScrollToTopPage: NewsTableViewPage!
    
    // MARK: lazy load
    
    private lazy var urlEntities: Array<[String: String]>! = {
        guard let filePath = Bundle.main.path(forResource: "NewsURLs.plist", ofType: nil) else {
            return nil
        }
        return NSArray(contentsOfFile: filePath) as! Array<[String: String]>
    }()
    
    private lazy var weatherViewModel: WeatherViewModel = {
        return WeatherViewModel()
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showRightItem),
                                               name: Notification.Name("AdvertisementKey"),
                                               object: nil)
        
        automaticallyAdjustsScrollViewInsets = false
        smallScorllView.showsVerticalScrollIndicator = false
        smallScorllView.showsHorizontalScrollIndicator = false
        smallScorllView.scrollsToTop = false
        bigScrollView.scrollsToTop = false
        bigScrollView.delegate = self
        
        addControllers()
        addTitleLabels()
        
        let contentX = CGFloat(childViewControllers.count) * UIScreen.main.bounds.size.width
        bigScrollView.contentSize = CGSize(width: contentX, height: 0)
        bigScrollView.isPagingEnabled = true
        
        if let vc = childViewControllers.first, let label = smallScorllView.subviews.first as? TitleLabel {
            vc.view.frame = bigScrollView.bounds
            bigScrollView.addSubview(vc.view)
            label.scale = 1.0
            bigScrollView.showsHorizontalScrollIndicator = false
        }
        
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
        
        needScrollToTopPage = childViewControllers[0] as! NewsTableViewPage
        sendWeatherRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if UserDefaults.standard.bool(forKey: "top20") {
//            topToTop.constant = 20
//            UserDefaults.standard.set(false, forKey: "top20")
//        } else {
//            topToTop.constant = 0
//        }
        
        navigationController!.navigationBar.barTintColor = UIColor.red
        
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
    
    @objc private func showRightItem() {
        rightItem.isHidden = false
    }
    
    // MARK: add components
    
    private func addControllers() {
        for i in 0..<urlEntities.count {
            guard let vc = UIStoryboard(name: "News", bundle: Bundle.main)
                .instantiateInitialViewController() as? NewsTableViewPage else {
                return
            }
            vc.title = urlEntities[i]["title"]
            vc.urlString = urlEntities[i]["urlString"]
            addChildViewController(vc)
        }
    }
    
    private func addTitleLabels() {
        for i in 0..<8 {
            let labelWidth: CGFloat = 80
            let labelHeight: CGFloat = 40
            let labelX: CGFloat = CGFloat(i) * labelWidth * 0.8
            let labelY: CGFloat = 0
            //let labelFrame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
            
            let label = TitleLabel()
            let vc = childViewControllers[i]
            label.text = vc.title
            label.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
            label.scale = 0.0
            
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
            setScrollToTopPage(withIndex: titleLabel.tag)
        }
    }
    
    @objc private func rightItemClicked() {
        if isWeatherShown {
            weatherView.isHidden = true
            transImageView.isHidden = true
            UIView.animate(withDuration: 0.1, animations: {
                let transform = self.rightItem.transform
                self.rightItem.transform = transform.rotated(by: (1 / CGFloat.pi) * 5)
            }, completion: { (finished) in
                self.rightItem.setImage(UIImage(named: "top_navigation_square"), for: .normal)
            })
        } else {
            rightItem.setImage(UIImage(named: "223"), for: .normal)
            weatherView.isHidden = false
            transImageView.isHidden = false
            weatherView.addAnimate()
            UIView.animate(withDuration: 0.2, animations: {
                let transform = self.rightItem.transform
                self.rightItem.transform = transform.rotated(by: -(1 / CGFloat.pi) * 6)
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.1, animations: { 
                    let transform = self.rightItem.transform
                    self.rightItem.transform = transform.rotated(by: (1 / CGFloat.pi))
                })
            })
        }
        isWeatherShown = !isWeatherShown
    }
    
    // MARK: Weather
    
    private func addWeather(weatherModel: WeatherEntity) {
        
        weatherView = WeatherView.view()
        weatherView.weatherModel = weatherModel
        weatherView.alpha = 0.9
        let win = UIApplication.shared.windows.first!
        win.addSubview(weatherView)
        
        transImageView = UIImageView(image: UIImage(named: "224"))
        transImageView.width = 7
        transImageView.height = 7
        transImageView.y = 57
        transImageView.x = UIScreen.main.bounds.size.width - 33
        win.addSubview(transImageView)
        
        weatherView.frame = UIScreen.main.bounds
        weatherView.y = 64
        weatherView.height -= 64
        weatherView.isHidden = true
        transImageView.isHidden = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pushWeatherDetail),
                                               name: NSNotification.Name(rawValue: "pushWeatherDetail"),
                                               object: nil)
    }
    
    private func sendWeatherRequest() {
        weatherViewModel.fatchWeather { [unowned self] in
            if let weatherModel = self.weatherViewModel.weatherModel {
                self.addWeather(weatherModel: weatherModel)
            }
        }
    }
    
    @objc private func pushWeatherDetail() {
        if let weatherModel =  weatherViewModel.weatherModel {
            isWeatherShown = false
            let weatherDetailPage = WeatherDetailPage()
            weatherDetailPage.weatherModel = weatherModel
            navigationController!.pushViewController(weatherDetailPage, animated: true)
            UIView.animate(withDuration: 0.1, animations: { 
                self.weatherView.alpha = 0
            }, completion: { (finished) in
                self.weatherView.alpha = 0.9
                self.weatherView.isHidden = true
                self.transImageView.isHidden = true
            })
        }
        
    }
    
}

extension MainViewController: UIScrollViewDelegate {
    
    
    // MARK: scroll to top
    func setScrollToTopPage(withIndex index: Int) {
        needScrollToTopPage.tableView.scrollsToTop = false
        needScrollToTopPage = childViewControllers[index] as! NewsTableViewPage
        needScrollToTopPage.tableView.scrollsToTop = true
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / bigScrollView.width)
        
        let titleLabel = smallScorllView.subviews[index] as! TitleLabel
        
        var offsetX = titleLabel.center.x - smallScorllView.width * 0.5
        let offsetMax = smallScorllView.contentSize.width - smallScorllView.width
        if offsetX < 0 {
            offsetX = 0
        } else if offsetX > offsetMax {
            offsetX = offsetMax
        }
        
        let offset = CGPoint(x: offsetX, y: smallScorllView.contentOffset.y)
        smallScorllView.setContentOffset(offset, animated: true)
        for (idx, label) in smallScorllView.subviews.enumerated() {
            if idx != index {
                (label as! TitleLabel).scale = 0.0
            }
        }
        
        let newVC = childViewControllers[index] as! NewsTableViewPage
        newVC.index = index
        setScrollToTopPage(withIndex: index)
        
        if newVC.view.superview != nil {
            return
        }
        
        newVC.view.frame = scrollView.bounds
        bigScrollView.addSubview(newVC.view)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = abs(scrollView.contentOffset.x / scrollView.width)
        let leftIndex = Int(value)
        let rightIndex = leftIndex + 1
        let scaleRight = value - CGFloat(leftIndex)
        let scaleLeft = 1 - scaleRight
        
        let labelLeft = smallScorllView.subviews[leftIndex] as! TitleLabel
        labelLeft.scale = scaleLeft
        
        if rightIndex < smallScorllView.subviews.count {
            let labelRight = smallScorllView.subviews[rightIndex] as! TitleLabel
            labelRight.scale = scaleRight
        }
    }
}
