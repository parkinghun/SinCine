//
//  CinemaViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit

final class CinemaMainViewController: UIViewController, ConfigureViewControllerProtocol{
    
    let cinemaMainView = CinemaMainView()
    
    var recentKeyword: [String] = ["스파이더스파", "스파이더", "스파이더", "스파이더", "스파이더", "스파이더", "스파이더", "스파이더", "스파이더",]
    
    var todayMovies: [Movie] = [] {
        didSet {
            cinemaMainView.todayMovieCollectionView.reloadData()
        }
    }
//    UserManager.shared.currentUser?.recentSearch ?? [] {
//        didSet {
//            updateRecentSearchView()
//        }
//    }
    
    override func loadView() {
        self.view = cinemaMainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation(title: StringLiterals.NavigationTitle.main.rawValue)
        
        configureProfile()
        setupDelegate()
        updateRecentSearchView()
        getTodyMovie()
    }
    
    func getTodyMovie() {
        NetworkManager.shared.fetchData(endPoint: .init(apiType: .trending), type: MovieResult.self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let movieResult):
                self.todayMovies = movieResult.results
            case .failure(let error):
                print("Failure - ", error)
            }
        }
    }
    
    private func updateRecentSearchView() {
        guard let currentUSer = UserManager.shared.currentUser else { return }
  
        cinemaMainView.configureRecentSearch(isEmpty: recentKeyword.isEmpty)

        
//        cinemaMainView.configureRecentSearch(isEmpty: currentUSer.recentSearch.isEmpty)
    }
    
    private func configureProfile() {
        guard let user = UserManager.shared.currentUser else { return }
        cinemaMainView.profileView.configureUI(data: user)
    }
    
    func setupNavigation(title: String) {
        navigationItem.title = title
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.magnifyingglass, style: .plain, target: self, action: #selector(searchButtonTapped))
    }
    
    @objc private func searchButtonTapped() {
        print(#function)
        let vc = CinemaSearchViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func setupDelegate() {
        cinemaMainView.recentSearchCollectionView.delegate = self
        cinemaMainView.recentSearchCollectionView.dataSource = self
        
        cinemaMainView.todayMovieCollectionView.delegate = self
        cinemaMainView.todayMovieCollectionView.dataSource = self
        
        cinemaMainView.recentSearchCollectionView.register(RecentSearchCollectionViewCell.self, forCellWithReuseIdentifier: RecentSearchCollectionViewCell.identifier)
        
        cinemaMainView.todayMovieCollectionView.register(TodayMovieCollectionViewCell.self, forCellWithReuseIdentifier: TodayMovieCollectionViewCell.identifier)

        cinemaMainView.profileView.delegate = self
        
        
    }
    
}
    

extension CinemaMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cinemaMainView.recentSearchCollectionView {
            return recentKeyword.count
            
            
//            return UserManager.shared.currentUser?.recentSearch.count ?? 0
        } else {  // 오늘 영화
            return todayMovies.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cinemaMainView.recentSearchCollectionView {
            guard let cell = cinemaMainView.recentSearchCollectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.identifier, for: indexPath) as? RecentSearchCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configure(keyword: recentKeyword[indexPath.item])
            
            return cell
        } else {
            guard let cell = cinemaMainView.todayMovieCollectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.identifier, for: indexPath) as?TodayMovieCollectionViewCell else { return UICollectionViewCell() }
            
            let movie = todayMovies[indexPath.item]
            let isLike = LikeManager.shared.isLike(movieID: movie.id)
            
            cell.configureUI(data: movie)
            cell.updateHeart(isLike: isLike)
            cell.delegate = self
            
            return cell
        }
    }
}

extension CinemaMainViewController: UICollectionViewDelegate {
    
}

extension CinemaMainViewController: ProfileViewDelegate {
    func handleTapGestureAction() {
        let nicknameSettingVC = NicknameSettingViewController(isDetailView: false, isModal: true)
        
        let nav = BaseNavigationController(rootViewController: nicknameSettingVC)
        
        nicknameSettingVC.settingDelegate = self
        
        present(nav, animated: true)
    }
}

extension CinemaMainViewController: NicknameSettingVCDelegate {
    func handleUserUpdate() {
        guard let user = UserManager.shared.currentUser else { return }
        cinemaMainView.profileView.configureUI(data: user)
    }
}

extension CinemaMainViewController: TodayMovieCellDelegate {
    func handleLikeButtonAction(cell: TodayMovieCollectionViewCell) {
        print(#function)
        
        if let indexPath = cinemaMainView.todayMovieCollectionView.indexPath(for: cell) {
            print("\(indexPath.item) 하트 눌림")
            let movieId = todayMovies[indexPath.item].id
            
            LikeManager.shared.toggleLike(for: movieId)
            
            cinemaMainView.todayMovieCollectionView.reloadData()
        }
    }
}
