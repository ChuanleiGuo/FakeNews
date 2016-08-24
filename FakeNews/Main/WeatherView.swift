//
//  WeatherView.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/21/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

@IBDesignable
class WeatherActionView: UIView {
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titalLabel: UILabel!
    
    @IBInspectable var buttonBgColor: UIColor = UIColor.orange
    
    override func awakeFromNib() {
        actionButton.backgroundColor = buttonBgColor
        actionButton.layer.cornerRadius = actionButton.width / 2
    }
}

class WeatherView: UIView {
    
    // MARK: - Properties
    
    var weatherModel: WeatherEntity! {
        didSet {
            configureUI(withWeatherEntity: weatherModel)
        }
    }

    // MARK: IBOutlets
    
    @IBOutlet weak var nowTempLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dateWeekLabel: UILabel!
    @IBOutlet weak var airPMLabel: UILabel!
    @IBOutlet weak var climateLabel: UILabel!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    
    // MARK: - View Life Cycle
    
    class func view() -> WeatherView {
        return Bundle.main.loadNibNamed("WeatherView", owner: nil, options: nil)!.first as! WeatherView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func addAnimate() {
        
    }
    
    // MARK: - Private Methods
    
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
