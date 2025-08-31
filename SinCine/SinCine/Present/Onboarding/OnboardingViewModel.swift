//
//  OnboardingViewModel.swift
//  SinCine
//
//  Created by 박성훈 on 8/31/25.
//

import Foundation
import RxSwift
import RxCocoa

final class OnboardingViewModel: ViewModelType {
    struct Input {
        let startButtonTapped: ControlEvent<Void>
    }
    struct Output {
        let pushNicknameSetting: Driver<Void>
    }
    
    let disposeBag = DisposeBag()
    
    init() { }
    
    func transform(input: Input) -> Output {
        let pushNicknameSetting = PublishRelay<Void>()
        
        input.startButtonTapped
            .bind(to: pushNicknameSetting)
            .disposed(by: disposeBag)
        
        return Output(pushNicknameSetting: pushNicknameSetting.asDriver(onErrorJustReturn: ()))
    }
}
