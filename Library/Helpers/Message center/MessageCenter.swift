//
//  MessageCenter.swift
//  GiphyBrowser
//
//  Created by Admin on 15.02.18.
//  Copyright © 2018 Makser. All rights reserved.
//

import Foundation
import UIKit

class MessageCenter {
    
    static let sharedInstance = MessageCenter()
    
    private init() {}
    
    func showMessage(title: String, message: String, buttonTitle: String, completion: @escaping ()->()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
            completion()
        }))
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
}
