//
//  SignUpRequest.swift
//  KickIt
//
//  Created by DaeunLee on 9/21/24.
//

import Foundation

/// 회원가입 데이터 구조체
struct SignUpRequest: Codable {
    let nickname: String // 사용자 닉네임
    let favoriteTeam: [String] // 선호 팀
    let marketingConsent: Bool // 마케팅 동의 여부
}
