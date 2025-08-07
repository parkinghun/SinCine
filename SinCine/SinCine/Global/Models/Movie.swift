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
    
    var isEnd: Bool {
        return totalPages == page ? true : false
    }
    
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
    let posterPath: String?
    let genreIds: [Int]
    let releaseDate: String
    let voteAverage: Double
    
    var isLiked: Bool = false
    private let genreDictionary = [
        28: "액션",
        12: "모험",
        16: "애니메이션",
        35: "코미디",
        80: "범죄",
        99: "다큐멘터리",
        18: "드라마",
        10751: "가족",
        14: "판타지",
        36: "역사",
        27: "공포",
        10402: "음악",
        9648: "미스터리",
        10749: "로맨스",
        878: "SF",
        10770: "TV 영화",
        53: "스릴러",
        10752: "전쟁",
        37: "서부"
    ]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    var posterURL: URL? {
        guard let posterPath else { return nil }
        let urlString = StringLiterals.ImageURL.base.rawValue + posterPath
        return URL(string: urlString)
    }
    
    // 장르
    var getGenre: [String] {
        var genreList: [String] = []

        genreIds.forEach {
            if let item = genreDictionary[$0] {
                genreList.append(item)
            }
        }
        
        return genreList
    }
    

    var formattedDate: String {
        return releaseDate.replacingOccurrences(of: "-", with: ". ")
    }
    
    var formattedRate: Double {
        return (voteAverage * 10).rounded() / 10
    }
}
