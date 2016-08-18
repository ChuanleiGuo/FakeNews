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
    
    // MARK: - Properties
    
    // MARK: IBOutlet
    
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var dateWeekLabel: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var climateLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var airPMLabel: UILabel!
    
    // MARK: Properties
    
    var weatherModel: WeatherBgEntity!
    var bottomView: UIView!
    
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
        
    }

}
