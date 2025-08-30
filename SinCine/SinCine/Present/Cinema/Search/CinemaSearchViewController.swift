//
//  CinameSearchViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit

final class CinemaSearchViewController: UIViewController, ConfigureViewControllerProtocol {
    
    private let cinemaSearchView = CinemaSearchView()
    private var movieList: [Movie] = [] {
        didSet {
            cinemaSearchView.updateUI(isEmpty: movieList.isEmpty)
            cinemaSearchView.tableView.reloadData()
        }
    }
    
    private var searchKeyword = ""
    private var page = 1
    private var totalPages = 1
    
    /// 최근 검색어로 진입 시 사용
    convenience init(query: String) {
        self.init(nibName: nil, bundle: nil)
        fetchQuery(query)
        cinemaSearchView.searchBar.text = query
    }
    
    override func loadView() {
        self.view = cinemaSearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation(title: StringLiterals.NavigationTitle.search.rawValue)
        configureTalbeView()
        setupDelegate()
        configureNotification()
    }

    private func configureTalbeView() {
        cinemaSearchView.tableView.delegate = self
        cinemaSearchView.tableView.dataSource = self
        
        cinemaSearchView.tableView.register(CinemaSearchTalbeViewCell.self, forCellReuseIdentifier: CinemaSearchTalbeViewCell.identifier)
        cinemaSearchView.tableView.rowHeight = 130
    }
    
    private func setupDelegate() {
        cinemaSearchView.searchBar.delegate = self
    }
    
    private func fetchQuery(_ query: String, page: Int = 1) {
        NetworkManager.shared.fetchData(endPoint: .init(apiType: .search(query: query, page: page)), type: MovieResult.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movieResult):
                self.movieList.append(contentsOf: movieResult.results)
                self.searchKeyword = query
            case .failure(let error):
                print("Failure - ", error)
            }
        }
        
        RecentSearchStore.shared.addRecentSearch(keyword: query)
        cinemaSearchView.dismissSearchBarKeyboard()
    }
    
    private func resetParams() {
        movieList.removeAll()
        searchKeyword = ""
        page = 1
        totalPages = 1
    }
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLikeButtonAction(_:)), name: .searchLikeTapped, object: nil)
    }
    
    @objc func handleLikeButtonAction(_ sender: Notification) {
        guard let searchTableViewcell = sender.object as? CinemaSearchTalbeViewCell,
              let indexPath = cinemaSearchView.tableView.indexPath(for: searchTableViewcell) else { return }
        
        updateLike(indexPath: indexPath)
    }
    
    private func updateLike(indexPath: IndexPath) {
        movieList[indexPath.row].isLike.toggle()
        LikeManager.shared.toggleLike(for: movieList[indexPath.row].id)
    }
}

extension CinemaSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CinemaSearchTalbeViewCell.identifier) as? CinemaSearchTalbeViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.configureUI(row: movieList[indexPath.row])
        return cell
    }
}

extension CinemaSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = CinemaDetailViewController(movie: movieList[indexPath.row])
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("row index - ", indexPath.row)
        
        if indexPath.row == (movieList.count - 4) {
            page += 1
            fetchQuery(searchKeyword, page: page)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension CinemaSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        guard let query = searchBar.text,
            searchKeyword != query else { return }
        resetParams()
        fetchQuery(query)
    }
}
