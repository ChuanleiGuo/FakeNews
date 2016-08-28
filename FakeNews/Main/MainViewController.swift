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
    
    // MARK: lazy load
    
    private lazy var urlEntities: NSArray! = {
        guard let filePath = Bundle.main.path(forResource: "NewsURLs.plist", ofType: nil) else {
            return nil
        }
        return NSArray(contentsOfFile: filePath)
    }()
    
    private lazy var weatherViewModel: WeatherViewModel = {
        return WeatherViewModel()
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
        
        sendWeatherRequest()
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
        //let weatherDetails: [WeatherDetailEntity] = [
         //   WeatherDetailEntity(wind: "北风", lunar: "八月初七", date: "8月24日", climate: "雷阵雨", temperature: "35C", week: "星期二"),
        //    WeatherDetailEntity(wind: "北风", lunar: "八月初七", date: "8月24日", climate: "雷阵雨", temperature: "35C", week: "星期二"),
       //     WeatherDetailEntity(wind: "北风", lunar: "八月初七", date: "8月24日", climate: "雷阵雨", temperature: "35C", week: "星期二"),
       //     WeatherDetailEntity(wind: "北风", lunar: "八月初七", date: "8月24日", climate: "雷阵雨", temperature: "35C", week: "星期二"),
       // ];
       // let weatherBgEntity = WeatherBgEntity(background1: "", background2: "", aqi: "33", pm2_5: "125")
        //let weatherModel = WeatherEntity(detailEntities: weatherDetails, pm2_5Entity: weatherBgEntity, date: "8月14日", rt_temperature: 27)
        
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



extension MainViewController {
    
    
    // MARK: scroll to top
    
    
}
