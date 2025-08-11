//
//  Bundle+Extension.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        
        guard let value = plistDict.object(forKey: StringLiterals.BundleKey.movie) as? String else {
            fatalError("Couldn't find key 'APIKey' in 'APIKey.plist'.")
        }
        
        return value
    }
}
