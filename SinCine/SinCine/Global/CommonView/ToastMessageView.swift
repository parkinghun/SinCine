//
//  Toast.swift
//  SinCine
//
//  Created by 박성훈 on 8/10/25.
//

import UIKit
import SnapKit

enum ToastStatus {
    case check, warning
    
    var icon: UIImage? {
        switch self {
        case .check:
            return UIImage(systemName: "checkmark.circle.fill")
            
        case .warning:
            return UIImage(systemName: "exclamationmark.circle.fill")
        }
    }
}

final class ToastMessageView: UIView {
    let stateImageVIew = UIImageView()
    let toastLabel = {
        let label = UILabel()
        label.textColor = Colors.white
        label.font = .medium
        return label
    }()
    
    lazy var toastStackView = {
        let sv = UIStackView(arrangedSubviews: [stateImageVIew, toastLabel])
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierachy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(message: String, status: ToastStatus) {
        stateImageVIew.image = status.icon
        stateImageVIew.tintColor = status == .check ? .green : .red
        toastLabel.text = message
    }
}

private extension ToastMessageView {
    func setupStyle() {
        self.backgroundColor = Colors.darkGray
        self.layer.cornerRadius = 22
        self.clipsToBounds = true
    }
    
    func setupHierachy() {
        self.addSubview(toastStackView)
    }
    
    func setupLayout() {
        toastStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        stateImageVIew.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
    }
}

