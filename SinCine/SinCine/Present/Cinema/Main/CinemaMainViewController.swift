//
//  CinemaViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit
import RxSwift
import RxCocoa

final class CinemaMainViewController: UIViewController, ConfigureViewControllerProtocol{
    
    let cinemaMainView: CinemaMainView
    var todayMovies: [Movie] = [] {
        didSet {
            cinemaMainView.todayMovieCollectionView.reloadData()
        }
    }
    
    private let viewModel: CinemaMainViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: CinemaMainViewModel) {
        self.viewModel = viewModel
        self.cinemaMainView = CinemaMainView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = cinemaMainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation(title: StringLiterals.NavigationTitle.main.rawValue)
        configureProfile()
        setupCollectionView()
        configureNotification()
        bind()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        print(#function)
        updateUI()
    }
    
    private func bind() {
        let deleteItem = PublishRelay<String>()
        
        let input = CinemaMainViewModel.Input(
            recentSearhRemoveAll: cinemaMainView.removeAllButton.rx.tap,
            recentSearchRemovieItem: deleteItem,
            recentSearchTapped: cinemaMainView.recentSearchCollectionView.rx.modelSelected(String.self),
            todayCellSelected: cinemaMainView.todayMovieCollectionView.rx.modelSelected(Movie.self))
        let output = viewModel.transform(input: input)
        
        output.searchList
            .drive(cinemaMainView.recentSearchCollectionView.rx.items(cellIdentifier: RecentSearchCollectionViewCell.identifier, cellType: RecentSearchCollectionViewCell.self)) { item, element, cell in
                
                cell.deleteButtonTapped
                    .bind(to: deleteItem)
                    .disposed(by: cell.disposeBag)
                
                cell.configure(keyword: element)
            }
            .disposed(by: disposeBag)
        
        output.searchListIsEmpty
            .drive(with: self) { owner, value in
                owner.cinemaMainView.configureRecentSearch(isEmpty: value)
            }
            .disposed(by: disposeBag)
        
        output.todayMovieList
            .drive(cinemaMainView.todayMovieCollectionView.rx.items(cellIdentifier: TodayMovieCollectionViewCell.identifier, cellType: TodayMovieCollectionViewCell.self)) { item, element, cell in
                
                cell.configureUI(data: element)
            }
            .disposed(by: disposeBag)
        
        output.detailMovieInfo
            .bind(with: self) { owner, value in
                let detailVC = CinemaDetailViewController(movie: value)
                owner.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    // 좋아요 하트 / 최근 검색어
    // 프로토콜 추상화
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
        //        cinemaMainView.configureRecentSearch(isEmpty: RecentSearchManager.shared.searchList.isEmpty)
        cinemaMainView.recentSearchCollectionView.reloadData()
    }
    
    //    private func updateRecentSearchView() {
    //        cinemaMainView.configureRecentSearch(isEmpty: RecentSearchManager.shared.searchList.isEmpty)
    //    }
    
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
        cinemaMainView.recentSearchCollectionView.register(RecentSearchCollectionViewCell.self, forCellWithReuseIdentifier: RecentSearchCollectionViewCell.identifier)
        cinemaMainView.todayMovieCollectionView.register(TodayMovieCollectionViewCell.self, forCellWithReuseIdentifier: TodayMovieCollectionViewCell.identifier)
        
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
