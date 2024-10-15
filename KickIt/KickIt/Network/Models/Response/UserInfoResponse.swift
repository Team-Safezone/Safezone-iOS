//
//  UserInfoResponse.swift
//  KickIt
//
//  Created by DaeunLee on 10/11/24.
//

import Foundation

// 사용자 마이페이지 데이터 Response
struct UserInfoResponse: Codable {
    let nickname: String
    let goalCount: Int
    let favoriteTeamsUrl: [TeamInfo]
}

struct TeamInfo: Codable {
    let teamName: String
    let teamUrl: String
}
