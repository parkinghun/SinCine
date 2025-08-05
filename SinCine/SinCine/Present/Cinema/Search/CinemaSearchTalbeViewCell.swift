//
//  CinemaSearchTalbeViewCell.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import SnapKit

final class CinemaSearchTalbeViewCell: UITableViewCell, ReusableViewProtocol {
    
    let wrapperView = UIView()
    
    let posterImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.configure(text: "어벤져스: 인피니티 워", font: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    let dateLabel = {
        let label = UILabel()
        label.configure(text: "2024. 04. 25", font: .regular)
        return label
    }()
    
    let genreStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    let likeButton = {
        let bt = UIButton()
        bt.setImage(Images.heart, for: .normal)
        bt.tintColor = Colors.mainColor
        bt.setContentCompressionResistancePriority(.required, for: .horizontal)
        return bt
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        genreStackView.removeAllArrangedSubviews()
    }
    
    func configureUI(data: Movie) {
        posterImageView.downSampling(url: data.posterURL)
        titleLabel.text = data.title
        dateLabel.text = data.formattedDate
        
        let genre = data.getGenre.prefix(3)
        
        genre.forEach {
            let genreView = GenreView(title: $0)
            genreStackView.addArrangedSubview(genreView)
        }
    }
}

extension CinemaSearchTalbeViewCell: ConfigureViewProtocol {
    func configureHierachy() {
        contentView.addSubview(wrapperView)
        
        wrapperView.addSubview(posterImageView)
        wrapperView.addSubview(dateLabel)
        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(genreStackView)
        wrapperView.addSubview(likeButton)
    }
    
    func configureLayout() {
        wrapperView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(LayoutLiterals.horizontalPadding)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.width.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(posterImageView.snp.trailing).offset(LayoutLiterals.horizontalPadding)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(posterImageView.snp.trailing).offset(LayoutLiterals.horizontalPadding)
        }
        
        genreStackView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.bottom.equalTo(posterImageView)
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
        }
    }
    
    func configureView() {
        self.backgroundColor = .clear
    }
    
    
}
