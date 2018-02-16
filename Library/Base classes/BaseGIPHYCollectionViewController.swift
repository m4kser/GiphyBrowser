//
//  BaseGIPHYCollectionViewController.swift
//  GiphyBrowser
//
//  Created by Admin on 16.02.18.
//  Copyright © 2018 Makser. All rights reserved.
//

import RxSwift
import RxCocoa
import EmptyDataSet_Swift

class BaseGIPHYCollectionViewController: UIViewController, EmptyDataSetSource, EmptyDataSetDelegate {
    
    //  MARK: Properties
    var giphyTrackerModel: GiphyTracker!
    let gifs: Variable<[GIF]> = Variable([])
    let isRefreshing: Variable<Bool> = Variable(false)
    
    var disposeBag = DisposeBag()
    
    @IBOutlet private var collectionView: UICollectionView!
    var reuseIdentifier: String = AnimatedImageCollectionViewCell.className
    var cellSize: CGSize = CGSize.zero
    
    
    //  MARK: Life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        fetchData()
    }
    
    //  MARK: Configuration
    func setup() {
        
        giphyTrackerModel = GiphyTracker()
      
        // Collection view
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: AnimatedImageCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.refreshControl = refreshControl
        
        refreshControl
            .rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
                refreshControl.beginRefreshing()
                self.fetchData()
                self.gifs.asObservable()
                    .observeOn(MainScheduler.instance)
                    .subscribe(
                        onNext: { (_) in
                            refreshControl.endRefreshing()
                    })
                    .disposed(by: self.disposeBag)
                
            })
            .disposed(by: disposeBag)
        
        isRefreshing
            .asObservable()
            .bind(onNext: { (isRefreshing) in
                self.collectionView.reloadEmptyDataSet()
            })
            .disposed(by: disposeBag)
        
        // data source
        gifs
            .asObservable()
            .bind(to: collectionView.rx.items) { collectionView, index, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: IndexPath(item: index, section: 0))
                if let animatedCell = cell as? AnimatedImageCollectionViewCell {
                    animatedCell.showGIF(item)
                }
                return cell
            }
            .disposed(by: disposeBag)
        
        // delegate
        collectionView
            .rx.willDisplayCell
            .subscribe(onNext: { cell, index in
                if index.row == self.gifs.value.count - 1 {
                    self.fetchData(offset: self.gifs.value.count)
                }
            })
            .disposed(by: disposeBag)
        
        //  Init
        collectionView.contentOffset = CGPoint(x: 0, y: -refreshControl.frame.size.height)
    }
    
    //  MARK: Data
    func fetchData(offset: Int = 0) {
        self.isRefreshing.value = true
        fetchProvider(offset: offset)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { (gifs) in
                    if offset == 0 {
                        self.gifs.value = gifs  //  Replace
                    } else {
                        self.gifs.value += gifs //  Add
                    }
                    self.isRefreshing.value = false
                },
                onError: { error in
                    MessageCenter.sharedInstance.showMessage(
                        title: "alert_title_error".localized(),
                        message: error.localizedDescription,
                        buttonTitle: "alert_button_title_ok".localized(),
                        completion: {  })
                }
            )
            .disposed(by: disposeBag)
        
    }
    
    func fetchProvider(offset: Int) -> Observable<[GIF]> {
        return Observable.just([GIF]())
    }
    
    //  MARK: EmptyDataSetSource, EmptyDataSetDelegate
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return #imageLiteral(resourceName: "Question")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "message_no_data_default".localized(), attributes: [NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
    }
    
    func imagetintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return !isRefreshing.value
    }
    
}

//  MARK: UICollectionViewDelegateFlowLayout
extension BaseGIPHYCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if cellSize == CGSize.zero {
            let numberOfItemsPerRow = Int(collectionView.bounds.width / 300.0)
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
            let size = Double((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
            cellSize = CGSize(width: size, height: 9.0/16.0*size)
        }
        return cellSize
    }
    
}

