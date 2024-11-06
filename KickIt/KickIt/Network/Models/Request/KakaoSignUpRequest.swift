//
//  KakaoSignUpRequest.swift
//  KickIt
//
//  Created by 이윤지 on 11/5/24.
//

import Foundation

/// 카카오 회원가입 Request 모델
struct KakaoSignUpRequest: Encodable {
    let email: String
    let nickname: String
    let favoriteTeams: [String]
    let marketingContent: Bool
}
