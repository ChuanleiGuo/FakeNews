//
//  SearchViewModel.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/18/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import Foundation
import ReactiveCocoa

class SearchViewModel {
    
    var searchText: String!
    var fetchHotWordCommand: RACCommand!
    var fetchSearchResultCommand: RACCommand!
    
    private func setupRACCommand() {
        fetchHotWordCommand = RACCommand(signal: { [unowned self] (input) -> RACSignal? in
            return RACSignal.createSignal({ (subscriber) -> RACDisposable? in
                self.requestforHotWord(success: { (result) in
                    subscriber?.sendNext(result)
                    subscriber?.sendCompleted()
                }, failure: { (error) in
                    subscriber?.sendError(error)
                })
                
                return nil
            })
        })
        
        fetchSearchResultCommand = RACCommand(signal: { [unowned self] (input) -> RACSignal? in
            return RACSignal.createSignal({ (subscriber) -> RACDisposable? in
                self.requestForSearchResultList(success: { (result) in
                    subscriber?.sendNext(result)
                    subscriber?.sendCompleted()
                }, failure: { (error) in
                    subscriber?.sendError(error)
                })
                
                return nil
            })
        })
    }
    
    private func requestforHotWord(success: @escaping (_ results: Array<[String: String]>) -> (),
                                   failure: @escaping (_ error: Error) -> ()) {
        
        let url = "http://c.3g.163.com/nc/search/hotWord.html"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: URL(string: url)!) { (data, response, error) in
            if let error = error {
                failure(error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Array<[String: String]>]
                    let hotwords = json["hotWordList"]!
                    success(hotwords)
                } catch let jsonError {
                    failure(jsonError)
                }
            }
        }
        dataTask.resume()
    }
    
    private func requestForSearchResultList(success: @escaping (_ results: Array<[String: String]>) -> (),
                                            failure: @escaping (_ failure: Error) -> ()) {
        
        if let searchKeyWord = searchText.base64encode {
            let url = "http://c.3g.163.com/search/comp/MA==/20/\(searchKeyWord).html"
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) in
                if let error = error {
                    failure(error)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                    let data = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        if let docs = json["doc"] as? [String: Any], let results = docs["results"] as? Array<[String: String]> {
                            success(results)
                        }
                        
                    } catch let jsonError {
                        failure(jsonError)
                    }
                }
            })
            dataTask.resume()
        }
    }
}
