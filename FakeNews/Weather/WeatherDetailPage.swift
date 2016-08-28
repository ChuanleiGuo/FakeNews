//
//  WeatherDetailPage.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/18/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

fileprivate let screenWidth = UIScreen.main.bounds.size.width

class WeatherDetailPage: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    var weatherModel: WeatherEntity!
    var bottomView: UIView!
    
    // MARK: IBOutlet
    
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var dateWeekLabel: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var climateLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var airPMLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomView = UIView()
        view.addSubview(bottomView)
        bottomView.height = 250
        bottomView.width = screenWidth
        bottomView.x = 0
        bottomView.y = UIScreen.main.bounds.size.height - bottomView.height
        bottomView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        addWeather()
        for i in 1..<4 {
            let weatherDetail = weatherModel.detailEntities[i]
            addItem(withTitle: weatherDetail.week, weather: weatherDetail.climate,
                    wind: weatherDetail.wind, temp: weatherDetail.temperature, index: i - 1)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - IBAction
    
    @IBAction func back() {
        navigationController!.popViewController(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func addItem(withTitle title: String, weather: String, wind: String, temp: String, index: Int) {
        let itemView = WeatherItemView.view()
        itemView.width = screenWidth / 3
        itemView.y = 0
        itemView.height = 200
        itemView.x = CGFloat(index) * itemView.width
        
        itemView.weather = weather
        itemView.titleLabel.text = title
        var temp = temp
        temp = temp.replacingOccurrences(of: "C", with: "",
                                         options: .caseInsensitive, range: temp.startIndex..<temp.endIndex)
        itemView.tempLabel.text = temp
        itemView.windLabel.text = wind
        bottomView.addSubview(itemView)
    }
    
    private func addWeather() {
        let weatherDetail = weatherModel.detailEntities[0]
        
        var temp = weatherDetail.temperature
        temp = temp.replacingOccurrences(of: "C", with: "",
                                         options: .caseInsensitive, range: temp.startIndex..<temp.endIndex)
        tempLabel.text = temp
        dateWeekLabel.text = "\(weatherModel.date) \(weatherDetail.week)"
        
        let desc: String
        if let pm2_5 = Int(weatherModel.pm2_5Entity.pm2_5) {
            if pm2_5 < 50 {
                desc = "\(pm2_5) 优"
            } else if pm2_5 < 100 {
                desc = "\(pm2_5) 良"
            } else {
                desc = "\(pm2_5) 差"
            }
        } else {
            desc = "获取空气质量失败"
        }
        
        airPMLabel.text = desc
        climateLabel.text = weatherDetail.climate
        windLabel.text = weatherDetail.wind
        
        if weatherDetail.climate == "雷阵雨" {
            weatherImg.image = UIImage(named: "thunder")
        } else if weatherDetail.climate == "晴" {
            weatherImg.image = UIImage(named: "sun")
        } else if weatherDetail.climate == "多云" {
            weatherImg.image = UIImage(named: "sunandcloud")
        } else if weatherDetail.climate == "阴" {
            weatherImg.image = UIImage(named: "cloud")
        } else if weatherDetail.climate == "雨" {
            weatherImg.image = UIImage(named: "rain")
        } else if weatherDetail.climate == "雪" {
            weatherImg.image = UIImage(named: "snow")
        } else {
            weatherImg.image = UIImage(named: "sandfloat")
        }
        // TODO: Add background image
        let bgURL = URL(string: self.weatherModel.pm2_5Entity.background2)!
        bgImg.loadImage(withURL: bgURL,
                        placeHolderImage: UIImage(named: "QingTian")!)
    }
}
