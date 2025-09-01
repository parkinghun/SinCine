//
//  NicknameDetailViewModel.swift
//  SinCine
//
//  Created by 박성훈 on 8/31/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameDetailViewModel: ViewModelType {
    struct Input {
        let text: ControlProperty<String>
    }
    
    struct Output {
        let valid: Driver<(Bool, String)>
    }
    
    private let disposeBag = DisposeBag()
    
    init() { }
    
    func transform(input: Input) -> Output {
        // 이걸 전 뷰의 vm으로 전달하기
        let valid = PublishRelay<(Bool, String)>()
        
        input.text
            .bind(with: self) { owner, value in
                let state = owner.validation(text: value)
                valid.accept(state)
            }
            .disposed(by: disposeBag)
        
        
        return Output(valid: valid.asDriver(onErrorJustReturn: (false, "")))
    }
}

private extension NicknameDetailViewModel {
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
