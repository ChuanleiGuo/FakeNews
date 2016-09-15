//
//  NewsDetailViewModel.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 9/12/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MJExtension

class NewsDetailViewModel {
    
    var detailModel: NewsDetailEntity!
    var newsModel: NewsEntity! {
        didSet {
            replyViewModel.newsModel = newsModel
        }
    }
    
    var sameNews: [SimilarNewsEntity] = []
    //var keywordSearch: [String] = []
    var keywordSearch: Array<[String: String]> = []
    var replyModels: [ReplyEntity] = []
    var replyCountBtnTitle: String = ""
    
    var fetchNewsDetailCommand: RACCommand!
    var fetchHotFeedbackCommand: RACCommand!
    
    private lazy var replyViewModel: ReplyViewModel = {
        let rvm = ReplyViewModel()
        rvm.source = .newsDetail
        return rvm
    }()
    
    init() {
        setupRACCommand()
    }
    
    private func setupRACCommand() {
        fetchNewsDetailCommand = RACCommand(signal: {
            [unowned self] (input) -> RACSignal in
            return RACSignal.createSignal({ (subscriber) -> RACDisposable? in
                self.requestForNewsDetail(success: { (result) in
                    if let detail = result[self.newsModel.docid] as? [String: Any] {
                        self.detailModel = NewsDetailEntity.detail(withDict: detail)
                        if self.newsModel.boardid.characters.count < 1 {
                            self.newsModel.boardid = self.detailModel.replyBoard
                        }
                        self.newsModel.replyCount = self.detailModel.replyCount as NSNumber
                        
                        if let sameNews = detail["relative_sys"] as? Array<[String: String]> {
                            self.sameNews = (SimilarNewsEntity.mj_objectArray(withKeyValuesArray: sameNews) as NSArray)
                                as! [SimilarNewsEntity]
                        }
                        if let keyWords = detail["keyword_search"] as? Array<[String: String]> {
                            self.keywordSearch = keyWords
                        }
                        
                        let count = Float(self.newsModel.replyCount.intValue)
                        if count > 10000 {
                            self.replyCountBtnTitle = String(format: "%.1f万跟帖", count / 10000)
                        } else {
                            self.replyCountBtnTitle = String(format: "%.0f跟帖", count)
                        }
                        
                        subscriber?.sendNext(self.replyCountBtnTitle)
                        subscriber?.sendCompleted()
                    }
                }, failure: { (error) in
                    subscriber?.sendError(error)
                })
                
                return nil
            })
        })
        
        fetchHotFeedbackCommand = RACCommand(signal: {
            [unowned self] (input) -> RACSignal in
            return RACSignal.createSignal({ (subscriber) -> RACDisposable? in
                self.replyViewModel.fetchHotReplyCommand.execute(nil).subscribeNext({ (x) in
                    self.replyModels = x as! [ReplyEntity]
                }, error: { (error) in
                    subscriber?.sendError(error)
                }, completed: {
                    subscriber?.sendCompleted()
                })
                
                return nil
            })
        })
    }
    
    private func requestForNewsDetail(success: @escaping (_ array: [String: Any]) -> (),
                                      failure: @escaping (_ error: Error) -> ()) {
        let url = String(format: "http://c.m.163.com/nc/article/%@/full.html", newsModel.docid)
        
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
    
    var htmlString: String {
        
        let cssURL = Bundle.main.url(forResource: "SXDetails.css", withExtension: nil)!.absoluteString
        var html = ""
        html.append("<html>")
        html.append("<head>")
        html.append(String(format: "<link rel=\"stylesheet\" href=\"%@\">", cssURL))
        html.append("</head>")
        
        html.append("<body style=\"background=#f6f6f6\">")
        html.append(bodyhtmlString)
        html.append("</body>")
        
        html.append("</html>")
        return html
    }
    
    private var bodyhtmlString: String {
        var body = ""
        
        body.append(String(format: "<div class=\"title\">%@</div>", detailModel.title))
        body.append(String(format: "<div class=\"time\">%@</div>", detailModel.ptime))
        body.append(detailModel.body)
        
        for detailImgModel in detailModel.imgs {
            let numFormatter = NumberFormatter()
            var imgHtml = ""
            imgHtml.append("<div class=\"img-parent\">")
            let pixel = detailImgModel.pixel.components(separatedBy: "*")
            let maxWidth = UIScreen.main.bounds.width
            var width: CGFloat = maxWidth
            var height: CGFloat = 0
            if let w = numFormatter.number(from: pixel.first!), let h = numFormatter.number(from: pixel.last!) {
                width = CGFloat(w)
                height = CGFloat(h)
                if width > maxWidth {
                    height = maxWidth / width * height
                    width = maxWidth
                }
            }
            
            let onload = "this.onclick = function() {" +
            "  window.location.href = 'sx://github.com/dsxNiubility?src=' +this.src+'&top=' + this.getBoundingClientRect().top + '&whscale=' + this.clientWidth/this.clientHeight ;" +
            "};"
            
            imgHtml.append(String(format: "<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",
                                  onload, width, height, detailImgModel.src))
            imgHtml.append("</div>")
            let range = body.startIndex..<body.endIndex
            return body.replacingOccurrences(of: detailImgModel.ref, with: imgHtml,
                                             options: [.caseInsensitive], range: range)
        }
        return body
    }
}
