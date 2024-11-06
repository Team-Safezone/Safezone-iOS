//
//  UserSignUpInfo.swift
//  KickIt
//
//  Created by 이윤지 on 11/6/24.
//

import Foundation

/// 사용자 회원가입 정보를 저장하는 구조체
struct UserSignUpInfo {
    var loginType: LoginType = .kakao
    var nickname: String = ""
    var favoriteTeams: [String] = []
    var agreeToMarketing: Bool = false
}
