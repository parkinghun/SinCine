//
//  CinemaViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit

final class CinemaMainViewController: UIViewController, ConfigureViewControllerProtocol{
    
    let cinemaMainView = CinemaMainView()
    
    var recentKeyword: [String] = ["1", "2", "3"]
    
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
        navigationController?.title = title
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.magnifyingglass, style: .plain, target: self, action: #selector(searchButtonTapped))
    }
    
    @objc private func searchButtonTapped() {
        print(#function)
    }
    
    private func setupDelegate() {
        cinemaMainView.recentSearchCollectionView.delegate = self
        cinemaMainView.recentSearchCollectionView.dataSource = self
        
        cinemaMainView.todayMovieCollectionView.delegate = self
        cinemaMainView.todayMovieCollectionView.dataSource = self
        
        cinemaMainView.recentSearchCollectionView.register(RecentSearchCollectionViewCell.self, forCellWithReuseIdentifier: RecentSearchCollectionViewCell.identifier)
        
        cinemaMainView.todayMovieCollectionView.register(TodayMovieCollectionViewCell.self, forCellWithReuseIdentifier: TodayMovieCollectionViewCell.identifier)

    }
    
}
    

extension CinemaMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cinemaMainView.recentSearchCollectionView {
            return recentKeyword.count
            
            
//            return UserManager.shared.currentUser?.recentSearch.count ?? 0
        } else {  // 오늘 영화
            return 20
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cinemaMainView.recentSearchCollectionView {
            guard let cell = cinemaMainView.recentSearchCollectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.identifier, for: indexPath) as? RecentSearchCollectionViewCell else { return UICollectionViewCell() }
            
            
            return cell
        } else {
            guard let cell = cinemaMainView.todayMovieCollectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.identifier, for: indexPath) as?TodayMovieCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
        }
    }
    
    
}

extension CinemaMainViewController: UICollectionViewDelegate {
    
}
