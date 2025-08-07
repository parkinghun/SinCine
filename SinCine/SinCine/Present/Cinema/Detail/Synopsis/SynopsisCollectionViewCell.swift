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
        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
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
