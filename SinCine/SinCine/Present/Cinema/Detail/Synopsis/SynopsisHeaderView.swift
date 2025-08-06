//
//  BackdropFooterView.swift
//  TableViewWithSection
//
//  Created by 박성훈 on 8/6/25.
//

import UIKit
import SnapKit

protocol SynopsisHeaderViewDelegate: AnyObject {
    func handleMoreButtonAction()
}

final class SynopsisHeaderView: UITableViewHeaderFooterView, ConfigureViewProtocol, ReusableViewProtocol {
    
    weak var delegate: SynopsisHeaderViewDelegate?
    
    let synopsisLabel = {
        let label = UILabel()
        label.text = "Synopsis"
        label.textColor = Colors.white
        return label
    }()
    
    let moreButton = {
        let bt = UIButton()
        bt.setTitle("More", for: .normal)
        bt.setTitleColor(.green, for: .normal)
        return bt
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureHierachy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierachy() {
        self.addSubview(synopsisLabel)
        self.addSubview(moreButton)
    }
    
    func configureLayout() {
        synopsisLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }
    }
    
    func configureView() {
        self.backgroundColor = .clear
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func moreButtonTapped() {
        delegate?.handleMoreButtonAction()
        
    }
    
    
}
