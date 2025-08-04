//
//  ConfigureViewControllerProtocol.swift
//  SinCine
//
//  Created by 박성훈 on 8/1/25.
//

import UIKit

protocol ConfigureViewControllerProtocol: AnyObject {
    func setupNavigation(title: String)
}

extension ConfigureViewControllerProtocol where Self: UIViewController {
    
    func setupNavigation(title: String) {
        navigationItem.title = title
        navigationItem.backButtonDisplayMode = .minimal
    }
}
