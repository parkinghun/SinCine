//
//  DateFormatter.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import Foundation

extension DateFormatter {
    static let compactDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy. MM. dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
}
