//
//  User.swift
//  SinCine
//
//  Created by 박성훈 on 8/2/25.
//

import Foundation

struct User: Codable {
    var nickname: String
    var date: Date = .now
    
    var formattedDate: String {
        return DateFormatter.compactDateFormatter.string(from: date)
    }
}
