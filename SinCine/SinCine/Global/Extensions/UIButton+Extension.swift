//
//  UIButton+Extension.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit

extension UIButton {
    func setConfigureTitle(_ text: String, font: UIFont? = .regular) {
        var container = AttributeContainer()
        container.font = font
        self.configuration?.attributedTitle = AttributedString(text, attributes: container)
    }
}
