//
//  CinameSearchViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit

final class CinemaSearchViewController: UIViewController, ConfigureViewControllerProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation(title: StringLiterals.NavigationTitle.search.rawValue)
    }
}
