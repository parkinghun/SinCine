//
//  ProfileViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit

extension ProfileViewController {
    enum Rows: String, CaseIterable {
        case question = "자주 묻는 질문"
        case inquiries = "1:1 문의"
        case notice = "알림 설정"
        case withdrawal = "탈퇴하기"
    }
}

final class ProfileViewController: UIViewController, ConfigureViewControllerProtocol {
    
    private let myProfileView = MyProfileView()
    private let rows = Rows.allCases
    override func loadView() {
        self.view = myProfileView
    }
    
    override func viewDidLoad() {
        configureNotification()
        setupNavigation(title: "설정")
        configureProfile()
        configureTableView()
        configureDelegation()
    }
    
    private func configureTableView() {
        myProfileView.tableView.delegate = self
        myProfileView.tableView.dataSource = self
    }
    
    private func configureProfile() {
        guard let user = UserManager.shared.currentUser else { return }
        myProfileView.profileView.configureUI(data: user, like: LikeManager.shared.likeList)
    }
    
    func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTapGestureAction), name: .profileViewTapped, object: nil)
    }
    
    @objc func handleTapGestureAction() {
        let nicknameSettingVC = NicknameSettingViewController(isDetailView: false, isModal: true)
        
        let nav = BaseNavigationController(rootViewController: nicknameSettingVC)
                
        present(nav, animated: true)
    }
    
    private func configureDelegation() {
        UserManager.shared.delegate = self
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        
        cell.configure(title: rows[indexPath.row].rawValue)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == rows.count - 1 {
            print(#function)
            
            showDeleteAlert(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴하시겠습니까?") {
                UserManager.shared.deleteUSer()
                
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
                
                sceneDelegate.setRootViewController()
            }
        }
    }
}

extension ProfileViewController: UserManagerDelegate {
    func updateUserUI() {
        guard let user = UserManager.shared.currentUser else { return }
        myProfileView.profileView.configureUserInfo(nickname: user.nickname, date: user.formattedDate)
    }
}
