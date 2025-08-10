//
//  LikeManager.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import Foundation

protocol LikeManagerDelegate: AnyObject {
    func updateLikeUI()
}

final class LikeManager {
    static let shared = LikeManager()
    private let storage = UserDefaultsManager<[Int]>(key: .like)
    
    weak var delegate: LikeManagerDelegate?
    private(set) var likeList: [Int] = [] {
        didSet {
            delegate?.updateLikeUI() 
        }
    }
    
    private init() {
        self.likeList = getAllLikeMovieIDs
    }
    
    func isLike(movieID: Int) -> Bool {
        return storage.fetch()?.contains(movieID) ?? false
    }
    
    func toggleLike(for movieID: Int) {
        var currentLikes = storage.fetch() ?? []
        
        if currentLikes.contains(movieID) {
            print("Like 삭제")
            currentLikes.removeAll { $0 == movieID }
        } else {
            print("Like 추가")
            currentLikes.append(movieID)
        }
        
        likeList = currentLikes
        storage.save(data: Array(currentLikes))
    }
    
    var getAllLikeMovieIDs: [Int] {
        return storage.fetch() ?? []
    }
    
    func removeAll() {
        storage.removeData()
    }
}
