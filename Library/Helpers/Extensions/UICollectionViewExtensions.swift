//
//  UICollectionViewExtensions.swift
//  GiphyBrowser
//
//  Created by Admin on 15.02.18.
//  Copyright © 2018 Makser. All rights reserved.
//

import UIKit

public extension UICollectionView {
    
    public func beginRefreshing() {
        guard let refreshControl = refreshControl, !refreshControl.isRefreshing else {
            return
        }

        refreshControl.beginRefreshing()

        refreshControl.sendActions(for: .valueChanged)

        let contentOffset = CGPoint(x: 0, y: -refreshControl.frame.height)
        setContentOffset(contentOffset, animated: true)
    }
    
    public func endRefreshing() {
        refreshControl?.endRefreshing()
    }
    
}
