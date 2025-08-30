//
//  CinemaMainViewModel.swift
//  SinCine
//
//  Created by 박성훈 on 8/28/25.
//

import Foundation
import RxSwift
import RxCocoa

final class CinemaMainViewModel: ViewModelType {
    struct Input {
        let recentSearhRemoveAll: ControlEvent<Void>
        let recentSearchRemovieItem: PublishRelay<String>
        let recentSearchTapped: ControlEvent<String>
        let todayCellSelected: ControlEvent<Movie>
    }
    struct Output {
        let todayMovieList: Driver<[Movie]>
        let searchList: Driver<[String]>
        let searchListIsEmpty: Driver<Bool>
        let detailMovieInfo: PublishRelay<Movie>
        
    }
    
    typealias TodayMovieResult = Result<MovieResult, NetworkError>
    private let recentSearchStore: RecentSearchStore
    let disposeBag = DisposeBag()
    
    init(recentSearchStore: RecentSearchStore = RecentSearchStore.shared) {
        self.recentSearchStore = recentSearchStore
    }
    
    func transform(input: Input) -> Output {
        let todayMovieList = PublishRelay<[Movie]>()
        let searchList = recentSearchStore.searchList
        let detailMovieInfo = PublishRelay<Movie>()
        
        input.recentSearhRemoveAll
            .bind(with: self) { owner, _ in
                owner.recentSearchStore.removeAll()
            }
            .disposed(by: disposeBag)
        
        input.recentSearchRemovieItem
            .bind(with: self) { owner, value in
                owner.recentSearchStore.removeSearchKeyword(value) {
                    print("제거 완료")
                }
            }
            .disposed(by: disposeBag)
        
        getTodayMovie()
            .asObservable()
            .bind(with: self) { owner, response in
                switch response {
                case .success(let data):
                    todayMovieList.accept(data.results)
                case .failure(let error):
                    print("알럿 띄우기", error)
                }
            }
            .disposed(by: disposeBag)
        
        
        let todayDriver = todayMovieList
            .asDriver(onErrorJustReturn: [])
        
        let searchListIsEmpty = searchList
            .map { $0.isEmpty }
        
        input.todayCellSelected
            .bind(with: self) { owner, value in
                detailMovieInfo.accept(value)
            }.disposed(by: disposeBag)
        
        return Output(todayMovieList: todayDriver, searchList: searchList, searchListIsEmpty: searchListIsEmpty, detailMovieInfo: detailMovieInfo)
    }
}

private extension CinemaMainViewModel {
    func getTodayMovie() -> Single<TodayMovieResult> {
        return Single.create { observer in
            NetworkManager.shared.fetchData(endPoint: .init(apiType: .trending), type: MovieResult.self) { (result: TodayMovieResult) in
                switch result {
                case .success(let value):
                    observer(.success(.success(value)))
                case .failure(let error):
                    observer(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
}
