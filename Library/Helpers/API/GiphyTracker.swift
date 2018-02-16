//
//  GiphyTracker.swift
//  GiphyBrowser
//
//  Created by Admin on 13.02.18.
//  Copyright © 2018 Makser. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class GiphyTracker {
    
    func getTrendingGifs(offset: Int = 0) -> Observable<[GIF]> {
        
        return getGifsFromEndpoint(endpoint: .Trending(offset: offset))
    }
    
    func searchGifs(withQuery query: String, rating: Rating?, andOffset offset: Int = 0) -> Observable<[GIF]> {
        
        return getGifsFromEndpoint(endpoint: .Search(query: query, rating: rating, offset: offset))
    }
    
    func getGifsFromEndpoint(endpoint: GIPHY) -> Observable<[GIF]> {
       
        return Observable<[GIF]>.create { (observer) -> Disposable in
            let request = Alamofire.request(endpoint.path, method: endpoint.method, parameters: endpoint.parameters)
                .responseData(completionHandler: { (response) in
                    if let data = response.result.value {
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(DateFormatter.giphyFormatter)
                            
                            let giphyResponse = try decoder.decode(GIPHYResponse.self, from: data)
                            let gifs: [GIF] = giphyResponse.data
                                .flatMap({ $0.base })
                                .map { (data) -> GIF in
                                    return GIF(
                                        identifier: data.identifier,
                                        rating: data.rating,
                                        gifUrl: URL(string: data.image.gifUrl),
                                        previewUrl: URL(string: data.image.previewUrl),
                                        title: data.title,
                                        trendingDate: data.trendingDate,
                                        height: data.image.height,
                                        width: data.image.width
                                    )
                            }
                            observer.onNext(gifs)
                            observer.onCompleted()
                        } catch {
                            observer.onNext([])
                            do {
                                let messageDictionary = try JSONDecoder().decode([String : String].self, from: data)
                                if let message = messageDictionary["message"] {
                                    let serverError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : message])
                                    observer.onError(serverError)
                                } else {
                                    observer.onError(error)
                                }
                            } catch(_) {
                                observer.onError(error)
                            }
                        }
                    }
                    else if let error = response.result.error {
                        observer.onNext([])
                        observer.onError(error)
                    }
                })
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}
