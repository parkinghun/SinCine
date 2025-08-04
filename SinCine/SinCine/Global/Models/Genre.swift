//
//  Genre.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import Foundation

struct GenreResult: Decodable {
    let genre: [Genre]
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
