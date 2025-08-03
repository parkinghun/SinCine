//
//  StringLiterals.swift
//  SinCine
//
//  Created by 박성훈 on 8/2/25.
//

import Foundation

enum StringLiterals {
    enum Placeholder: String {
        case nickname = "닉네임을 입력해주세요."
        case search = "영화를 검색해보세요."
    }
    
    enum NicknameState: String {
        case ok = "사용할 수 있는 닉네임이에요"
        case numberOfCharacters = "2글자 이상 10글자 미만으로 설정해주세요"
        case specialCharacters = "닉네임에 @, #, $, % 는 포함할 수 없어요"
        case includeNumbers = "닉네임에 숫자는 포함할 수 없어요"
    }

    enum Empty: String {
        case recent = "최근 검색어 내역이 없습니다."
        case search = "원하는 검색결과를 찾지 못했습니다."
    }
}
