//
//  PhotoSetPage.swift
//  FakeNews
//
//  Created by ChuanleiGuo on 8/31/16.
//  Copyright © 2016 ChuanleiGuo. All rights reserved.
//

import UIKit
import ReactiveCocoa

class PhotoSetPage: UIViewController, UIScrollViewDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var contentText: UITextView!
    
    // MARK: - Properties
    var newsModel: NewsEntity! {
        didSet {
            viewModel.newsModel = newsModel
        }
    }
    var photoSet: PhotoSetEntity!
    var replyModel: ReplyEntity!
    
    private lazy var news: Array<[String: String]>! = {
        guard let filePath = Bundle.main.path(forResource: "NewsURLs.plist", ofType: nil) else {
            return nil
        }
        return NSArray(contentsOfFile: filePath) as! Array<[String: String]>
    }()
    
    private lazy var viewModel: PhotoSetViewModel = {
        return PhotoSetViewModel()
    }()
    
    private lazy var replyNormalModels: [ReplyEntity] = {
        return [ReplyEntity]()
    }()
    private lazy var replyModels: [ReplyEntity] = {
        return [ReplyEntity]()
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchPhotoSetCommand.execute(nil).subscribeNext { [unowned self] (x) in
            let q = DispatchQueue.main
            if let photoSet = x as? PhotoSetEntity {
                self.photoSet = photoSet
                
                q.async {
                    self.setLabel(withModel: photoSet)
                    self.setImage(withModel: photoSet)
                }
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - IBAction Method
    
    @IBAction func returnBtnClicked(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
        navigationController!.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let replyvc = segue.destination as! ReplyPage
        replyvc.source = .photoSet
        replyvc.newsModel = newsModel
        replyvc.photoSetId = photoSet.postid
    }
    
    // MARK: - Private Methods
    
    // MARK: UI
    
    private func setLabel(withModel photoSet: PhotoSetEntity) {
        titleLabel.text = photoSet.setname
        
        setContent(withIndex: 0)
        let countNum = String(format: "1/%ld", photoSet.photos.count)
        self.countLabel.text = countNum
    }
    
    private func setContent(withIndex index: Int) {
        let content = (photoSet.photos[index] as! PhotosDetailEntity).note
        let contentTitle = (photoSet.photos[index] as! PhotosDetailEntity).imgtitle
        if content.characters.count != 0 {
            contentText.text = content
        } else {
            contentText.text = contentTitle
        }
    }
    
    private func setImage(withModel photoSet: PhotoSetEntity) {
        let count = photoSet.photos.count
        
        for i in 0..<count {
            let imageView = UIImageView()
            imageView.height = photoScrollView.height
            imageView.width = photoScrollView.width
            imageView.y = 0
            imageView.x = CGFloat(i) * imageView.width
            
            imageView.contentMode = .scaleAspectFit
            photoScrollView.addSubview(imageView)
        }
        setImage(withIndex: 0)
        
        photoScrollView.contentOffset = CGPoint.zero
        photoScrollView.showsHorizontalScrollIndicator = false
        photoScrollView.showsVerticalScrollIndicator = false
        photoScrollView.isPagingEnabled = true
        photoScrollView.contentSize = CGSize(width: photoScrollView.width * CGFloat(count), height: 0)
    }
    
    private func setImage(withIndex index: Int) {
        let photoImgView: UIImageView
        if index == 0 {
            photoImgView = photoScrollView.subviews[index + 2] as! UIImageView
        } else {
            photoImgView = photoScrollView.subviews[index] as! UIImageView
        }
        
        let purl = URL(string: (photoSet.photos[index] as! PhotosDetailEntity).imgurl)
        
        if photoImgView.image == nil {
            photoImgView.sd_setImage(with: purl,
                                     placeholderImage: UIImage(named: "photoview_image_default_white"))
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(photoScrollView.contentOffset.x / photoScrollView.width)
        setImage(withIndex: index)
        let countNum = String(format: "%d/%ld", index + 1, photoSet.photos.count)
        countLabel.text = countNum
        setContent(withIndex: index)
    }
}
