//
//  ReplyViewModel.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/5/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import Foundation
import ReactiveCocoa

enum ReplyPageFrom {
    case newsDetail
    case photoSet
}

class ReplyViewModel {
    
    var source: ReplyPageFrom!
    var photoSetPostID: String!
    var newsModel: NewsEntity!
    
    var replyModels: [ReplyEntity] = []
    var replyNormalModels: [ReplyEntity] = []
    
    var fetchHotReplyCommand: RACCommand!
    var fetchNormalReplyCommand: RACCommand!
    
    init() {
        setupRACCommand()
    }
    
    private func setupRACCommand() {
        fetchHotReplyCommand = RACCommand(signal: { [unowned self] (input) -> RACSignal in
            return RACSignal.createSignal({ (subscriber) -> RACDisposable? in
                self.requestForFeedback(success: { (responseDict) in
                    if let hotPosts = responseDict["hotPosts"] as? Array<[String: Any]> {
                        var tempReplyModels = [ReplyEntity]()
                        
                        for i in 0..<hotPosts.count {
                            if let dict = hotPosts[i]["1"] as? [String: String] {
                                let replyModel = ReplyEntity()
                                
                                replyModel.name = dict["n"] ?? "火星网友"
                                replyModel.address = dict["f"] ?? ""
                                replyModel.say = dict["b"] ?? ""
                                replyModel.suppose = dict["v"] ?? ""
                                replyModel.icon = dict["timg"] ?? ""
                                replyModel.rtime = dict["t"] ?? ""
                                tempReplyModels.append(replyModel)
                            }
                        }
                        
                        self.replyModels = tempReplyModels
                        subscriber?.sendNext(tempReplyModels)
                        subscriber?.sendCompleted()
                    }
                }, failure: { (error) in
                    subscriber?.sendError(error)
                })
                
                return nil
            })
        })
        
        fetchNormalReplyCommand = RACCommand(signal: { [unowned self] (input) -> RACSignal in
            return RACSignal.createSignal({ (subscriber) -> RACDisposable? in
                self.requestForPhotoNorFeedback(success: { (responseDict) in
                    if let newPosts = responseDict["newPosts"] as? Array<[String: Any]> {
                        var tempPosts = [ReplyEntity]()
                        
                        for i in 0..<newPosts.count {
                            if let dict = newPosts[i]["1"] as? [String: String] {
                                let replyModel = ReplyEntity()
                                replyModel.name = dict["n"] ?? "火星网友"
                                replyModel.address = dict["f"] ?? ""
                                replyModel.say = dict["b"] ?? ""
                                replyModel.suppose = dict["v"] ?? ""
                                tempPosts.append(replyModel)
                            }
                        }
                        
                        self.replyNormalModels = tempPosts
                        subscriber?.sendNext(tempPosts)
                        subscriber?.sendCompleted()
                    }
                }, failure: { (error) in
                    subscriber?.sendError(error)
                })
                
                return nil
            })
        })
    }
    
    private func requestForFeedback(success: @escaping (_ result: [String: Any]) -> (),
                                    failure: @escaping (_ error: Error) -> ()) {
        let url: String
        if source == .newsDetail {
            url = String(format: "http://comment.api.163.com/api/json/post/list/new/hot/%@/%@/0/10/10/2/2",
                         newsModel.boardid, newsModel.docid)
        } else {
            url = String(format: "http://comment.api.163.com/api/json/post/list/new/hot/%@/%@/0/10/10/2/2",
                         newsModel.boardid, photoSetPostID)
        }
        
        requestForJSONObject(fromURL: URL(string: url)!, success: success, failure: failure)
    }
    
    private func requestForPhotoNorFeedback(success: @escaping (_ result: [String: Any]) -> (),
                                            failure: @escaping (_ error: Error) -> ()) {
        let url: String
        if source == .newsDetail {
            url = String(format: "http://comment.api.163.com/api/json/post/list/new/normal/%@/%@/desc/0/10/10/2/2",
                         newsModel.boardid, newsModel.docid)
        } else {
            url = String(format: "http://comment.api.163.com/api/json/post/list/new/normal/%@/%@/desc/0/10/10/2/2",
                         newsModel.boardid, photoSetPostID)
        }
        
        requestForJSONObject(fromURL: URL(string: url)!, success: success, failure: failure)
    }
    
    private func requestForJSONObject(fromURL url: URL,
                                      success: @escaping (_ result: [String: Any]) -> (),
                                      failure: @escaping (_ error: Error) -> ()) {
        let urlSession = URLSession.shared
        let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                failure(error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    success(json)
                } catch let jsonError {
                    failure(jsonError)
                }
            }
        }
        
        dataTask.resume()
    }
}
