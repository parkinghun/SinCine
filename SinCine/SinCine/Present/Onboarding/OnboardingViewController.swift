//
//  ViewController.swift
//  SinCine
//
//  Created by 박성훈 on 7/31/25.
//

import UIKit

final class OnboardingViewController: UIViewController {

    let onboardingView = OnboardingView()
    let networkManager = NetworkManager.shared
    
    override func loadView() {
        self.view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }

    private func configure() {
        onboardingView.closure = { [weak self] in
            guard let self else { return }
            
            networkManager.fetchData<GenreResult>(endPoint: .init(apiType: .genre), data: GenreResult)
            
            print(#function)
            let vc = UIViewController()
            vc.view.backgroundColor = .black

            print(Bundle().apiKey)
            
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

