//
//  NicknameSettingViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit

final class NicknameSettingViewController: UIViewController, ConfigureViewControllerProtocol {
    
    weak var delegate: NicknameViewDelegate?
    let nicknameView = NicknameView(isDetaiView: false)
    let userDefaultsManager = UserDefaultsManager<User>(key: .user)
    
    var valid = false
    var validMessage = StringLiterals.NicknameState.numberOfCharacters.rawValue
    
    override func loadView() {
        self.view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation(title: "닉네임 설정")
        setupDelegate()

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
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func handleCompleteButton() {
        if valid {
            guard let nickname = nicknameView.nicknameTextField.text else { return }
            userDefaultsManager.save(data: User(nickname: nickname))
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
            
            sceneDelegate.setRootViewController()
            print(#function)
            print(nickname)
        } else {
            showAlert(title: "닉네임 설정 불가능", message: validMessage)
        }
    }
}
