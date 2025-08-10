//
//  ProfileView.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit
import SnapKit


final class ProfileView: BaseView {
    
    let nicknameLabel = {
        let label = UILabel()
        label.configure(text: "test", font: .semiBold)
        return label
    }()
    
    let dateButton = {
        let bt = UIButton(configuration: .plain())
        
        bt.setConfigureTitle("Test 가입")
        bt.configuration?.image = Images.forward
        bt.configuration?.imagePlacement = .trailing
        bt.configuration?.baseForegroundColor = Colors.darkGray
        bt.configuration?.imagePadding = 8
        bt.isUserInteractionEnabled = false
        return bt
    }()

    let emptyView = UIView()
    
    lazy var profileStackView = {
       let stackView = UIStackView(arrangedSubviews: [nicknameLabel, emptyView, dateButton])
        
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    let movieBox = {
       let bt = UIButton()
        bt.setTitle("1개의 무비박스 보관중", for: .normal)
        bt.setTitleColor(Colors.white, for: .normal)
        bt.titleLabel?.font = .medium
        bt.backgroundColor = Colors.green
        bt.isEnabled = false
        bt.layer.cornerRadius = 12
        bt.clipsToBounds = true
        return bt
    }()
    
    func configureUI(data: User, like: [Int]) {
        nicknameLabel.text = data.nickname
        dateButton.setConfigureTitle("\(data.formattedDate) 가입")
        movieBox.setTitle("\(like.count)개의 무비박스 보관중", for: .normal)
    }
    
    func configureUserInfo(nickname: String, date: String) {
        nicknameLabel.text = nickname
        dateButton.setTitle(date, for: .normal)
    }
    
    func configureLikeLabel(likeTitle: String) {
        movieBox.setTitle(likeTitle, for: .normal)
    }
    
    override func configureHierachy() {
        self.addSubview(profileStackView)
        self.addSubview(movieBox)
    }
    
    override func configureLayout() {
        profileStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(LayoutLiterals.horizontalPadding)
        }
        
        emptyView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        movieBox.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(LayoutLiterals.horizontalPadding)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(LayoutLiterals.horizontalPadding)
        }
    }
    
    override func configureView() {
        backgroundColor = UIColor(hexCode: "2F2F2F")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
        
        profileStackView.addGestureRecognizer(tapGesture)
    }
    
    @objc func stackViewTapped() {
        NotificationCenter.default.post(name: .profileViewTapped, object: nil)
    }
}
