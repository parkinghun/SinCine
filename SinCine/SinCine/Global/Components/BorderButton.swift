//
//  BorderButton.swift
//  SinCine
//
//  Created by 박성훈 on 8/1/25.
//

import UIKit

final class BorderButton: UIButton {
    convenience init(title: String) {
        self.init(type: .custom)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(Colors.mainColor, for: .normal)
        self.titleLabel?.font = .semiBold
        self.tintColor = Colors.mainColor
        self.backgroundColor = Colors.black
        self.layer.cornerRadius = 22
        self.clipsToBounds = true
        self.layer.borderColor = Colors.mainColor.cgColor
        self.layer.borderWidth = 2
    }
}
