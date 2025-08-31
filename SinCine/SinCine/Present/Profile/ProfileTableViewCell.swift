//
//  ProfileTableViewCell.swift
//  SinCine
//
//  Created by 박성훈 on 8/11/25.
//

import UIKit
import SnapKit

final class ProfileTableViewCell: UITableViewCell, ReusableViewProtocol {
    let wrapperView = UIView()
    let titleLabel = {
        let label = UILabel()
        label.textColor = Colors.white
        return label
    }()
    let separator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierachy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}

private extension ProfileTableViewCell {
    func configureHierachy() {
        contentView.addSubview(wrapperView)
        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(separator)
    }
    
    func configureLayout() {
        wrapperView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func configureView() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        wrapperView.backgroundColor = .clear
        separator.backgroundColor = .lightGray
    }
}
