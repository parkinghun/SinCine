//
//  MainTabBarController.swift
//  SinCine
//
//  Created by 박성훈 on 8/1/25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    convenience init() {
        
        self.init(nibName: nil, bundle: nil)
        
        configure()
    }
    
    func configure() {
        view.backgroundColor = Colors.black
        
        let onboardingVC = OnboardingViewController()
        let upcomingVC = UIViewController()
        let settingVC = SettingViewController()
        
        let cinemaNav = BaseNavigationController(rootViewController: onboardingVC)
        let profileNav = BaseNavigationController(rootViewController: settingVC)
        
        self.setViewControllers([cinemaNav, upcomingVC, profileNav], animated: true)
        self.tabBar.unselectedItemTintColor = Colors.lightGray
        self.tabBar.tintColor = Colors.mainColor
        
        guard let items = self.tabBar.items else { return }
        items[0].image = UIImage(systemName: "popcorn")
        items[0].title = "CINEMA"
        
        items[1].image = UIImage(systemName: "film.stack")
        items[1].title = "UPCOMING"

        items[2].image = UIImage(systemName: "person.circle")
        items[2].title = "PROFILE"
    }
}
