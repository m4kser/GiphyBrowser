//
//  NSObjectExtensions.swift
//  GiphyBrowser
//
//  Created by Admin on 13.02.18.
//  Copyright © 2018 Makser. All rights reserved.
//

import Foundation

extension NSObject {
    
    static var className: String {
        return String(describing: self.self)
    }
    
}
