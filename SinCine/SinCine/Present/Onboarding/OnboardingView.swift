//
//  OnboadingView.swift
//  SinCine
//
//  Created by 박성훈 on 8/1/25.
//

import UIKit
import SnapKit

final class OnboardingView: BaseView {
    
    let logoImageView = {
        let imageView = UIImageView()
        imageView.image = .splash
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let onboardingLabel = {
       let label = UILabel()
        label.text = "Onboarding"
        label.textColor = Colors.white
        label.font = .bold
        return label
    }()
    
    let descriptionLabel = {
        let label = UILabel()
         label.text = "당신만의 영화 세상, \nSinCine를 시작해보세요."
         label.textColor = Colors.white
         label.font = .medium
        label.textAlignment = .center
        label.numberOfLines = 2
         return label
    }()
    
    let startButton = BorderButton(title: "시작하기")
    
    var closure: (() -> Void)?
    
    override func configureHierachy() {
        addSubview(logoImageView)
        addSubview(onboardingLabel)
        addSubview(descriptionLabel)
        addSubview(startButton)
    }
    
    override func configureLayout() {
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
        }
        
        onboardingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(onboardingLabel.snp.bottom).offset(20)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func startButtonTapped() {
        closure?()
    }
}

