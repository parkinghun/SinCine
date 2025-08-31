//
//  NicknameDetailViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit

final class NicknameDetailViewController: UIViewController, ConfigureViewControllerProtocol {
    
    let nicknameView = NicknameView(isDetaiView: true, isModal: false)
    var nickname = ""
    var isModal = false
    
    
    override func loadView() {
        self.view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupDelegate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let vc = navigationController?.viewControllers.last,
              let settingVC = vc as? NicknameSettingViewController else { return }
        
        settingVC.configureTextField(text: nickname)
        settingVC.valid = isValid(text: nickname).valid
        settingVC.validMessage = isValid(text: nickname).state
        settingVC.navigationItem.rightBarButtonItem?.isEnabled = true
        settingVC.navigationItem.rightBarButtonItem?.tintColor = Colors.mainColor
    }
    
    private func setupNavigationItem() {
        let title = isModal ? StringLiterals.NavigationTitle.editNickname.rawValue:
        StringLiterals.NavigationTitle.nickname.rawValue
        
        setupNavigation(title: title)
    }
    
    func configureTextField(text: String) {
        nicknameView.configureTextField(text: text)
    }
    
    private func setupDelegate() {
        nicknameView.nicknameTextField.delegate = self
    }
}

extension NicknameDetailViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.nickname = text
        
        let state = isValid(text: text).state
        nicknameView.configureStateLabel(state)
    }
    
    func isValid(text: String) -> (valid: Bool, state: String) {
        let specialCharacters = "[@#$%]"
        if text.range(of: specialCharacters, options: .regularExpression) != nil {
            nicknameView.configureStateLabel(StringLiterals.NicknameState.specialCharacters.rawValue)
            return (false, StringLiterals.NicknameState.specialCharacters.rawValue)
        }
        
        let numbers = "[0-9]"
        if text.range(of: numbers, options: .regularExpression) != nil {
            nicknameView.configureStateLabel(StringLiterals.NicknameState.includeNumbers.rawValue)
            return (false, StringLiterals.NicknameState.includeNumbers.rawValue)
        }
        
        guard text.count >= 2, text.count <= 10 else {
            nicknameView.configureStateLabel(StringLiterals.NicknameState.numberOfCharacters.rawValue)
            return (false, StringLiterals.NicknameState.numberOfCharacters.rawValue)
        }
        
        guard UserManager.shared.currentUser.value?.nickname != text else {
            return(false, StringLiterals.NicknameState.sameNickname.rawValue)
        }
        
        nicknameView.configureStateLabel(StringLiterals.NicknameState.ok.rawValue)
        return (true, StringLiterals.NicknameState.ok.rawValue)
    }
}
