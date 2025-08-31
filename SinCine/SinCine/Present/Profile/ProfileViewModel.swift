//
//  ProfileViewModel.swift
//  SinCine
//
//  Created by 박성훈 on 8/31/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct ProfileSection {
    var items: [String]
}

extension ProfileSection: SectionModelType {
    init(original: ProfileSection, items: [String]) {
        self = original
        self.items = items
    }
}

final class ProfileViewModel: ViewModelType {
    struct Input {
        let cellSelected: ControlEvent<String>
        let profileTapped: ControlEvent<Void>
    }
    struct Output {
        let list: Driver<[ProfileSection]>
        let presentAlert: Driver<(String, String)>
        let profile: Driver<(User, String)>
        let presentNicknameSetting: Driver<Void>
    }
    
    let disposeBag = DisposeBag()
    let list = ProfileSection(items: ["자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"])
    
    init() { }
    
    func transform(input: Input) -> Output {
        let listDriver = BehaviorRelay(value: [list])
            .asDriver(onErrorJustReturn: [])
        let presentAlert = PublishRelay<(String, String)>()
        let currentUser = UserManager.shared.currentUser
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: User(nickname: ""))
        let likeTitle = LikeManager.shared.likeList
            .map { "\($0.count)개의 무비박스 보관중" }
            .asDriver(onErrorJustReturn: "")
        let profile: Driver<(User, String)> = Driver.combineLatest(currentUser, likeTitle)

        let presentNicknameSetting = PublishRelay<Void>()
        
        input.cellSelected
            .bind(with: self) { owner, value in
                if owner.isLastCell(item: value) {
                    presentAlert.accept(("탈퇴하기", "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴하시겠습니까?"))
                }
            }
            .disposed(by: disposeBag)
        
        input.profileTapped
            .bind(to: presentNicknameSetting)
            .disposed(by: disposeBag)
        
        return Output(list: listDriver,
                      presentAlert: presentAlert.asDriver(onErrorJustReturn: ("", "")),
                      profile: profile,
                      presentNicknameSetting: presentNicknameSetting.asDriver(onErrorJustReturn: ()))
    }
}

private extension ProfileViewModel {
    func isLastCell(item: String) -> Bool {
        return item == list.items.last
    }
}
