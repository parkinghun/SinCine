//
//  CastTableViewCell.swift
//  TableViewWithSection
//
//  Created by 박성훈 on 8/6/25.
//

import UIKit
import SnapKit

final class SynopsisTableViewCell: UITableViewCell, ReusableViewProtocol {
    
    let overviewLabel = {
       let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 3
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierachy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSummaryLabel(isTappedMoreBT: Bool) {
        overviewLabel.numberOfLines = isTappedMoreBT ? 0 : 3
    }
    
    func configure(overview: String) {
        overviewLabel.text = overview
    }
    
}

extension SynopsisTableViewCell: ConfigureViewProtocol {
    func configureHierachy() {
        contentView.addSubview(overviewLabel)
    }
    
    func configureLayout() {
        overviewLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureView() {
        self.backgroundColor = .clear
    }
    
    
}
