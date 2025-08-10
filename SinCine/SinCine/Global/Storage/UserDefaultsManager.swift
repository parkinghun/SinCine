//
//  UserDefaultsManager.swift
//  SinCine
//
//  Created by 박성훈 on 8/2/25.
//

import Foundation

enum UserDefaultsKeys: String {
    case user
    case like
    case recentSearch
}

final class UserDefaultsManager<T: Codable> {
    
    private let userDefaults = UserDefaults.standard
    private let key: String
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(key: UserDefaultsKeys, encoder: JSONEncoder = .init(), decoder: JSONDecoder = .init()) {
        self.key = key.rawValue
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func save(data: T) {
        guard let encoded = try? encoder.encode(data) else { return }
        
        userDefaults.set(encoded, forKey: key)
    }
    
    func fetch() -> T? {
        guard let savedData = userDefaults.data(forKey: key),
              let loadedData = try? decoder.decode(T.self, from: savedData) else { return nil }
        
        return loadedData
    }
    
    func removeData() {
        userDefaults.removeObject(forKey: key)
    }
}
