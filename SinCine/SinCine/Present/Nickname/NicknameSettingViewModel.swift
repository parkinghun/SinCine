//
//  NicknameSettingViewModel.swift
//  SinCine
//
//  Created by 박성훈 on 8/31/25.
//

import Foundation
import RxSwift
import RxCocoa

enum NicknamePresentType {
    case modal
    case navigation
}

final class NicknameSettingViewModel: ViewModelType {
    struct Input {
        // 네비게이션 버튼
        let backButtonTapped: ControlEvent<Void>?
        let saveButtonTapped: ControlEvent<Void>?
        
        // view
        let editButtonTapped: ControlEvent<Void>
        let nickname: ControlProperty<String>
        let completeButtonTapped: ControlEvent<Void>
        
        
    }
    struct Output {
        let currentUser: Driver<User>
        let isValid: Driver<Bool>
        let nickname: Driver<String>
    }
    
    let valid = PublishRelay<(Bool, String)>()
    private let disposeBag = DisposeBag()
    
    init() { }
    
    func transform(input: Input) -> Output {
        let user = UserManager.shared.currentUser
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: User(nickname: ""))
        
        let isValid = PublishRelay<Bool>()
        let text = PublishRelay<String>()
        
        // edit bt
        input.editButtonTapped
            .withLatestFrom(input.nickname)
            .bind(to: text)
            .disposed(by: disposeBag)
            
        input.completeButtonTapped
            
        
        return Output(currentUser: user, isValid: isValid.asDriver(onErrorJustReturn: false),
                      nickname: text.asDriver(onErrorJustReturn: ""))
    }
}

private extension NicknameSettingViewModel {
    func validation(text: String) -> (valid: Bool, state: String) {
        let specialCharacters = "[@#$%]"
        if text.range(of: specialCharacters, options: .regularExpression) != nil {
//            nicknameView.configureStateLabel(StringLiterals.NicknameState.specialCharacters.rawValue)
            return (false, StringLiterals.NicknameState.specialCharacters.rawValue)
        }
        
        let numbers = "[0-9]"
        if text.range(of: numbers, options: .regularExpression) != nil {
//            nicknameView.configureStateLabel(StringLiterals.NicknameState.includeNumbers.rawValue)
            return (false, StringLiterals.NicknameState.includeNumbers.rawValue)
        }
        
        guard text.count >= 2, text.count <= 10 else {
//            nicknameView.configureStateLabel(StringLiterals.NicknameState.numberOfCharacters.rawValue)
            return (false, StringLiterals.NicknameState.numberOfCharacters.rawValue)
        }
        
        guard UserManager.shared.currentUser.value?.nickname != text else {
            return(false, StringLiterals.NicknameState.sameNickname.rawValue)
        }
        
//        nicknameView.configureStateLabel(StringLiterals.NicknameState.ok.rawValue)
        return (true, StringLiterals.NicknameState.ok.rawValue)
    }
}
