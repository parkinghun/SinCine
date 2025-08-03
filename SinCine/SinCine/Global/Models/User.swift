//
//  User.swift
//  SinCine
//
//  Created by 박성훈 on 8/2/25.
//

import Foundation

struct User: Codable {
    var nickname: String
    var date: String
    var like: Int  // 영화에 대한 데이터 타입으로 변경
    var recentSearch: String  // 마찬가지
}
