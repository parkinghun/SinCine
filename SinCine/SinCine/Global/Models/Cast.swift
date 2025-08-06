//
//  Cast.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import Foundation

struct CastResult: Decodable {
    let id: Int
    let cast: [Cast]
}

struct Cast: Decodable {
    let name: String
    let originalName: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case originalName = "original_name"
        case profilePath = "profile_path"
    }
}
