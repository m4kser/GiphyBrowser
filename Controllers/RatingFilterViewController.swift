//
//  RatingFilterViewController.swift
//  GiphyBrowser
//
//  Created by Admin on 15.02.18.
//  Copyright © 2018 Makser. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol RatingFilterDelegate {
    func didSelectFilter(filter: Rating?)
}

class RatingFilterViewController: UIViewController {
    
    //  MARK: Properties
    @IBOutlet private var tableView: UITableView!
    let reuseIdentifier: String! =  RatingFilterTableViewCell.className
    
    let ratingList: Variable<[Rating]> = Variable([
        .all, .y, .g, .pg, .pg13, .r
    ])
    let disposeBag = DisposeBag()
    
    var delegate: RatingFilterDelegate?
    private var filter: Rating = .no
    
    //  MARK: Life circle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    //  MARK: Configuration
    func setup() {
        
        //  Navigation bar
        title = "filter_screen_title".localized()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        
        cancelButton
            .rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        doneButton
            .rx.tap
            .subscribe(onNext: {
                self.delegate?.didSelectFilter(filter: self.filter == .all ? nil : self.filter)
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        //  Table view
        //  Data source
        ratingList.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: RatingFilterTableViewCell.self)) { row, element, cell in
                cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.textLabel?.text = element.readableValue
            }
            .disposed(by: disposeBag)
        
        //  Delegate
        tableView
            .rx.itemSelected
            .subscribe(onNext: {
                index in
                let item = self.ratingList.value[index.row]
                self.filter = item
            })
            .disposed(by: disposeBag)
        
        tableView
            .rx.itemDeselected
            .subscribe(onNext: {
                index in
                let item = self.ratingList.value[index.row]
                self.filter = item
            })
            .disposed(by: disposeBag)
        
        //  Init
        if let index = ratingList.value.index(of: filter) {
            tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
        }
    }

    //  MARK: Data
    func setFilter(filter: Rating?) {
        if let filter = filter {
            self.filter = filter
        } else {
            self.filter = .all
        }
    }
    
}


extension Rating {
    
    var readableValue: String {
        return self.rawValue.localizedUppercase
    }
    
}
