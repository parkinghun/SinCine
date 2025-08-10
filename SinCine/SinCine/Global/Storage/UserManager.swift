//
//  UserManager.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import Foundation

protocol UserManagerDelegate: AnyObject {
    func updateUserUI()
}

final class UserManager {
    static let shared = UserManager()
    private let userDefaultsManager = UserDefaultsManager<User>(key: .user)
    
    weak var delegate: UserManagerDelegate?
    private(set) var currentUser: User? {
        didSet {
            delegate?.updateUserUI()
        }
    }
    
    private init() {
        currentUser = userDefaultsManager.fetch()
    }
    
    func saveUser(_ user: User) {
        currentUser = user
        userDefaultsManager.save(data: user)
    }
    
    func updateUser(nickname: String) {
        currentUser?.nickname = nickname
        guard let currentUser else { return }
        
        userDefaultsManager.save(data: currentUser)
    }
    
    func deleteUSer() {
        currentUser = nil
        userDefaultsManager.removeData()
        
        LikeManager.shared.removeAll()
        RecentSearchManager.shared.removeAll()
    }
}
