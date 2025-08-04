//
//  NicknameDetailViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit

final class NicknameDetailViewController: UIViewController, ConfigureViewControllerProtocol {
    
    let nicknameView = NicknameView(isDetaiView: true)
    var nickname = ""
    
    override func loadView() {
        self.view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation(title: "닉네임 설정")
        setupDelegate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let vc = navigationController?.viewControllers.last,
              let settingVC = vc as? NicknameSettingViewController else { return }
        
        settingVC.configureTextField(text: nickname)
        settingVC.valid = isValid(text: nickname).valid
        settingVC.validMessage = isValid(text: nickname).state
        
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
    
    // 마지막 글자를 기준으로 상태를 나타내고 싶음
    func isValid(text: String) -> (valid: Bool, state: String) {
        // 특수문자 - "[@#$%]"
        let specialCharacters = "[@#$%]"
        if text.range(of: specialCharacters, options: .regularExpression) != nil {
            nicknameView.configureStateLabel(StringLiterals.NicknameState.specialCharacters.rawValue)
            return (false, StringLiterals.NicknameState.specialCharacters.rawValue)
        }
        
        // 숫자 포함여부
        let numbers = "[0-9]"
        if text.range(of: numbers, options: .regularExpression) != nil {
            nicknameView.configureStateLabel(StringLiterals.NicknameState.includeNumbers.rawValue)
            return (false, StringLiterals.NicknameState.includeNumbers.rawValue)
        }
        
        guard text.count >= 2, text.count <= 10 else {
            nicknameView.configureStateLabel(StringLiterals.NicknameState.numberOfCharacters.rawValue)
            return (false, StringLiterals.NicknameState.numberOfCharacters.rawValue)
        }
        
        nicknameView.configureStateLabel(StringLiterals.NicknameState.ok.rawValue)
        return (true, StringLiterals.NicknameState.ok.rawValue)
    }
}
