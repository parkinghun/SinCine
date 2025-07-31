//
//  ViewController.swift
//  SinCine
//
//  Created by 박성훈 on 7/31/25.
//

import UIKit

final class OnboardingViewController: UIViewController {

    let onboardingView = OnboardingView()
    
    override func loadView() {
        self.view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }

    private func configure() {
        onboardingView.closure = {
            print(#function)
            let vc = UIViewController()
            vc.view.backgroundColor = .black

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

