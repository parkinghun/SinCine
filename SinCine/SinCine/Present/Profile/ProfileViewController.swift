//
//  ProfileViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit

final class ProfileViewController: UIViewController, ConfigureViewControllerProtocol {
    
    private let myProfileView = MyProfileView()
    
    private let items = ["자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]

    override func loadView() {
        self.view = myProfileView
    }
    
    override func viewDidLoad() {
        configureNotification()
        setupNavigation(title: "설정")
        configureProfile()
        configureTableView()
    }
    
    private func configureTableView() {
        myProfileView.tableView.delegate = self
        myProfileView.tableView.dataSource = self
    }
    
    private func configureProfile() {
        guard let user = UserManager.shared.currentUser else { return }
        myProfileView.profileView.configureUI(data: user)
    }
    
    func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTapGestureAction), name: .profileViewTapped, object: nil)
    }
    
    @objc func handleTapGestureAction() {
        let nicknameSettingVC = NicknameSettingViewController(isDetailView: false, isModal: true)
        
        let nav = BaseNavigationController(rootViewController: nicknameSettingVC)
                
        present(nav, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyProfileView.identifier, for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            print(#function)
        }
    }
}
