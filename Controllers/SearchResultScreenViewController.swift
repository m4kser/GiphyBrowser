//
//  SeachResultScreenViewController.swift
//  GiphyBrowser
//
//  Created by Admin on 15.02.18.
//  Copyright © 2018 Makser. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EmptyDataSet_Swift

class SearchResultScreenViewController: BaseGIPHYCollectionViewController {

    //  MARK: Properties
    var searchQuery: String = ""
    let filter: Variable<Rating?> = Variable(nil)
    
    let segueToFilter = "segueToFilter"
    
    //  MARK: Life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  MARK: Configuration
    override func setup() {
        super.setup()
        
        //  Navigation Bar
        title = searchQuery
        
        let filterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Filter"), style: .plain, target: nil, action: nil)
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Back"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = filterButton
        navigationItem.leftBarButtonItem = backButton
        
        filterButton
            .rx.tap
            .subscribe(onNext: {
                self.performSegue(withIdentifier: self.segueToFilter, sender: nil)
            })
            .disposed(by: disposeBag)
        
        backButton
            .rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        // Collection view
        // data source
        filter
            .asObservable()
            .subscribe(onNext: { (filter) in
                self.gifs.value = []
                self.fetchData()    //  Fetching data with selected rating
            })
            .disposed(by: disposeBag)
    }
    
    //  MARK: Data
    override func fetchProvider(offset: Int) -> Observable<[GIF]> {
        return giphyTrackerModel.searchGifs(withQuery: self.searchQuery, rating: filter.value, andOffset: offset)
    }
    
    //  MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToFilter {
            let filterController = segue.destination as? RatingFilterViewController
            filterController?.delegate = self
            filterController?.setFilter(filter: filter.value)
        }
    }

    //  MARK: EmptyDataSetSource
    override func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        var message = "No GIFs found."
        if filter.value == nil {
            message += "\nTry another keyword"
        } else {
            message += "\nTry to change filter"
        }
        return NSAttributedString(string: message, attributes: [NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
    }
    
}

//  MARK: RatingFilterDelegate
extension SearchResultScreenViewController: RatingFilterDelegate {
    
    func didSelectFilter(filter: Rating?) {
        self.filter.value = filter
    }
}
