//
//  TodayMovieCollectionViewCell.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class TodayMovieCollectionViewCell: UICollectionViewCell, ReusableViewProtocol {
    
    let posterImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.configure(text: "", font: .semiBold)
        return label
    }()
    
    let likeButton = {
        let bt = UIButton()
        bt.setImage(Images.heart, for: .normal)
        bt.tintColor = Colors.mainColor
        bt.setContentCompressionResistancePriority(.required, for: .horizontal)
        return bt
    }()
    
    let overviewLabel = {
        let label = UILabel()
        label.configure(text: "", font: .regular)
        label.numberOfLines = 3
        return label
    }()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierachy()
        configureLayout()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(data: Movie) {
        posterImageView.downSampling(url: data.posterURL)
        titleLabel.text = data.title
        overviewLabel.text = data.overview
        
        let image = data.isLike ? Images.heartFill : Images.heart
        likeButton.setImage(image, for: .normal)
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
            make.trailing.equalTo(likeButton.snp.leading).inset(8)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.trailing.equalToSuperview()
            
            make.size.equalTo(titleLabel.snp.height)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    func configureView() {
        self.backgroundColor = .clear
    }
}
