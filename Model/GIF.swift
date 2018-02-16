//
//  GIF.swift
//  GiphyBrowser
//
//  Created by Admin on 13.02.18.
//  Copyright © 2018 Makser. All rights reserved.
//

import Foundation

enum Rating: String {
    case y = "y"
    case g = "g"
    case pg = "pg"
    case pg13 = "pg-13"
    case r = "r"
    case no
    case all = "all"
    
}

class GIF {
    
    var identifier: String
    var rating: Rating
    var title: String
    var gifUrl: URL?
    var previewUrl: URL?
    var trendingDate: Date?
    
    var height: Double
    var width: Double
    
    init(identifier: String, rating: String, gifUrl: URL?, previewUrl: URL?, title: String, trendingDate: Date?, height: Double, width: Double) {
        self.identifier = identifier
        self.rating = Rating(rawValue: rating) ?? .no
        self.gifUrl = gifUrl
        self.previewUrl = previewUrl
        self.title = title
        self.trendingDate = trendingDate
        self.height = height
        self.width = width
    }
    
    
    
}
