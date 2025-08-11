//
//  BackdropDescriptonView.swift
//  TableViewWithSection
//
//  Created by 박성훈 on 8/6/25.
//

import UIKit
import SnapKit

final class BackdropDescriptonView: UIView, ConfigureViewProtocol {
    
    let imageView = {
        let view = UIImageView()
        view.tintColor = .lightGray
        return view
    }()
    
    let label = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    convenience init(imageType: ImageType, text: String) {
        self.init(frame: .zero)
        
        imageView.image = UIImage(systemName: imageType.rawValue)
        label.text = text
        
        configureHierachy()
        configureLayout()
        configureView()
    }
    
    func configureHierachy() {
        self.addSubview(imageView)
        self.addSubview(label)
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.size.equalTo(20)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(4)
            make.verticalEdges.trailing.equalToSuperview()
        }
    }
    
    func configureView() {
        self.backgroundColor = .clear
    }
}

extension BackdropDescriptonView {
    enum ImageType: String {
        case calendar = "calendar"
        case star = "star.fill"
        case film = "film"
    }
}
