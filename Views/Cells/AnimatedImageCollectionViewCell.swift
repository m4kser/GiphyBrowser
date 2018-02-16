//
//  AnimatedImageCollectionViewCell.swift
//  GiphyBrowser
//
//  Created by Admin on 13.02.18.
//  Copyright © 2018 Makser. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class AnimatedImageCollectionViewCell: UICollectionViewCell {

    //  MARK: Properties
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var trendIco: UIView!
    
    let globalDisposeBag = DisposeBag()
    private(set) var disposeBag = DisposeBag()
    
    let colors = [#colorLiteral(red: 1, green: 0.3987305164, blue: 0.401804924, alpha: 1), #colorLiteral(red: 0.6000295877, green: 0.2168335319, blue: 1, alpha: 1), #colorLiteral(red: 0.008368967101, green: 0.9817529321, blue: 0.5995138288, alpha: 1), #colorLiteral(red: 1, green: 0.9531564116, blue: 0.3602205217, alpha: 1), #colorLiteral(red: 0.0002614702971, green: 0.800902307, blue: 1, alpha: 1)]
    
    override open var isSelected: Bool {
        set { }
        get { return super.isSelected }
    }
    
    override open var isHighlighted: Bool {
        set { }
        get { return super.isHighlighted }
    }
    
    //  MARK: Life circle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        imageView.animationImages = nil
        imageView.stopAnimating()
        
        disposeBag = DisposeBag()
    }
    
    //  MARK: Configuration
    func setup() {
        imageView.backgroundColor = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    //  MARK: Data
    func showGIF(_ gif: GIF) {
        if let url = gif.gifUrl {
            showAnimatedImage(fromUrl: url)
        }
        titleLabel.text = gif.title
        trendIco.isHidden = (gif.trendingDate == nil)
        imageView.backgroundColor = colors[abs(gif.identifier.hashValue) % colors.count]
    }
    
    func showPreview(fromUrl url: URL) {
        let downloadManagerModel = DownloadManager.sharedInstance
        
        activityIndicator.startAnimating()
        
        downloadManagerModel.downloadFile(url: url)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { (data) in
                    if let data = data {
                        let image = UIImage(data: data)
                        self.imageView.image = image
                    }
            }, onError: { (error) in
                print(error)
            }, onCompleted: {
                self.activityIndicator.stopAnimating()
            }, onDisposed: {
                self.activityIndicator.stopAnimating()
            })
            .disposed(by: self.disposeBag)
    }
    
    func showAnimatedImage(fromUrl url: URL) {
        let downloadManagerModel = DownloadManager.sharedInstance
        
        self.activityIndicator.startAnimating()
        
        downloadManagerModel.downloadFile(url: url)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { (data) in
                    if let data = data, let animatedImage = AnimatedImage(data: data) {
                        self.showAnimatedImage(animatedImage)
                    }
            },
                onError: { (error) in
                    print(error)
            },
                onCompleted: {
                    self.activityIndicator.stopAnimating()
            },
                onDisposed: {
                    self.activityIndicator.stopAnimating()
            })
            .disposed(by: self.disposeBag)
    }
    
    func showAnimatedImage(_ animatedImage: AnimatedImage) {
        imageView.showAnimatedImage(animatedImage)
        imageView.startAnimating()
    }

}
