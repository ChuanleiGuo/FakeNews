//
//  WeatherView.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/21/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class WeatherView: UIView {
    
    // MARK: - Properties
    
    var weatherModel: WeatherEntity! {
        didSet {
            configureUI(withWeatherEntity: weatherModel)
        }
    }
    var contentView: UIView!

    // MARK: IBOutlets
    
    @IBOutlet weak var nowTempLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dateWeekLabel: UILabel!
    @IBOutlet weak var airPMLabel: UILabel!
    @IBOutlet weak var climateLabel: UILabel!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchImg: UIImageView!
    
    @IBOutlet weak var headlineButton: UIButton!
    @IBOutlet weak var headlineImg: UIImageView!
    
    @IBOutlet weak var offlineButton: UIButton!
    @IBOutlet weak var offlineImg: UIImageView!
    
    @IBOutlet weak var nightButton: UIButton!
    @IBOutlet weak var nightImg: UIImageView!
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var scanImg: UIImageView!
    
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var inviteImg: UIImageView!
    
    
    // MARK: - View Life Cycle
    
    class func view() -> WeatherView {
        return Bundle.main.loadNibNamed("WeatherView", owner: nil, options: nil)!.first as! WeatherView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        setUpUI()
    }
    
    
    func addAnimate() {
        searchButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        headlineButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        offlineButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        nightButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        scanButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        inviteButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        searchImg.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        headlineImg.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        offlineImg.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        nightImg.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        scanImg.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        inviteImg.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        
        UIView.animate(withDuration: 0.2, animations: { 
            self.searchButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.headlineButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.offlineButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.nightButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.scanButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.inviteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
            self.searchImg.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.headlineImg.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.offlineImg.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.nightImg.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.scanImg.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.inviteImg.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: { 
                self.searchButton.transform = .identity
                self.headlineButton.transform = .identity
                self.offlineButton.transform = .identity
                self.nightButton.transform = .identity
                self.scanButton.transform = .identity
                self.inviteButton.transform = .identity
                
                self.searchImg.transform = .identity
                self.headlineImg.transform = .identity
                self.offlineImg.transform = .identity
                self.nightImg.transform = .identity
                self.scanImg.transform = .identity
                self.inviteImg.transform = .identity
            })
        }
    }
    
    // MARK: - IBAction Methods
    
    @IBAction func pushDetail() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushWeatherDetail"),
                                        object: nil)
    }
    
    // MARK: - Private Methods
    
    private func setUpUI() {
        searchButton.layer.cornerRadius = searchButton.width / 2
        headlineButton.layer.cornerRadius = headlineButton.width / 2
        offlineButton.layer.cornerRadius = offlineButton.width / 2
        nightButton.layer.cornerRadius = nightButton.width / 2
        scanButton.layer.cornerRadius = scanButton.width / 2
        inviteButton.layer.cornerRadius = inviteButton.width / 2
    }
    
    private func configureUI(withWeatherEntity entity: WeatherEntity) {
        nowTempLabel.text = "\(entity.rt_temperature)"
        let weatherDetail = entity.detailEntities[0]
        
        let indexRange = weatherDetail.temperature.startIndex ..< weatherDetail.temperature.endIndex
        let temp = weatherDetail.temperature.replacingOccurrences(
            of: "C", with: "", options: .caseInsensitive, range: indexRange)
        tempLabel.text = temp
        dateWeekLabel.text = "\(entity.date) \(weatherDetail.week)"
        
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
        
        airPMLabel.text = "PM2.5 \(desc)"
        localLabel.text = "北京"
        climateLabel.text = "\(weatherDetail.climate) \(weatherDetail.wind)"
        
        if weatherDetail.climate == "雷阵雨" {
            weatherImg.image = UIImage(named: "thunder_mini")
        } else if weatherDetail.climate == "晴" {
            weatherImg.image = UIImage(named: "sun_mini")
        } else if weatherDetail.climate == "多云" {
            weatherImg.image = UIImage(named: "sun_and_cloud_mini")
        } else if weatherDetail.climate == "阴" {
            weatherImg.image = UIImage(named: "nosun_mini")
        } else if weatherDetail.climate == "雨" {
            weatherImg.image = UIImage(named: "rain_mini")
        } else if weatherDetail.climate == "雪" {
            weatherImg.image = UIImage(named: "snow_heavyx_mini")
        } else {
            weatherImg.image = UIImage(named: "sand_float_mini")
        }
    }
}
