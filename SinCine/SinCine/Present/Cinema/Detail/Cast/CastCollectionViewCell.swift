//
//  CastCell.swift
//  TableViewWithSection
//
//  Created by 박성훈 on 8/6/25.
//

import UIKit
import SnapKit

final class CastTableViewCell: UITableViewCell, ReusableViewProtocol {
    
    let wrapperView = UIView()
    
    let actorImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel = {
       let label = UILabel()
        label.text = "현빈"
        label.textColor = .white
        return label
    }()
    
    let originalNameLabel = {
       let label = UILabel()
        label.text = "Anh Jung-geun"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            actorImageView.layer.cornerRadius = self.actorImageView.bounds.width / 2
        }
    }
    
}

extension CastTableViewCell: ConfigureViewProtocol {
    func configureHierachy() {
        contentView.addSubview(wrapperView)
        wrapperView.addSubview(actorImageView)
        wrapperView.addSubview(nameLabel)
        wrapperView.addSubview(originalNameLabel)
    }
    
    func configureLayout() {
        wrapperView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        actorImageView.snp.makeConstraints { make in
            make.height.width.equalTo(wrapperView.snp.height)
            make.leading.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(actorImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        
        originalNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureView() {
        self.backgroundColor = .clear
    }
    
    
}
