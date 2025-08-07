//
//  CinameSearchViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit

//

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
    }
    
    func fetchData() {
        
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
    }
    
    private func resetParams() {
        movieList.removeAll()
        searchKeyword = ""
        page = 1
        totalPages = 1
    }
}

extension CinemaSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cinemaSearchView.tableView.dequeueReusableCell(withIdentifier: CinemaSearchTalbeViewCell.identifier) as? CinemaSearchTalbeViewCell else { return UITableViewCell() }
        
        cell.configureUI(data: movieList[indexPath.row])
        
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
}

extension CinemaSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchBar.resignFirstResponder()
        resetParams()
        fetchQuery(query)

        var tempUser = UserManager.shared.currentUser
        tempUser?.recentSearch.append(query)
        guard let tempUser else { return }
        UserManager.shared.saveUser(tempUser)
    }
}
