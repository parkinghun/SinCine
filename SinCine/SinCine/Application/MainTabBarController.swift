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
        
        let cinemaVC = CinemaMainViewController(viewModel: CinemaMainViewModel())
        let upcomingVC = UIViewController()
        let profileVC = ProfileViewController()
        
        let cinemaNav = BaseNavigationController(rootViewController: cinemaVC)
        let profileNav = BaseNavigationController(rootViewController: profileVC)
        
        self.setViewControllers([cinemaNav, upcomingVC, profileNav], animated: true)
        self.tabBar.unselectedItemTintColor = Colors.lightGray
        self.tabBar.tintColor = Colors.mainColor
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .black
        self.tabBar.standardAppearance = appearance
        
        guard let items = self.tabBar.items else { return }
        items[0].image = UIImage(systemName: "popcorn")
        items[0].title = "CINEMA"
        
        items[1].image = UIImage(systemName: "film.stack")
        items[1].title = "UPCOMING"

        items[2].image = UIImage(systemName: "person.circle")
        items[2].title = "PROFILE"
    }
}
