//
//  SearchView.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import SnapKit

final class CinemaSearchView: BaseView {
    
    let searchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = StringLiterals.Placeholder.search.rawValue
        searchBar.searchBarStyle = .minimal
        searchBar.becomeFirstResponder()
        searchBar.searchTextField.leftView?.tintColor = Colors.white
        searchBar.searchTextField.textColor = Colors.white
        
//        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
//            textfield.textColor = Colors.white
//            textfield.tintColor = Colors.white
//        }
        
        
        return searchBar
    }()
    
    let searchResultEmptyLabel = {
        let label = UILabel()
        label.configure(text: StringLiterals.Empty.search.rawValue, color: Colors.lightGray, font: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let tableView = UITableView()
    
    func updateUI(isEmpty: Bool) {
        searchResultEmptyLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    override func configureHierachy() {
        self.addSubview(searchBar)
        self.addSubview(searchResultEmptyLabel)
        self.addSubview(tableView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        searchResultEmptyLabel.snp.makeConstraints { make in
            make.edges.equalTo(tableView)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(LayoutLiterals.horizontalPadding)
            make.horizontalEdges.equalToSuperview().inset(LayoutLiterals.horizontalPadding)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        tableView.backgroundColor = .clear
        tableView.isHidden = true
    }
}
