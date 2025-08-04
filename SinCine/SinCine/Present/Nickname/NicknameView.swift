//
//  NicknameView.swift
//  SinCine
//
//  Created by 박성훈 on 8/2/25.
//

import UIKit
import SnapKit

protocol NicknameViewDelegate: AnyObject {
    func handleEditButton()
    func handleCompleteButton()
}

final class NicknameView: BaseView {
    
    weak var delegate: NicknameViewDelegate?
    var isDetailView: Bool?
    var isModal: Bool?
    
    // TextField
    let nicknameTextField = {
        let tf = UITextField()
        tf.textColor = Colors.white
        tf.placeholder = StringLiterals.Placeholder.nickname.rawValue
        tf.becomeFirstResponder()
        return tf
    }()
    // editButton - BorderButton
    let editButton = BorderButton(title: "편집", color: .white, font: .regular, width: 1)
    
    // StackView
    lazy var textFieldStackView = {
        let sv = UIStackView(arrangedSubviews: [nicknameTextField, editButton])
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    // underlineView
    let textFieldBorderView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // 완료 버튼
    let completeButton = BorderButton(title: "완료")
    
    // stateLabel
    let stateLabel = {
        let label = UILabel()
        label.textColor = Colors.mainColor
        return label
    }()
    
    lazy var bottomStackView = {
        let sv = UIStackView(arrangedSubviews: [completeButton, stateLabel])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    
    init(isDetaiView: Bool, isModal: Bool) {
        self.isDetailView = isDetaiView
        self.isModal = isModal
        
        super.init(frame: .zero)
        configureHierachy()
        configureLayout()
        configureView()
        setupAction()
        
        configureUI()
    }
    
    
    func configureTextField(text: String) {
        nicknameTextField.text = text
    }
    
    func configureStateLabel(_ state: String) {
        stateLabel.text = state
    }
    
    private func setupAction() {
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    @objc func editButtonTapped() {
        delegate?.handleEditButton()
    }
    
    @objc func completeButtonTapped() {
        delegate?.handleCompleteButton()
    }
    
    override func configureHierachy() {
        addSubview(textFieldStackView)
        addSubview(textFieldBorderView)
        addSubview(bottomStackView)
    }
    
    override func configureLayout() {
        textFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(LayoutLiterals.horizontalPadding)
            make.height.equalTo(LayoutLiterals.buttonHeight)
        }
        
        editButton.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        
        textFieldBorderView.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom)
            make.leading.equalTo(textFieldStackView)
            make.trailing.equalTo(textFieldStackView).inset(22)
            make.height.equalTo(1)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(textFieldBorderView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(textFieldStackView)
            make.height.equalTo(LayoutLiterals.buttonHeight)
        }
    }
    
    override func configureView() {
        
    }
    
    private func configureUI() {
        guard let isDetailView,
              let isModal else { return }
        
        if isDetailView {
            editButton.isHidden = true
            completeButton.isHidden = true
        } else {
            nicknameTextField.isUserInteractionEnabled = false
            stateLabel.isHidden = true
        }
        
        bottomStackView.isHidden = isModal
    }
    
}
