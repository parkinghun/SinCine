//
//  LikeManager.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import Foundation
import RxSwift
import RxCocoa

//protocol LikeManagerDelegate: AnyObject {
//    func updateLikeUI()
//}

final class LikeManager {
    static let shared = LikeManager()
    private let storage = UserDefaultsManager<[Int]>(key: .like)
    
//    weak var delegate: LikeManagerDelegate?
    private(set) var likeList = BehaviorRelay<[Int]>(value: [])
    
//    private(set) var likeList: [Int] = [] {
//        didSet {
//            delegate?.updateLikeUI() 
//        }
//    }
    
    var getAllLikeMovieIDs: [Int] {
        return storage.fetch() ?? []
    }
    
    private init() {
        likeList.accept(getAllLikeMovieIDs)
//        self.likeList = getAllLikeMovieIDs
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
        
        likeList.accept(currentLikes)
        storage.save(data: Array(currentLikes))
    }
    
    func removeAll() {
        storage.removeData()
    }
}
