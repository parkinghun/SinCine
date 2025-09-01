//
//  ProfileViewController.swift
//  SinCine
//
//  Created by 박성훈 on 8/5/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ProfileViewController: UIViewController, ConfigureViewControllerProtocol {
    
    private let myProfileView = MyProfileView()
    private let disposeBag = DisposeBag()
    private let viewModel = ProfileViewModel()
    
    override func loadView() {
        self.view = myProfileView
    }
    
    override func viewDidLoad() {
        setupNavigation(title: "설정")
        bind()
    }
    
    private func bind() {
        let input = ProfileViewModel.Input(
            cellSelected: myProfileView.tableView.rx.modelSelected(String.self),
            profileTapped: myProfileView.profileView.rx.stackViewTap
        )
        let output = viewModel.transform(input: input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<ProfileSection> { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
            
            cell.configure(title: item)
            return cell
        }
        
        output.list
            .drive(myProfileView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.presentAlert
            .drive(with: self) { owner, value in
                let (title, message) = value
                owner.showDeleteAlert(title: title, message: message) {
                    UserManager.shared.deleteUSer()
                    
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
                    
                    sceneDelegate.setRootViewController()
                }
            }
            .disposed(by: disposeBag)
        
        output.profile
            .drive(with: self) { owner, value in
                let (user, title) = value
                owner.myProfileView.profileView.configureUI(data: user, likeTitle: title)

            }
            .disposed(by: disposeBag)
        
        output.presentNicknameSetting
            .drive(with: self) { owner, _ in
//                let nicknameSettingVC = NicknameSettingViewController(isDetailView: false, isModal: true)

                let nicknameSettingVC = NicknameSettingViewController(isDetailView: false, type: .modal)
                let nav = BaseNavigationController(rootViewController: nicknameSettingVC)
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
