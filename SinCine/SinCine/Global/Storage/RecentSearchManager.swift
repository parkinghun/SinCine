//
//  RecentSearchManager.swift
//  SinCine
//
//  Created by 박성훈 on 8/8/25.
//

import Foundation

final class RecentSearchManager {
    static let shared = RecentSearchManager()
    
    private let storage = UserDefaultsManager<[String]>(key: .recentSearch)
    private(set) var searchList: [String] = []
    
    private init() {
        self.searchList = getRecentSearch()
    }
    
    func getRecentSearch() -> [String] {
        guard let searchList = storage.fetch() else { return [] }
        return searchList
    }

    func addRecentSearch(keyword: String) {
        if let searchIndex = searchList.firstIndex(of: keyword) {
            searchList.remove(at: searchIndex)
            searchList.insert(keyword, at: 0)
        } else {
            searchList.insert(keyword, at: 0)
        }
 
        storage.save(data: searchList)
    }
    
    func removeSearchKeyword(index: Int, completionHandler: (() -> Void)? = nil) {
        searchList.remove(at: index)
        storage.save(data: searchList)
        completionHandler?()
    }
    
    func removeAll(completionHandler: (() -> Void)? = nil) {
        searchList = []
        storage.removeData()
        completionHandler?()
    }
}
