//
//  User.swift
//  SinCine
//
//  Created by 박성훈 on 8/2/25.
//

import Foundation

struct User: Codable {
    var nickname: String
    var date: Date
    
    init(nickname: String) {
        self.nickname = nickname
        self.date = UserManager.shared.currentUser?.date ?? .now
    }
    
    var formattedDate: String {
        return DateFormatter.compactDateFormatter.string(from: date)
    }
}
