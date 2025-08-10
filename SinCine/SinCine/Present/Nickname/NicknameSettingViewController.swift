//
//  NicknameSettingViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit

protocol NicknameSettingVCDelegate: AnyObject {
    func handleUserUpdate()
}

final class NicknameSettingViewController: UIViewController, ConfigureViewControllerProtocol {
    
    weak var delegate: NicknameViewDelegate?
    weak var settingDelegate: NicknameSettingVCDelegate?
    
    let nicknameView: NicknameView
    let isDetailView: Bool
    let isModal: Bool
    
    
    var valid = false
    var validMessage = StringLiterals.NicknameState.numberOfCharacters.rawValue
    
    init(isDetailView: Bool, isModal: Bool) {
        self.isDetailView = isDetailView
        self.isModal = isModal
        self.nicknameView = .init(isDetaiView: isDetailView, isModal: isModal)
        
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
        
        setupDelegate()
        setupNavigationItem()
        setUserNickname()
    }
    
    func setUserNickname() {
        guard let user = UserManager.shared.currentUser else { return }
        
        nicknameView.nicknameTextField.text = user.nickname
    }
    
    func setupNavigationItem() {
        if isModal {
            navigationItem.title = StringLiterals.NavigationTitle.editNickname.rawValue
            
            let leftBarButtonItem = UIBarButtonItem(image: Images.xmark, style: .plain, target: self, action: #selector(leftBarButtonTapped))
            
            let rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
            
            navigationItem.leftBarButtonItem = leftBarButtonItem
            navigationItem.rightBarButtonItem = rightBarButtonItem
            navigationItem.backButtonDisplayMode = .minimal
            
        } else {
            setupNavigation(title: "닉네임 설정")
        }
    }
    
    @objc private func leftBarButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        if valid {
            guard let nickname = nicknameView.nicknameTextField.text else { return }
            
            showToastMessage(status: .check, message: "닉네임이 설정되었습니다!")
            UserManager.shared.saveUser(User(nickname: nickname))
            settingDelegate?.handleUserUpdate()
            
            dismiss(animated: true)
        } else {
            showToastMessage(status: .warning, message: validMessage)
        }
    }
    
    
    func configureTextField(text: String) {
        nicknameView.configureTextField(text: text)
    }
    
    private func setupDelegate() {
        nicknameView.delegate = self
    }
}

extension NicknameSettingViewController: NicknameViewDelegate {
    
    func handleEditButton() {
        let nextVC = NicknameDetailViewController()
        guard let text = nicknameView.nicknameTextField.text else { return }
        
        nextVC.configureTextField(text: text)
        nextVC.isModal = self.isModal
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func handleCompleteButton() {
        if valid {
            guard let nickname = nicknameView.nicknameTextField.text else { return }
            showToastMessage(status: .check, message: "닉네임이 설정되었습니다!")
            UserManager.shared.saveUser(User(nickname: nickname))
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
            
            sceneDelegate.setRootViewController()
            print(#function)
            print(nickname)
        } else {
            showToastMessage(status: .warning, message: validMessage)
        }
    }
}
