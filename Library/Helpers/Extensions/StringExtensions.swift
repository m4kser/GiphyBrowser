//
//  StringExtensions.swift
//  GiphyBrowser
//
//  Created by Admin on 16.02.18.
//  Copyright © 2018 Makser. All rights reserved.
//

import Foundation


extension String {
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
    
}
