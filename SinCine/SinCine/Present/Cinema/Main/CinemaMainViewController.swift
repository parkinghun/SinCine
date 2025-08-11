//
//  CinemaViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit

final class CinemaMainViewController: UIViewController, ConfigureViewControllerProtocol{
    
    let cinemaMainView = CinemaMainView()
    var todayMovies: [Movie] = [] {
        didSet {
            cinemaMainView.todayMovieCollectionView.reloadData()
        }
    }
    
    override func loadView() {
        self.view = cinemaMainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation(title: StringLiterals.NavigationTitle.main.rawValue)
        configureProfile()
        setupCollectionView()
        getTodayMovie()
        configureNotification()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        print(#function)
        updateUI()
    }
    
    private func updateUI() {
        guard let currentUser = UserManager.shared.currentUser else { return }
        
        for (index, movie) in todayMovies.enumerated() {
            if LikeManager.shared.isLike(movieID: movie.id) {
                todayMovies[index].isLike = true
            } else {
                todayMovies[index].isLike = false
            }
        }
        cinemaMainView.profileView.configureUI(data: currentUser, like: LikeManager.shared.getAllLikeMovieIDs)
        cinemaMainView.configureRecentSearch(isEmpty: RecentSearchManager.shared.searchList.isEmpty)
        cinemaMainView.recentSearchCollectionView.reloadData()
    }
    
    private func getTodayMovie() {
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
        cinemaMainView.configureRecentSearch(isEmpty: RecentSearchManager.shared.searchList.isEmpty)
    }
    
    private func configureProfile() {
        guard let user = UserManager.shared.currentUser else { return }
        cinemaMainView.profileView.configureUI(data: user, like: LikeManager.shared.getAllLikeMovieIDs)
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
    
    private func setupCollectionView() {
        cinemaMainView.recentSearchCollectionView.delegate = self
        cinemaMainView.recentSearchCollectionView.dataSource = self
        
        cinemaMainView.todayMovieCollectionView.delegate = self
        cinemaMainView.todayMovieCollectionView.dataSource = self
        
        cinemaMainView.recentSearchCollectionView.register(RecentSearchCollectionViewCell.self, forCellWithReuseIdentifier: RecentSearchCollectionViewCell.identifier)
        cinemaMainView.todayMovieCollectionView.register(TodayMovieCollectionViewCell.self, forCellWithReuseIdentifier: TodayMovieCollectionViewCell.identifier)
        
        cinemaMainView.delegate = self
        LikeManager.shared.delegate = self
        UserManager.shared.delegate = self
    }
    
    func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTapGestureAction), name: .profileViewTapped, object: nil)
    }
    
    @objc func handleTapGestureAction() {
        let nicknameSettingVC = NicknameSettingViewController(isDetailView: false, isModal: true)
        let nav = BaseNavigationController(rootViewController: nicknameSettingVC)
        present(nav, animated: true)
    }
}

extension CinemaMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cinemaMainView.recentSearchCollectionView {
            return RecentSearchManager.shared.searchList.count
        } else {
            return todayMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cinemaMainView.recentSearchCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.identifier, for: indexPath) as? RecentSearchCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configure(keyword: RecentSearchManager.shared.searchList[indexPath.item])
            cell.delegate = self
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.identifier, for: indexPath) as?TodayMovieCollectionViewCell else { return UICollectionViewCell() }
            
            let movie = todayMovies[indexPath.item]
            cell.configureUI(data: movie)
            cell.delegate = self
            
            return cell
        }
    }
}

extension CinemaMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cinemaMainView.todayMovieCollectionView {
            let detailVC = CinemaDetailViewController(movie: todayMovies[indexPath.item])
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension CinemaMainViewController: NicknameSettingVCDelegate {
    func handleUserUpdate() {
        guard let currentUser = UserManager.shared.currentUser else { return }
        cinemaMainView.profileView.configureUI(data: currentUser, like: LikeManager.shared.likeList)
    }
}

extension CinemaMainViewController: TodayMovieCellDelegate {
    func handleLikeButtonAction(cell: TodayMovieCollectionViewCell) {
        if let indexPath = cinemaMainView.todayMovieCollectionView.indexPath(for: cell) {
            updateLike(itemIndex: indexPath.item)
        }
    }
    
    private func updateLike(itemIndex: Int) {
        todayMovies[itemIndex].isLike.toggle()
        LikeManager.shared.toggleLike(for: todayMovies[itemIndex].id)
    }
}

extension CinemaMainViewController: CinemaMainViewDelegate {
    func handleRemoveAllButton() {
        print(#function)
        RecentSearchManager.shared.removeAll() { [weak self] in
            guard let self else { return }
            self.cinemaMainView.configureRecentSearch(isEmpty: true)
            cinemaMainView.recentSearchCollectionView.reloadData()
        }
    }
}

extension CinemaMainViewController: RecentSearCellDelegate {
    func handleKeywordTapped(cell: RecentSearchCollectionViewCell) {
        if let indexPath = cinemaMainView.recentSearchCollectionView.indexPath(for: cell) {
            let vc = CinemaSearchViewController(query: RecentSearchManager.shared.searchList[indexPath.item])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func handleDeleteButton(cell: RecentSearchCollectionViewCell) {
        if let indexPath = cinemaMainView.recentSearchCollectionView.indexPath(for: cell) {
            RecentSearchManager.shared.removeSearchKeyword(index: indexPath.item) { [weak self] in
                guard let self else { return }
                
                self.cinemaMainView.configureRecentSearch(isEmpty: RecentSearchManager.shared.searchList.isEmpty)
                cinemaMainView.recentSearchCollectionView.reloadData()
            }
        }
    }
}

extension CinemaMainViewController: LikeManagerDelegate {
    func updateLikeUI() {
        let likeCount = LikeManager.shared.likeList.count
        let likeTitle = "\(likeCount)개의 무비박스 보관중"
        cinemaMainView.profileView.configureLikeLabel(likeTitle: likeTitle)
    }
}

extension CinemaMainViewController: UserManagerDelegate {
    func updateUserUI() {
        guard let currentUser = UserManager.shared.currentUser else { return }
        cinemaMainView.profileView.configureUserInfo(nickname: currentUser.nickname, date: currentUser.formattedDate)
    }
}
