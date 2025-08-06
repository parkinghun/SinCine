//
//  UIViewController+Extension.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    func showDeleteAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .destructive)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
