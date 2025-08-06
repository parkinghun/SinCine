//
//  CinemaDetailView.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import SnapKit

final class CinemaDetailView: BaseView {
    let tableView = UITableView()
    
    //섹션 1 백드롭(최대 5장, horizontal, paging), footer 날짜, 별점, 장르
    // 섹션 2 Synopsis
    // 섹션 3 Cast
    
    
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
