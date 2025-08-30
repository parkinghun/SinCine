//
//  RecentSearchManager.swift
//  SinCine
//
//  Created by 박성훈 on 8/8/25.
//

import Foundation
import RxSwift
import RxCocoa

final class RecentSearchStore {
    static let shared = RecentSearchStore()

    private let storage = UserDefaultsManager<[String]>(key: .recentSearch)
    private let searchListRelay = BehaviorRelay<[String]>(value: [])
    private let disposeBag = DisposeBag()
    
    var searchList: Driver<[String]> {
        return searchListRelay.asDriver(onErrorJustReturn: [])
    }
    
    private init() {
        let recentSearchList = getRecentSearch()
        searchListRelay.accept(recentSearchList)
    }
    
    func getRecentSearch() -> [String] {
        guard let searchList = storage.fetch() else { return [] }
        return searchList
    }

    // storage에 저장하고, 별개로 바로 객체를 업데이트해줌(다시 userDefaults에서 받지 않고 이벤트 방출)
    func addRecentSearch(keyword: String) {    
        var list = searchListRelay.value
    
        if let searchIndex = list.firstIndex(of: keyword) {
            list.remove(at: searchIndex)
        }
        list.insert(keyword, at: 0)
 
        storage.save(data: list)
        searchListRelay.accept(list)
    }
    
    func removeSearchKeyword(_ keyword: String, completionHandler: (() -> Void)? = nil) {
        var list = searchListRelay.value
        list.removeAll { $0 == keyword }
        
        storage.save(data: list)
        searchListRelay.accept(list)
    }
    
    func removeAll(completionHandler: (() -> Void)? = nil) {
        storage.removeData()
        searchListRelay.accept([])
    }
}
