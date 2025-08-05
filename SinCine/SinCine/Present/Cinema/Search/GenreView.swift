//
//  GenreView.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import SnapKit

final class GenreView: UIView, ConfigureViewProtocol {
    let genreLabel = {
       let label = UILabel()
        label.configure(text: "액션", font: .regular)
        return label
    }()
    
    init(title: String) {
        super.init(frame: .zero)

        genreLabel.text = title
        configureHierachy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierachy() {
        self.addSubview(genreLabel)
    }
    
    func configureLayout() {
        genreLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    func configureView() {
        self.backgroundColor = .darkGray
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
}
