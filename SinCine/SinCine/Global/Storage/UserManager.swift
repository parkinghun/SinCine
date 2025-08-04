//
//  UserManager.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import Foundation

final class UserManager {
    static let shared = UserManager()
    
    private let userDefaultsManager = UserDefaultsManager<User>(key: .user)
    private(set) var currentUser: User?
    
    private init() {
        currentUser = userDefaultsManager.fetch()
    }
    
    func saveUser(_ user: User) {
        currentUser = user
        userDefaultsManager.save(data: user)
    }
    
    func deleteUSer() {
        currentUser = nil
        userDefaultsManager.removeData()
    }
}
