//
//  BaseView.swift
//  SinCine
//
//  Created by 박성훈 on 8/1/25.
//

import UIKit

class BaseView: UIView, ConfigureViewProtocol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierachy()
        configureLayout()
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func configureHierachy() { }
    
    func configureLayout() { }
    
    func configureView() {
        backgroundColor = Colors.black
    }
}
