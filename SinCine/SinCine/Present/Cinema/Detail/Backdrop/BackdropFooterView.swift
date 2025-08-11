//
//  BackdropFooterView.swift
//  TableViewWithSection
//
//  Created by 박성훈 on 8/6/25.
//

import UIKit
import SnapKit

final class BackdropFooterView: UITableViewHeaderFooterView, ConfigureViewProtocol, ReusableViewProtocol {
    
    let dateView = BackdropDescriptonView(imageType: .calendar, text: "")
    let rateView = BackdropDescriptonView(imageType: .star, text: "")
    let genreView = BackdropDescriptonView(imageType: .film, text: "")
    
    lazy var stackView = {
       let sv = UIStackView(arrangedSubviews: [dateView, makeDivider(), rateView, makeDivider(), genreView])
        sv.axis = .horizontal
        sv.spacing = 8
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
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
    
    func configure(date: String, rate: String, genre: String) {
        dateView.label.text = date
        rateView.label.text = rate
        genreView.label.text = genre
    }
    
    func configureHierachy() {
        self.addSubview(stackView)
    }
    
    func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configureView() {
        self.backgroundColor = .clear
    }
    
    private func makeDivider() -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        return view
    }
    
}
