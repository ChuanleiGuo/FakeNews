//
//  WeatherEntity.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/18/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import Foundation

struct WeatherBgEntity {
    let background1: String
    let background2: String
    let aqi: String
    let pm2_5: String
}

struct WeatherDetailEntity {
    let wind: String
    let lunar: String
    let date: String
    let climate: String
    let temperature: String
    let week: String
}

struct WeatherEntity {
    var detailEntities: [WeatherDetailEntity]
    var pm2_5Entities: [WeatherBgEntity]
    let dt: String
    let rt_temperature: Int
}
