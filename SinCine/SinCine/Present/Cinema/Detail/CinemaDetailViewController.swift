//
//  CinemaDetailViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit

final class CinemaDetailViewController: UIViewController, ConfigureViewControllerProtocol {
    
    var movie: Movie
    var backdropList: [Backdrop] = [] {
        didSet {
//            detailView.tableView.reloadSections(IndexSet(integer: Sections.backdrop.rawValue), with: .automatic)
        }
    }
    var synopsis = ""
    var casts: [Cast] = []
    
    
    let detailView = CinemaDetailView()
    
    private var isTappedMoreButton = false {
        didSet {
            detailView.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
    
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
        configureTableView()
//        fetchData()
    }
    
    private func configureTableView() {
        detailView.tableView.delegate = self
        detailView.tableView.dataSource = self
        
        detailView.tableView.register(BackdropTableViewCell.self, forCellReuseIdentifier: BackdropTableViewCell.identifier)
        detailView.tableView.register(BackdropFooterView.self, forHeaderFooterViewReuseIdentifier: BackdropFooterView.identifier)
        
        detailView.tableView.register(SynopsisTableViewCell.self, forCellReuseIdentifier: SynopsisTableViewCell.identifier)
        detailView.tableView.register(SynopsisHeaderView.self, forHeaderFooterViewReuseIdentifier: SynopsisHeaderView.identifier)
        
        detailView.tableView.register(CastTableViewCell.self, forCellReuseIdentifier: CastTableViewCell.identifier)
        detailView.tableView.register(CastHeaderView.self, forHeaderFooterViewReuseIdentifier: CastHeaderView.identifier)
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
    
}

extension CinemaDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    //TODO: 수정하기
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections.allCases[section] {
        case .backdrop: return 1
        case .synopsis: return 1
        case .cast: return 10
        }
    }
    
    //TODO: TableViewCell 리턴해주기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let section = Sections.allCases[indexPath.section]
        
        switch section {
        case .backdrop:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BackdropTableViewCell.identifier, for: indexPath) as? BackdropTableViewCell else { return UITableViewCell() }
            
            return cell
        case .synopsis:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SynopsisTableViewCell.identifier, for: indexPath) as? SynopsisTableViewCell else { return UITableViewCell() }
            
            // 데이터 전송
            cell.configureSummaryLabel(isTappedMoreBT: isTappedMoreButton)
            
            return cell
        case .cast:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.identifier, for: indexPath) as? CastTableViewCell else { return UITableViewCell() }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = Sections.allCases[indexPath.section]
        
        switch section {
        case .backdrop:
            return UIScreen.main.bounds.width * 0.8
        case .synopsis:
            return UITableView.automaticDimension
        case .cast:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch Sections.allCases[section] {
        case .backdrop:
            return nil
        case .cast:
            return tableView.dequeueReusableHeaderFooterView(withIdentifier: CastHeaderView.identifier)

        case .synopsis:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SynopsisHeaderView.identifier) as? SynopsisHeaderView else {
                return UITableViewHeaderFooterView()
            }
            
            header.delegate = self
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch Sections.allCases[section] {
        case .backdrop:
            return tableView.dequeueReusableHeaderFooterView(withIdentifier: BackdropFooterView.identifier)
        case .cast:
            return nil
        case .synopsis:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch Sections.allCases[section] {
        case .backdrop:
            return 0
        case .cast:
            return 44
        case .synopsis:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch Sections.allCases[section] {
        case .backdrop:
            return 44
        case .cast:
            return 0
        case .synopsis:
            return 0
        }
    }
}

extension CinemaDetailViewController: SynopsisHeaderViewDelegate {
    func handleMoreButtonAction() {
        print(#function)
        isTappedMoreButton.toggle()
    }
}

extension CinemaDetailViewController {
    enum Sections: CaseIterable {
        case backdrop
        case synopsis
        case cast
        
        //TODO: - 고정된 데이터가 아닌 유동적인 데이터를 넣어줄땐 cellForRowAt에서 줘야함.
        // View공통 뷰가 아닌 이상 뷰를 보여주는게 맞는듯
        var rows: UIView.Type {
            switch self {
            case .backdrop: BackdropTableViewCell.self
            case .synopsis: SynopsisTableViewCell.self
            case .cast: CastTableViewCell.self
            }
        }
        
        // Header Footer 구분해주는 게 있으면 분기해서 편하게ㅐ 쓸 듯??
        // supplementary
        var header: UIView.Type? {
            switch self {
            case .backdrop:
                return nil
            case .synopsis:
                return SynopsisHeaderView.self
            case .cast:
                return CastHeaderView.self
            }
        }
        
        var footer: UIView? {
            switch self {
            case .backdrop:
                return BackdropFooterView()
            default:
                return nil
            }
        }
    }
}
