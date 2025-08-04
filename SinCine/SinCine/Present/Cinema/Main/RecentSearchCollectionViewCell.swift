//
//  RecentSearchCollectionViewCell.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit
import SnapKit

final class RecentSearchCollectionViewCell: UICollectionViewCell, ReusableViewProtocol {
    
    let keywordLabel = {
        let label = UILabel()
        label.configure(text: "Test", color: Colors.black, font: .medium)
        label.textAlignment = .center
        return label
    }()
    
    let deleteButton = {
        let bt = UIButton()
        bt.setImage(Images.xmark, for: .normal)
        bt.tintColor = Colors.black
        bt.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return bt
    }()
    
    lazy var cellStackView = {
        let sv = UIStackView(arrangedSubviews: [keywordLabel, deleteButton])
        sv.axis = .horizontal
        sv.spacing = 4
        sv.alignment = .fill
        sv.distribution = .fill
        sv.backgroundColor = Colors.white
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierachy()
        configureLayout()
        configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.cellStackView.layer.cornerRadius = self.cellStackView.bounds.height / 2
            self.cellStackView.clipsToBounds = true

        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension RecentSearchCollectionViewCell: ConfigureViewProtocol {
    func configureHierachy() {
        contentView.addSubview(cellStackView)
    }
    
    func configureLayout() {
        cellStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.size.equalTo(20)
        }
        
        keywordLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
        }
    }
    
    func configureView() {
        self.backgroundColor = .clear
    }
    
    
}
