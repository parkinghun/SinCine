//
//  NicknameDetailViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit
import RxSwift
import RxCocoa

final class NicknameDetailViewController: UIViewController, ConfigureViewControllerProtocol {
    
    let nicknameView = NicknameView(isDetaiView: true, type: .navigation)
    var nickname = ""
    var presentType: NicknamePresentType = .navigation
//    var isModal = false
        
    override func loadView() {
        self.view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupNavigationItem()
//        setupDelegate()
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = NicknameDetailViewModel()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 전 VC 알아보는 방법
        // 데이터 전달하기 -
        
//        guard let vc = navigationController?.viewControllers.last,
//              let settingVC = vc as? NicknameSettingViewController else { return }
//        
//        settingVC.configureTextField(text: nickname)
//        settingVC.valid = isValid(text: nickname).valid
//        settingVC.validMessage = isValid(text: nickname).state
//        settingVC.navigationItem.rightBarButtonItem?.isEnabled = true
//        settingVC.navigationItem.rightBarButtonItem?.tintColor = Colors.mainColor
    }
    
    func bind() {
        let input = NicknameDetailViewModel.Input(text: nicknameView.nicknameTextField.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.valid
            .drive(with: self) { owner, value in
                
            }
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationItem() {
        let title: String
        
        switch presentType {
        case .modal:
            title = StringLiterals.NavigationTitle.editNickname.rawValue
        case .navigation:
            title = StringLiterals.NavigationTitle.nickname.rawValue
        }
        
//        let title = isModal ? StringLiterals.NavigationTitle.editNickname.rawValue:
//        StringLiterals.NavigationTitle.nickname.rawValue
        
        setupNavigation(title: title)
    }
    
    func configureTextField(text: String) {
        nicknameView.configureTextField(text: text)
    }
    
//    private func setupDelegate() {
//        nicknameView.nicknameTextField.delegate = self
//    }
}

//extension NicknameDetailViewController: UITextFieldDelegate {
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        guard let text = textField.text else { return }
//        self.nickname = text
//        
//        let state = isValid(text: text).state
//        nicknameView.configureStateLabel(state)
//    }
//    
//    // vm
//    func isValid(text: String) -> (valid: Bool, state: String) {
//        let specialCharacters = "[@#$%]"
//        if text.range(of: specialCharacters, options: .regularExpression) != nil {
//            nicknameView.configureStateLabel(StringLiterals.NicknameState.specialCharacters.rawValue)
//            return (false, StringLiterals.NicknameState.specialCharacters.rawValue)
//        }
//        
//        let numbers = "[0-9]"
//        if text.range(of: numbers, options: .regularExpression) != nil {
//            nicknameView.configureStateLabel(StringLiterals.NicknameState.includeNumbers.rawValue)
//            return (false, StringLiterals.NicknameState.includeNumbers.rawValue)
//        }
//        
//        guard text.count >= 2, text.count <= 10 else {
//            nicknameView.configureStateLabel(StringLiterals.NicknameState.numberOfCharacters.rawValue)
//            return (false, StringLiterals.NicknameState.numberOfCharacters.rawValue)
//        }
//        
//        guard UserManager.shared.currentUser.value?.nickname != text else {
//            return(false, StringLiterals.NicknameState.sameNickname.rawValue)
//        }
//        
//        nicknameView.configureStateLabel(StringLiterals.NicknameState.ok.rawValue)
//        return (true, StringLiterals.NicknameState.ok.rawValue)
//    }
//}
