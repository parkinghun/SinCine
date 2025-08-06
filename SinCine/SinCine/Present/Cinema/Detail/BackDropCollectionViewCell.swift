//
//  BackDropCollectionViewCell.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import SnapKit
import Kingfisher

final class BackDropCollectionViewCell: UICollectionViewCell, ReusableViewProtocol {
    
    let backdropImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .red
        return view
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
    
    func configure(with imageURL: URL?) {
        backdropImageView.downSampling(url: imageURL)
    }
    
    
}

extension BackDropCollectionViewCell: ConfigureViewProtocol {
    func configureHierachy() {
        contentView.addSubview(backdropImageView)
        
    }
    
    func configureLayout() {
        backdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureView() {
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.clipsToBounds = true
        
    }
    
}
