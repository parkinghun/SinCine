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
        let likeButtonTapped: PublishRelay<Int>
    }
    struct Output {
        let todayMovieList: Driver<[Movie]>
        let searchList: Driver<[String]>
        let searchListIsEmpty: Driver<Bool>
        let detailMovieInfo: PublishRelay<Movie>
        let likeTitle: Driver<String>
        // profileData
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
        let likeList = LikeManager.shared.likeList
        
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
        
        let mergedMovieList: Driver<[Movie]> = Observable.combineLatest(todayMovieList, likeList) { movies, likeIds in
            movies.map { movie in
                var updateMovie = movie
                updateMovie.isLike = likeIds.contains(movie.id)
                return updateMovie
            }
        }
            .asDriver(onErrorJustReturn: [])

        
        let searchListIsEmpty = searchList
            .map { $0.isEmpty }
        
        input.todayCellSelected
            .bind(with: self) { owner, value in
                detailMovieInfo.accept(value)
            }.disposed(by: disposeBag)
        
        let likeTitle = likeList
            .map { "\($0.count)개의 무비박스 보관중" }
            .asDriver(onErrorJustReturn: "")
        
        
        input.likeButtonTapped
            .bind(with: self) { owner, value in
                LikeManager.shared.toggleLike(for: value)
            }
            .disposed(by: disposeBag)
        
        return Output(todayMovieList: mergedMovieList, searchList: searchList, searchListIsEmpty: searchListIsEmpty, detailMovieInfo: detailMovieInfo, likeTitle: likeTitle)
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
