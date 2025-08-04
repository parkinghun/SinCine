//
//  EndPoint.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import Foundation

enum APIType {
    case trending
    case search(query: String)
    case image(movieId: Int)
    case credit(movieId: Int)
    case genre
    
    var path: String {
        switch self {
        case .trending:
            return "/3/trending/movie/day"
        case .search:
            return "/3/search/movie"
        case let .image(movieId):
            return "/3/movie/\(movieId)/images"
        case let .credit(movieId):
            return "/3/movie/\(movieId)/credits"
        case .genre:
            return "/3/genre/movie/list"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .search(query):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "language", value: "ko-KR")
            ]
        default:
            return [URLQueryItem(name: "language", value: "ko-KR")]
            
        }
    }
}

struct EndPoint {
    let apiType: APIType
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = apiType.path
        components.queryItems = apiType.queryItems
        
        return components.url
    }
}
