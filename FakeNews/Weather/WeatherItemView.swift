//
//  WeatherItemView.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/20/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit

class WeatherItemView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!

    var weather: String! {
        didSet {
            weatherLabel.text = weather
            if weather == "雷阵雨" {
                weatherImg.image = UIImage(named: "thunder")
            } else if weather == "晴" {
                weatherImg.image = UIImage(named: "sun")
            } else if weather == "多云" {
                weatherImg.image = UIImage(named: "sunandcloud")
            } else if weather == "阴" {
                weatherImg.image = UIImage(named: "cloud")
            } else if weather == "雨" {
                weatherImg.image = UIImage(named: "rain")
            } else if weather == "雪" {
                weatherImg.image = UIImage(named: "snow")
            } else {
                weatherImg.image = UIImage(named: "sandfloat")
            }
        }
    }
    
    class func view() -> WeatherItemView {
        return Bundle.main.loadNibNamed("WeatherItemView", owner: nil, options: nil)!.first as! WeatherItemView
    }
    
}
