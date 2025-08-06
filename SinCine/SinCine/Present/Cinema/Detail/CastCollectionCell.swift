//
//  CastCollectionCell.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import SnapKit
import Kingfisher

final class CastCollectionCell: UICollectionViewCell, ReusableViewProtocol {
    let thumbnailImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel = {
        let label = UILabel()
        label.configure(text: "", font: .medium)
        return label
    }()
    
    let originNameLabel = {
        let label = UILabel()
        label.configure(text: "", font: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierachy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CastCollectionCell: ConfigureViewProtocol {
    func configureHierachy() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(originNameLabel)
    }
    
    func configureLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(12)
            make.size.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
        }
        
        originNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
        }
    }
    
    func configureView() {

    }
    
    
}
