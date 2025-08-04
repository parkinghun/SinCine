//
//  ViewController.swift
//  SinCine
//
//  Created by 박성훈 on 7/31/25.
//

import UIKit

final class OnboardingViewController: UIViewController, ConfigureViewControllerProtocol {

    let onboardingView = OnboardingView()
    
    override func loadView() {
        self.view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupNavigation(title: "")
    }

    private func configure() {
        onboardingView.closure = { [weak self] in
            guard let self else { return }
            
            print(#function)
            let vc = NicknameSettingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

