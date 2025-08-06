//
//  Backdrop.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import Foundation

struct BackDropResult: Decodable {
    let backdrops: [Backdrop]
}

struct Backdrop: Decodable {
    let filePath: String
    
    var backdropURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500/\(filePath)")
    }
}
