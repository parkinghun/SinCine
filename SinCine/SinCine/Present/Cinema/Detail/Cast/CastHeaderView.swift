//
//  CastHeaderView.swift
//  TableViewWithSection
//
//  Created by 박성훈 on 8/6/25.
//

import UIKit

final class CastHeaderView: UITableViewHeaderFooterView, ReusableViewProtocol {
    
    let castLabel = {
       let label = UILabel()
        label.text = "Cast"
        return label
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
}

extension CastHeaderView: ConfigureViewProtocol {
    func configureHierachy() {
        self.addSubview(castLabel)
    }
    
    func configureLayout() {
        castLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
    }
    
    func configureView() {
        self.backgroundColor = .clear
    }
}
