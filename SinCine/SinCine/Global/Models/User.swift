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
    var like: [String] = []  // movie id
    var recentSearch: [String] = []  // movie id
    
    var formattedDate: String {
        let locale = Locale(identifier: "ko-KR")
        return date.formatted(.dateTime.locale(locale).year(.twoDigits).month().day())
    }
}
