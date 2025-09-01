//
//  NicknameSettingViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit
import RxSwift
import RxCocoa


//protocol NicknameSettingVCDelegate: AnyObject {
//    func handleUserUpdate()
//}

final class NicknameSettingViewController: UIViewController, ConfigureViewControllerProtocol {
    
//    weak var delegate: NicknameViewDelegate?
//    weak var settingDelegate: NicknameSettingVCDelegate?
    
    let nicknameView: NicknameView
    let isDetailView: Bool
    let presentType: NicknamePresentType
    var valid = false
    var validMessage = StringLiterals.NicknameState.numberOfCharacters.rawValue
    private let disposeBag = DisposeBag()
    private let viewModel = NicknameSettingViewModel()
    
    init(isDetailView: Bool, type: NicknamePresentType) {
        self.isDetailView = isDetailView
        self.presentType = type
        self.nicknameView = .init(isDetaiView: isDetailView, type: type)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupDelegate()
        setupNavigationItem()
//        setUserNickname()
        bind()
    }
    
    func bind() {
        let input = NicknameSettingViewModel.Input(
            backButtonTapped: navigationItem.leftBarButtonItem?.rx.tap,
            saveButtonTapped: navigationItem.rightBarButtonItem?.rx.tap,
            editButtonTapped: nicknameView.editButton.rx.tap,
            nickname: nicknameView.nicknameTextField.rx.text.orEmpty,
            completeButtonTapped: nicknameView.completeButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.currentUser
            .drive(with: self) { owner, value in
                owner.nicknameView.nicknameTextField.text = value.nickname
            }
            .disposed(by: disposeBag)
        
        output.nickname
            .drive(with: self) { owner, value in
                let nextVC = NicknameDetailViewController()
                
                nextVC.configureTextField(text: value)
                nextVC.presentType = self.presentType
                owner.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
//    func setUserNickname() {
//        guard let user = UserManager.shared.currentUser.value else { return }
//        
//        nicknameView.nicknameTextField.text = user.nickname
//    }
    
    func setupNavigationItem() {
        switch presentType {
        case .modal:
            navigationItem.title = StringLiterals.NavigationTitle.editNickname.rawValue
            
            let leftBarButtonItem = UIBarButtonItem(image: Images.xmark, style: .plain, target: self, action: #selector(leftBarButtonTapped))
            
            let rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
            rightBarButtonItem.isEnabled = false
            rightBarButtonItem.tintColor = Colors.lightGray
            
            navigationItem.leftBarButtonItem = leftBarButtonItem
            navigationItem.rightBarButtonItem = rightBarButtonItem
            navigationItem.backButtonDisplayMode = .minimal
        case .navigation:
            setupNavigation(title: "닉네임 설정")

        }
    }
    
    @objc private func leftBarButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        if valid {
            guard let nickname = nicknameView.nicknameTextField.text else { return }
            
            UserManager.shared.saveUser(User(nickname: nickname))
//            settingDelegate?.handleUserUpdate()
            dismiss(animated: true)

            guard let sceneDelegate = getSceneDelegate(),
                  let rootVC = sceneDelegate.window?.rootViewController else { return }
            rootVC.showToastMessage(status: .check, message: "닉네임이 설정되었습니다!")
        } else {
            showToastMessage(status: .warning, message: validMessage)
        }
    }
    
    func configureTextField(text: String) {
        nicknameView.configureTextField(text: text)
    }
    
//    private func setupDelegate() {
//        nicknameView.delegate = self
//    }
}

extension NicknameSettingViewController: NicknameViewDelegate {
    
//    func handleEditButton() {
//        let nextVC = NicknameDetailViewController()
//        guard let text = nicknameView.nicknameTextField.text else { return }
//        
//        nextVC.configureTextField(text: text)
//        nextVC.presentType = self.presentType
//        navigationController?.pushViewController(nextVC, animated: true)
//    }
    
    func handleCompleteButton() {
        if valid {
            guard let nickname = nicknameView.nicknameTextField.text else { return }
            
            UserManager.shared.saveUser(User(nickname: nickname))
            
            guard let sceneDelegate = getSceneDelegate() else { return }
            sceneDelegate.setRootViewController()
            
            guard let rootVC = sceneDelegate.window?.rootViewController else { return }
            rootVC.showToastMessage(status: .check, message: "닉네임이 설정되었습니다!")
        } else {
            showToastMessage(status: .warning, message: validMessage)
        }
    }
}
