//
//  NewsViewModel.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/30/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import Foundation
import MJExtension
import ReactiveCocoa

class NewsViewModel {
    var fetchNewsEntityCommand: RACCommand<AnyObject>!
    
    init() {
        setupRACCommand()
    }
    
    func setupRACCommand() {
        fetchNewsEntityCommand = RACCommand(signal: {
            [weak self] (input) -> RACSignal in
            
            return RACSignal.createSignal({ (subscriber) -> RACDisposable? in
                if let strongSelf = self, let input = input as? String {
                    strongSelf.requestForNewsEntity(withURL: input, success: { (array) in
                        let arrayM = NewsEntity.mj_objectArray(withKeyValuesArray: array)
                        subscriber.sendNext(arrayM)
                        subscriber.sendCompleted()
                    }, failure: { (error) in
                        subscriber.sendError(error)
                    })
                }
                
                return nil
            })
        })
    }
    
    private func requestForNewsEntity(withURL url: String,
                                      success: @escaping (_ array: Array<[String: Any]>) -> (),
                                      failure: @escaping (_ error: Error) -> ()) {
        let fullUrl = "https://c.m.163.com/".appending(url)
        
        let urlSession = URLSession.shared
        let dataTask = urlSession.dataTask(with: URL(string: fullUrl)!, completionHandler: {
            (data, response, error) in
            
            if let error = error {
                failure(error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data{
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let key = [String](json.keys).first!
                    let temArray = json[key] as! Array<[String: Any]>
                    success(temArray)
                } catch let jsonError {
                    failure(jsonError)
                }
            }
        })
        
        dataTask.resume()
    }
}
