//
//  SynopsisCell.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import SnapKit

final class SynopsisCell: UITableViewCell, ReusableViewProtocol {
    
    private var isExpanded = false
    
    private let synopsisLabel = {
        let label = UILabel()
        label.configure(text: "Synopsis", font: .semiBold)
        return label
    }()
    
    private let moreButton = {
        let bt = UIButton()
        bt.setTitle("More", for: .normal)
        bt.setTitleColor(Colors.mainColor, for: .normal)
        bt.titleLabel?.font = .medium
        return bt
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.configure(text: "", font: .regular)
        label.numberOfLines = 3
        return label
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
    
    func setupUI() {
        
    }
}

extension SynopsisCell: ConfigureViewProtocol {
    func configureHierachy() {
        self.addSubview(synopsisLabel)
        self.addSubview(moreButton)
        self.addSubview(descriptionLabel)
    }
    
    func configureLayout() {
        synopsisLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(12)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(synopsisLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
    }
    
    func configureView() {
        self.backgroundColor = .black
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
    
    @objc func moreButtonTapped() {
        print(#function)
        isExpanded.toggle()
        descriptionLabel.numberOfLines = isExpanded ? 0 : 3
        moreButton.setTitle(isExpanded ? "Hide" : "More", for: .normal)
    }
    
    
}
