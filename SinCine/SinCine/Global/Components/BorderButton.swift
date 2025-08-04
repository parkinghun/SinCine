//
//  BorderButton.swift
//  SinCine
//
//  Created by 박성훈 on 8/1/25.
//

import UIKit

enum ButtonKind {
    case edit
    case complete
}

final class BorderButton: UIButton {
    convenience init(title: String, color: UIColor = Colors.mainColor, font: UIFont? = .semiBold,  width: CGFloat = 2) {
        self.init(type: .custom)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
        self.tintColor = color
        self.backgroundColor = Colors.black
        self.layer.cornerRadius = 22
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}
