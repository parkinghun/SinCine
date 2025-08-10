//
//  RecentSearchCollectionViewCell.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit
import SnapKit

protocol RecentSearCellDelegate: AnyObject {
    func handleKeywordTapped(cell: RecentSearchCollectionViewCell)
    func handleDeleteButton(cell: RecentSearchCollectionViewCell)
}

final class RecentSearchCollectionViewCell: UICollectionViewCell, ReusableViewProtocol {
    
    weak var delegate: RecentSearCellDelegate?
    
    let keywordLabel = {
        let label = UILabel()
        label.configure(text: "Test", color: Colors.black, font: .medium)
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let deleteButton = {
        let bt = UIButton()
        bt.setImage(Images.xmark, for: .normal)
        bt.tintColor = Colors.black
        bt.setContentHuggingPriority(.required, for: .horizontal)
        return bt
    }()
    
    lazy var cellStackView = {
        let sv = UIStackView(arrangedSubviews: [keywordLabel, deleteButton])
        sv.axis = .horizontal
        sv.spacing = 4
        sv.alignment = .center
        sv.distribution = .fill

        sv.backgroundColor = Colors.white
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 5, left: 8, bottom: 8, right: 5)
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
    
    func configure(keyword: String) {
        keywordLabel.text = keyword
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
    }
    
    func configureView() {
        self.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelClicked))
        keywordLabel.addGestureRecognizer(tapGesture)
        
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
    }
    
    @objc private func labelClicked() {
        print(#function)
        delegate?.handleKeywordTapped(cell: self)
    }
    
    @objc private func deleteButtonClicked() {
        print(#function)
        delegate?.handleDeleteButton(cell: self)
    }
}
