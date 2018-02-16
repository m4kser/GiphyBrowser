//
//  MainScreenViewController.swift
//  GiphyBrowser
//
//  Created by Admin on 13.02.18.
//  Copyright © 2018 Makser. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EmptyDataSet_Swift

class MainScreenViewController: BaseGIPHYCollectionViewController {
    
    @IBOutlet private var searchBar: UISearchBar!

    let segueToSearchResult = "segueToSearchResult"
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    
    //  MARK: Configuration
    override func setup() {
        super.setup()
        
        //  Navigation bar
        title = "main_screen_title".localized()
        
        //  Search bar
        searchBar
            .rx.searchButtonClicked
            .filter({ (self.searchBar.text ?? "").count > 0 })
            .subscribe(onNext: {
                self.view.endEditing(true)
                self.performSegue(withIdentifier: self.segueToSearchResult, sender: nil)
            })
            .disposed(by: disposeBag)
        
        searchBar
            .rx.cancelButtonClicked
            .subscribe(onNext: {
                self.searchBar.text = ""
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        
        tapGesture
            .rx.event
            .bind { (_) in
                self.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }

    //  MARK: Data
    override func fetchProvider(offset: Int) -> Observable<[GIF]> {
        return giphyTrackerModel.getTrendingGifs(offset: offset)
    }

    //  MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case segueToSearchResult?:
            if let searchQuery = self.searchBar.text {
                (segue.destination as? SearchResultScreenViewController)?.searchQuery = searchQuery
            }
        default: break
        }
    }
    
}
