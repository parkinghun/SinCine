//
//  UIViewController+Extension.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit
import SnapKit

extension UIViewController {
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let statusBarFrame = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame
            if let statusBarFrame = statusBarFrame {
                let statusBar = UIView(frame: statusBarFrame)
                view.addSubview(statusBar)
                return statusBar
            } else {
                return nil
            }
        } else {
            return UIApplication.shared.value(forKey: "statusBar") as? UIView
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    func showDeleteAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .destructive) { _ in
            completion()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func showToastMessage(status: ToastStatus, message: String) {
        let toastView = ToastMessageView()
        toastView.configure(message: message, status: status)

        self.view.addSubview(toastView)
        
        toastView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
            make.horizontalEdges.equalToSuperview().inset(40)
            make.height.equalTo(44)
        }
        
        UIView.animate(withDuration: 5.0) {
            toastView.alpha = 0.0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
}
