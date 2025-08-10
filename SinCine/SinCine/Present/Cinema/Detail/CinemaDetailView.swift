//
//  CinemaDetailView.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import SnapKit

final class CinemaDetailView: BaseView {
    let tableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        return tv
    }()
    
    override func configureHierachy() {
        addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        tableView.backgroundColor = .clear
    }
}
