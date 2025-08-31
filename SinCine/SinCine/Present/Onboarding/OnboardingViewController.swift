//
//  ViewController.swift
//  SinCine
//
//  Created by 박성훈 on 7/31/25.
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingViewController: UIViewController, ConfigureViewControllerProtocol {

    let onboardingView = OnboardingView()
    private let viewModel = OnboardingViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation(title: "")
        bind()
    }
    
    private func bind() {
        let input = OnboardingViewModel.Input(startButtonTapped: onboardingView.startButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.pushNicknameSetting
            .drive(with: self) { owner, _ in
                let vc = NicknameSettingViewController(isDetailView: false, isModal: false)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

