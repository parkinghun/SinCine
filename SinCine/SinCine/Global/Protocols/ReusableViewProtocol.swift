//
//  ReusableViewProtocol.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import Foundation

protocol ReusableViewProtocol: AnyObject {
    static var identifier: String { get }
}

extension ReusableViewProtocol {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
