//
//  GiphySupportClasses.swift
//  GiphyBrowser
//
//  Created by Admin on 14.02.18.
//  Copyright © 2018 Makser. All rights reserved.
//

import Foundation
import Alamofire

enum GIPHY {
    //  Request endpoints
    case Search(query: String, rating: Rating?, offset: Int)
    case Trending(offset: Int)
    
    //  Base
    var baseURL: String { return "http://api.giphy.com" }
    var apiKey: String { return "u2dnVMVVYyt1GJRYepw3h6EBMbsKjOdQ" }
    
    //  Endpoint path
    var path: String {
        
        var path = ""
        
        switch self {
        case .Search: path = "/v1/gifs/search"
        case .Trending: path = "/v1/gifs/trending"
        }
        
        return baseURL + path
    }
    
    //  Method for endpoint
    var method: HTTPMethod {
        return .get
    }
    
    //  Parameters for endpoint
    var parameters: Parameters {
        var parameters = ["api_key" : apiKey] // common
        
        // additional
        switch self {
        case .Search(let query, let rating, let offset):
            parameters["q"] = query
            if let rating = rating { parameters["rating"] = rating.rawValue }
            parameters["offset"] = "\(offset)"
        case .Trending(let offset):
            parameters["offset"] = "\(offset)"
        }
        
        return parameters
    }
    
}

//  MARK: GIPHY Response
struct GIPHYResponse: Decodable {
    
    var data: [FailableDecodable<GIPHYData>] = []
    var meta: GIPHYMeta
    var pagination: GIPHYPagination
    
}

//  MARK: GIPHY Data
struct GIPHYData: Decodable {
    
    var identifier: String
    var rating: String
    var title: String
    var image: GIPHYImage
    var trendingDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case rating
        case title
        case image = "images"
        case trendingDate = "trending_datetime"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        identifier = try container.decode(String.self, forKey: .identifier)
        rating = try container.decode(String.self, forKey: .rating)
        title = try container.decode(String.self, forKey: .title)
        image = try container.decode(GIPHYImage.self, forKey: .image)
        trendingDate = try? container.decode(Date.self, forKey: .trendingDate)
    }
    
}

//  MARK: GIPHY Image
struct GIPHYImage: Decodable {
    
    var gifUrl: String
    var previewUrl: String
    
    var height: Double
    var width: Double
    
    enum CodingKeys: String, CodingKey {
        case gif = "fixed_height"
        case preview = "fixed_height_still"
    }
    
    enum GifKeys: String, CodingKey {
        case gifUrl = "url"
        case height
        case width
    }
    
    enum PreviewKeys: String, CodingKey {
        case previewUrl = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let gif = try values.nestedContainer(keyedBy: GifKeys.self, forKey: .gif)
        gifUrl = try gif.decode(String.self, forKey: .gifUrl)
        height = Double(try gif.decode(String.self, forKey: .height)) ?? 100
        width = Double(try gif.decode(String.self, forKey: .width)) ?? 100
        
        let preview = try values.nestedContainer(keyedBy: PreviewKeys.self, forKey: .preview)
        previewUrl = try preview.decode(String.self, forKey: .previewUrl)
    }
    
}

//  MARK: GIPHY Meta
struct GIPHYMeta: Decodable {
    
    var status: Int
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case message = "msg"
    }
    
}

//  MARK: GIPHY Pagination
struct GIPHYPagination: Decodable {
    
    var totalCount: Int
    var count: Int
    var offset: Int
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count
        case offset
    }
    
}

//  MARK: Failable Decodable
struct FailableDecodable<Base : Decodable> : Decodable {
    
    let base: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}

//  MARK: Local Support
extension DateFormatter {
    
    static let giphyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
}
