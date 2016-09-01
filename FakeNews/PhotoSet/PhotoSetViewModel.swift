//
//  PhotoSetViewModel.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/1/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import Foundation
import ReactiveCocoa



class PhotoSetViewModel {
    
    var newsModel: NewsEntity!
    var replyCountBtnTitle: String!
    var fetchPhotoSetCommand: RACCommand<AnyObject>!
    var photoSet: PhotoSetEntity!
    
    init() {
        setupRACCommand()
        PhotoSetEntity.mj_setupObjectClass { () -> [AnyHashable : Any]? in
            return ["photos": PhotosDetailEntity.self]
        }
    }
    
    private func setupRACCommand() {
        fetchPhotoSetCommand = RACCommand(signal: {  [unowned self] (input) -> RACSignal in
            return RACSignal.createSignal({ (subscriber) -> RACDisposable? in
                self.requestForPhotoSet(success: { (dict) in
                    let photoSet = PhotoSetEntity.mj_object(withKeyValues: dict)
                    self.photoSet = photoSet
                    subscriber.sendNext(photoSet)
                    subscriber.sendCompleted()
                }, failure: { (error) in
                    subscriber.sendError(error)
                })
                return nil
            })
        })
    }
    
    private func requestForPhotoSet(success: @escaping (_ result: [String: Any]) -> (),
                                    failure: @escaping (_ error: Error) -> ()) {
        let photoSetId = newsModel.photosetID
        let strIdx = photoSetId.index(photoSetId.startIndex, offsetBy: 4)
        let parameters = newsModel.photosetID.substring(from: strIdx)
            .components(separatedBy: "|")
        let url = String(format: "https://c.m.163.com/photo/api/set/%@/%@.json",
                         parameters.first!, parameters.last!)
        let count = Float(newsModel.replyCount.intValue)
        
        if count > 10000 {
            replyCountBtnTitle = String(format: "%.1f万跟帖", count / 10000)
        } else {
            replyCountBtnTitle = String(format: "%.0f跟帖", count)
        }
        
        let urlSession = URLSession.shared
        let dataTask = urlSession.dataTask(with: URL(string: url)!) {
            (data, response, error) in
            
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
    
    private func makePhotos(withModel model: PhotoSetEntity) -> [PhotosDetailEntity] {
        var details = [PhotosDetailEntity]()
        for photo in model.photos {
            if let photoDic = photo as? NSDictionary {
                if let detail = makePhotoDetailEntity(withDictionary: photoDic) {
                    details.append(detail)
                }
            }
        }
        return details
    }
    
    private func makePhotoDetailEntity(withDictionary dict: NSDictionary) -> PhotosDetailEntity? {
        let detailEntity = PhotosDetailEntity.mj_object(withKeyValues: dict)
        return detailEntity
    }
}
