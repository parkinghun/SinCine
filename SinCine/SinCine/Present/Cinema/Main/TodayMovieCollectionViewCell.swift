//
//  TodayMovieCollectionViewCell.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import SnapKit

final class TodayMovieCollectionViewCell: UICollectionViewCell, ReusableViewProtocol {
    
    let posterImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let titleLabel = {
       let label = UILabel()
        label.configure(text: "Test", font: .semiBold)
        return label
    }()
    
    let likeButton = {
       let bt = UIButton()
        bt.setImage(Images.heart, for: .normal)
        bt.tintColor = Colors.mainColor
        return bt
    }()
    
    let overviewLabel = {
       let label = UILabel()
        label.configure(text: "TestTestTest", font: .regular)
        label.numberOfLines = 3
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

extension TodayMovieCollectionViewCell: ConfigureViewProtocol {
    func configureHierachy() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(overviewLabel)
    }
    
    func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(380)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(titleLabel)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
    
    func configureView() {
        self.backgroundColor = .clear
    }
    
    
}
