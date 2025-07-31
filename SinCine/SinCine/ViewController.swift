//
//  ViewController.swift
//  SinCine
//
//  Created by 박성훈 on 7/31/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.lightGray
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        label.text = "Test"
        label.font = .semiBold
    }

}

