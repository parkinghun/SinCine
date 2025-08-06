//
//  CinemaDetailViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit

final class CinemaDetailViewController: UIViewController, ConfigureViewControllerProtocol {
    
    let detailView = CinemaDetailView()
    
    var movie: Movie
    let sections: [Sections] = [.backdrop, .synopsis, .cast]
    var backdropList: [Backdrop] = [] {
        didSet {
            detailView.tableView.reloadSections(IndexSet(integer: Sections.backdrop.rawValue), with: .automatic)
        }
    }
    var synopsis = ""
    var casts: [Cast] = []
    
    
    override func loadView() {
        self.view = detailView
    }
    
    init(movie: Movie) {
        self.movie = movie

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation(title: movie.title)
        setupTableView()
        fetchData()
    }
    
    func fetchData() {
        NetworkManager.shared.fetchData(endPoint: .init(apiType: .image(movieId: movie.id)), type: BackDropResult.self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let result):
                backdropList = result.backdrops

            case .failure(let error):
                print("Failure - ", error)
            }
        }
    }
    
    func setupNavigation(title: String) {
        navigationItem.title = title
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.heart, style: .plain, target: self, action: #selector(hearButtonTapped))
    }
    
    @objc private func hearButtonTapped() {
        print(#function)
        
        
    }
    
    private func setupTableView() {
        detailView.tableView.delegate = self
        detailView.tableView.dataSource = self
        
        detailView.tableView.register(BackDropCell.self, forCellReuseIdentifier: BackDropCell.identifier)
        detailView.tableView.register(SynopsisCell.self, forCellReuseIdentifier: SynopsisCell.identifier)
        detailView.tableView.register(CastCell.self, forCellReuseIdentifier: CastCell.identifier)

//        detailView.tableView.separatorStyle = .none
    }
    
}

extension CinemaDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Sections(rawValue: indexPath.section) {
        case .backdrop:
            guard let cell = detailView.tableView.dequeueReusableCell(withIdentifier: BackDropCell.identifier, for: indexPath) as? BackDropCell else { return UITableViewCell() }
            
            cell.configure(for: backdropList)
            return cell

        case .synopsis:
            guard let cell = detailView.tableView.dequeueReusableCell(withIdentifier: SynopsisCell.identifier, for: indexPath) as? SynopsisCell else { return UITableViewCell() }
                        
            return cell
        case .cast:
            guard let cell = detailView.tableView.dequeueReusableCell(withIdentifier: CastCell.identifier, for: indexPath) as? CastCell else { return UITableViewCell() }
                        
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Sections(rawValue: indexPath.section) {
        case .backdrop: return 300
        case .synopsis: return UITableView.automaticDimension
        case .cast: return 80
        default: return 0
        }
    }
    
    
}


extension CinemaDetailViewController {
    enum Sections: Int, CaseIterable {
        case backdrop  // 푸터(커스텀 뷰)
        case synopsis  // 헤더(커스텀 뷰)
        case cast  // 헤더
    }
}
