//
//  WeatherViewModel.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/26/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import Foundation

class WeatherViewModel {
    
    var weatherModel: WeatherEntity?
    private var dataTask: URLSessionDataTask?
    
    func fatchWeather(completionHandler: @escaping () -> Void) {
        let url = URL(string: "https://c.3g.163.com/nc/weather/5YyX5LqsfOWMl%2BS6rA%3D%3D.html")!
        let session = URLSession.shared
        dataTask = session.dataTask(with: url, completionHandler: {
            [unowned self] (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data, let json = self.parseJSON(data: data) {
                    self.weatherModel = self.parseDictionary(json)
                    
                    let queue = DispatchQueue.main
                    queue.async {
                        completionHandler()
                    }
                }
            }
        })
        dataTask?.resume()
    }
    
    private func parseJSON(data: Data) -> [String: AnyObject]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    private func parseDictionary(_ dictionary: [String: AnyObject]) -> WeatherEntity? {
        guard let details = dictionary["北京|北京"] as? Array<[String: String]>,
            let date = dictionary["dt"] as? String,
            let temperature = dictionary["rt_temperature"] as? Int,
            let pm2d5 = dictionary["pm2d5"] as? [String: String]
            else {
                
                return nil
        }
        
        var weatherDetails = [WeatherDetailEntity]()
        for detail in details {
            let d = parseWeatherDetail(detail)
            weatherDetails.append(d)
        }
        
        let weatherBgDatail = parsePm2d5(pm2d5)
        
        return WeatherEntity(detailEntities: weatherDetails, pm2_5Entity: weatherBgDatail,
                             date: date, rt_temperature: temperature)
        
    }
    
    private func parseWeatherDetail(_ detail: [String: String]) -> WeatherDetailEntity {
        let wind = detail["wind"]!
        let nongli = detail["nongli"]!
        let date = detail["date"]!
        let climate = detail["climate"]!
        let temp = detail["temperature"]!
        let week = detail["week"]!
        
        return WeatherDetailEntity(wind: wind, lunar: nongli, date: date,
                                   climate: climate, temperature: temp, week: week)
    }
    
    private func parsePm2d5(_ pm2d5: [String: String]) -> WeatherBgEntity {
        let nbg1 = pm2d5["nbg1"]!
        let nbg2 = pm2d5["nbg2"]!
        let aqi = pm2d5["aqi"]!
        let pm2_5 = pm2d5["pm2_5"]!
        return WeatherBgEntity(background1: nbg1, background2: nbg2, aqi: aqi, pm2_5: pm2_5)
    }
}
