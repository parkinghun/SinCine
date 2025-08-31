//
//  UserManager.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import Foundation
import RxSwift
import RxCocoa

//protocol UserManagerDelegate: AnyObject {
//    func updateUserUI()
//}

final class UserManager {
    static let shared = UserManager()
    private let userDefaultsManager = UserDefaultsManager<User>(key: .user)
    
//    weak var delegate: UserManagerDelegate?
    private(set) var currentUser = BehaviorRelay<User?>(value: nil)
    
//    private(set) var currentUser: User? {
//        didSet {
//            delegate?.updateUserUI()
//        }
//    }
//    
    private init() {
        currentUser.accept(userDefaultsManager.fetch())
    }
    
    func saveUser(_ user: User) {
        currentUser.accept(user)
        userDefaultsManager.save(data: user)
    }
    
    func updateUser(nickname: String) {
        guard var user = currentUser.value else { return }
        user.nickname = nickname
        
        userDefaultsManager.save(data: user)
    }
    
    func deleteUSer() {
        currentUser.accept(nil)
        userDefaultsManager.removeData()
        
        LikeManager.shared.removeAll()
        RecentSearchStore.shared.removeAll()
    }
}
