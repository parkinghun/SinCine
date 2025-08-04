//
//  SceneDelegate+Extension.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit


extension SceneDelegate {
    func setRootViewController() {
        
        let rootVC: UIViewController
        
        if UserManager.shared.currentUser == nil {
            rootVC = BaseNavigationController(rootViewController: OnboardingViewController())
        } else {
            rootVC = MainTabBarController()
        }
        
        window?.rootViewController = rootVC
    }
}
