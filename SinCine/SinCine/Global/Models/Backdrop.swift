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
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
    
    var backdropURL: URL? {
        let urlString = StringLiterals.ImageURL.base.rawValue + filePath
        return URL(string: urlString)
    }
}
