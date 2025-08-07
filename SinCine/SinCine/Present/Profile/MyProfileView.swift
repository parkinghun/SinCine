//
//  MyProfileView.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import SnapKit

final class MyProfileView: BaseView, ReusableViewProtocol {
    
    let profileView = ProfileView()
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func configureHierachy() {
        addSubview(profileView)
        addSubview(tableView)
    }
    
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(120)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(profileView)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        profileView.layer.cornerRadius = 12
        profileView.clipsToBounds = true
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Colors.lightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: MyProfileView.identifier)
    }
}
