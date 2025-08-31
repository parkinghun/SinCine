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
        let profileTapped: ControlEvent<Void>
    }
    struct Output {
        let searchList: Driver<[String]>
        let searchListIsEmpty: Driver<Bool>
        let searchQuery: Driver<String>
        let todayMovieList: Driver<[Movie]>
        let detailMovieInfo: PublishRelay<Movie>
        let likeTitle: Driver<String>
        let currentUser: Driver<User>
        let profile: Driver<(User, String)>
        let presentNicknameSettingView: Driver<Void>
    }
    
    typealias TodayMovieResult = Result<MovieResult, NetworkError>
    private let recentSearchStore: RecentSearchStore
    let disposeBag = DisposeBag()
    
    init(recentSearchStore: RecentSearchStore = RecentSearchStore.shared) {
        self.recentSearchStore = recentSearchStore
    }
    
    func transform(input: Input) -> Output {
        let searchList = recentSearchStore.searchList
        let searchQuery = PublishRelay<String>()
        
        let todayMovieList = PublishRelay<[Movie]>()
        let detailMovieInfo = PublishRelay<Movie>()
        let likeList = LikeManager.shared.likeList
        let currentUser = UserManager.shared.currentUser
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: .init(nickname: ""))
        
        // 최근 검색어
        input.recentSearhRemoveAll
            .bind(with: self) { owner, _ in
                owner.recentSearchStore.removeAll()
            }
            .disposed(by: disposeBag)
        
        input.recentSearchRemovieItem
            .bind(with: self) { owner, value in
                print("x 버튼 클릭")
                owner.recentSearchStore.removeSearchKeyword(value)
            }
            .disposed(by: disposeBag)
        
        input.recentSearchTapped
            .bind(to: searchQuery)
            .disposed(by: disposeBag)
        
        let searchListIsEmpty = searchList
            .map { $0.isEmpty }
        
        // 오늘의 영화
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
        
        // 프로필
        let profile: Driver<(User, String)> = Driver.combineLatest(currentUser, likeTitle)
        let presentNicknameSettingView = input.profileTapped
            .asDriver(onErrorJustReturn: ())
        
        return Output(searchList: searchList,
                      searchListIsEmpty: searchListIsEmpty,
                      searchQuery: searchQuery.asDriver(onErrorJustReturn: ""),
                      todayMovieList: mergedMovieList,
                      detailMovieInfo: detailMovieInfo,
                      likeTitle: likeTitle,
                      currentUser: currentUser,
                      profile: profile,
                      presentNicknameSettingView: presentNicknameSettingView)
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
