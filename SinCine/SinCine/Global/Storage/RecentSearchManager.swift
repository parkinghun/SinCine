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
    
    // 1. 최근 검색어 다 가져오기
    func getRecentSearch() -> [String] {
        guard let searchList = storage.fetch() else { return [] }
        return searchList
    }
    
    // 2. 추가하기(이미 있으면 기존거 삭제하고 추가해주기)
    func addRecentSearch(keyword: String) {
        if let searchIndex = searchList.firstIndex(of: keyword) {
            searchList.remove(at: searchIndex)
            searchList.insert(keyword, at: 0)
        } else {
            searchList.insert(keyword, at: 0)
        }
 
        storage.save(data: searchList)
    }
    
    // 3. 하나하나 삭제하기
    func removeSearchKeyword(index: Int, completionHandler: (() -> Void)? = nil) {
        searchList.remove(at: index)
        storage.save(data: searchList)
        completionHandler?()
    }
    
    // 4. 전체삭제
    func removeAll(completionHandler: (() -> Void)? = nil) {
        searchList = []
        storage.removeData()
        completionHandler?()
    }
}
