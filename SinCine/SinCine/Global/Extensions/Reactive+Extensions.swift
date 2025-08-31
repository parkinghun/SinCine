//
//  Reactive+Extensions.swift
//  SinCine
//
//  Created by 박성훈 on 8/29/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: ProfileView {
    var stackViewTap: ControlEvent<Void> {
        let tapGetsure = UITapGestureRecognizer()
        base.profileStackView.isUserInteractionEnabled = true
        base.profileStackView.addGestureRecognizer(tapGetsure)
        
        let source = tapGetsure.rx.event.map { _ in () }
        return ControlEvent(events: source)
    }
}
