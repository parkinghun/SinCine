//
//  TableViewCell.swift
//  TableViewWithSection
//
//  Created by 박성훈 on 8/6/25.
//

import UIKit
import SnapKit

final class BackdropCell: UICollectionViewCell, ReusableViewProtocol {
    let backdropImageVIew = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        return imageView
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
    
    /// BackdropImageView 데이터 적용
    /// - Parameter item: 백드롭 이미지 URL
    func configure(imageURL: URL?) {
        backdropImageVIew.downSampling(url: imageURL)
    }
}

extension BackdropCell: ConfigureViewProtocol {
    func configureHierachy() {
        contentView.addSubview(backdropImageVIew)
    }
    
    func configureLayout() {
        backdropImageVIew.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureView() {
        backgroundColor = .clear
    }
}
