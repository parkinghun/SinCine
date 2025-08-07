//
//  BackdropFooterView.swift
//  TableViewWithSection
//
//  Created by 박성훈 on 8/6/25.
//

import UIKit
import SnapKit

final class BackdropFooterView: UITableViewHeaderFooterView, ConfigureViewProtocol, ReusableViewProtocol {
    
    let dateView = BackdropDescriptonView(imageType: .calendar, text: "2024-12-24")
    let rateView = BackdropDescriptonView(imageType: .star, text: "8.0")
    let genreView = BackdropDescriptonView(imageType: .film, text: "액션, 스릴러")
    
    // intrinsic content size를 잡을 수 있도록 각각의 뷰의 사이즈를 이정해줘야 한다.
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
