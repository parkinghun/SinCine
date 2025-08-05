//
//  CinemaViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit

//TODO 하나만 있을 때 안뜸
final class CinemaMainViewController: UIViewController, ConfigureViewControllerProtocol{
    
    let cinemaMainView = CinemaMainView()
    
    var recentKeyword: [String] = [] {
        didSet {
            updateRecentSearchView()
            cinemaMainView.recentSearchCollectionView.reloadData()
        }
    }
    var todayMovies: [Movie] = [] {
        didSet {
            cinemaMainView.todayMovieCollectionView.reloadData()
        }
    }
    
    var tempUser: User? {
        didSet {
            dump(tempUser)
            recentKeyword = tempUser?.recentKeyword ?? []
            // 좋아요도 여기서
        }
    }
    
    override func loadView() {
        self.view = cinemaMainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation(title: StringLiterals.NavigationTitle.main.rawValue)
        
        configureProfile()
        setupDelegate()
        getTodayMovie()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        print(#function)
        tempUser = UserManager.shared.currentUser
        cinemaMainView.recentSearchCollectionView.reloadData()
    }
    
    func getTodayMovie() {
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
        cinemaMainView.configureRecentSearch(isEmpty: recentKeyword.isEmpty)
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
        cinemaMainView.delegate = self
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
            cell.delegate = self
            
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

//TODO: DetailView..
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

extension CinemaMainViewController: CinemaMainViewDelegate {
    func handleRemoveAllButton() {
        print(#function)
        var temp = tempUser
        temp?.recentSearch.removeAll()
        guard let temp else { return }
        tempUser = temp
        UserManager.shared.saveUser(temp)
    }
}

extension CinemaMainViewController: RecentSearCellDelegate {
    func handleKeywordTapped(cell: RecentSearchCollectionViewCell) {
        if let indexPath = cinemaMainView.recentSearchCollectionView.indexPath(for: cell) {
            print(#function)
            print("디테일 뷰 이동")
        }

    }
    
    func handleDeleteButton(cell: RecentSearchCollectionViewCell) {
        
        if let indexPath = cinemaMainView.recentSearchCollectionView.indexPath(for: cell) {
            tempUser?.recentSearch.remove(at: indexPath.item)
            guard let tempUser else { return }
            UserManager.shared.saveUser(tempUser)
        }
    }
}
