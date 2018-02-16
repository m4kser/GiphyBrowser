//
//  DownloadManager.swift
//  GiphyBrowser
//
//  Created by Admin on 13.02.18.
//  Copyright © 2018 Makser. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class DownloadManager {
    
    static let sharedInstance = DownloadManager()
    
    let sessionManager: SessionManager!
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func downloadFile(url: URL) -> Observable<Data?> {
        
        return Observable<Data?>.create({ (observer) -> Disposable in
            let request = self.sessionManager.request(url)
                .responseData(completionHandler: { (response) in
                    if let error = response.error {
                        observer.onError(error)
                    } else if let data = response.data {
                        observer.onNext(data)
                        observer.onCompleted()
                    } 
                })
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
}
