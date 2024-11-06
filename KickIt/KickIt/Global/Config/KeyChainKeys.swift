//
//  KeyChainKeys.swift
//  KickIt
//
//  Created by 이윤지 on 9/2/24.
//

import Foundation

/// 키체인에서 사용하는 key값
enum KeyChainKeys: String {
    // access token
    case jwtToken = "xAuthToken"
    
    // 카카오
    case kakaoEmail = "kakaoEmail"
    case kakaoNickname = "kakaoNickname"
   
   // 애플
}
