//
//  LikeManager.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import Foundation

final class LikeManager {
    static let shared = LikeManager()
    
    private let storage = UserDefaultsManager<[Int]>(key: .like)
    
    private init() { }
    
    func isLike(movieID: Int) -> Bool {
        return storage.fetch()?.contains(movieID) ?? false
    }
    
    func toggleLike(for movieID: Int) {
        var currentLikes = storage.fetch() ?? []
        
        if currentLikes.contains(movieID) {
            currentLikes.removeAll { $0 == movieID }
        } else {
            currentLikes.append(movieID)
        }
        
        storage.save(data: Array(currentLikes))
    }
    
    func getAllLikeMovieIDs() -> [Int] {
        return storage.fetch() ?? []
    }
}
