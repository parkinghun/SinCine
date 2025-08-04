//
//  Movie.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import Foundation

struct MovieResult: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let genreIds: [Int]
    let releaseDate: String
    // 좋아요 (likeBT)
    
    let genre: [Genre] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
    }
    
    var posterURL: String {
        return  "https://image.tmdb.org/t/p/w500/\(posterPath)"
    }
    
    // 장르
    var getGenre: [String] {
        var genreType: [String] = []
        var genreDic = [Int: String]()
        
        genre.forEach {
            genreDic.updateValue($0.name, forKey: $0.id)
        }
        
        genreIds.forEach {
            if let item = genreDic[$0] {
                genreType.append(item)
            }
        }
        
        return genreType
    }
    

    var formattedDate: String {
        return releaseDate.replacingOccurrences(of: "-", with: ". ")
    }
}



