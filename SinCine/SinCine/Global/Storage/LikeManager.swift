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
    
    private var likeMovieIds: Set<Int> = []
    
    private init() {
        likeMovieIds = Set(storage.fetch() ?? [])
    }
    
    func toggleLike(for movieID: Int) {
        if likeMovieIds.contains(movieID) {
            likeMovieIds.remove(movieID)
        } else {
            likeMovieIds.insert(movieID)
        }
        storage.save(data: Array(likeMovieIds))
        
    }
    
    func isLike(movieID: Int) -> Bool {
        return likeMovieIds.contains(movieID)
    }
}
