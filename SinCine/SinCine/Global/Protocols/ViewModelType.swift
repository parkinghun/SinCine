//
//  ViewModelType.swift
//  SinCine
//
//  Created by 박성훈 on 8/28/25.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
