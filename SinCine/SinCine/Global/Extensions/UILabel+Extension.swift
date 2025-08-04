//
//  UILabel+Extension.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit

extension UILabel {
    func configure(text: String, color: UIColor = Colors.white, font: UIFont?) {
        self.text = text
        self.textColor = color
        self.font = font
    }
}
