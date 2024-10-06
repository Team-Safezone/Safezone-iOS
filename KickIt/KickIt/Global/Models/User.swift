//
//  User.swift
//  KickIt
//
//  Created by DaeunLee on 7/30/24.
//

import Foundation

/// [Entity] 사용자 모델
struct User {
    let nickname: String
    var favoriteTeams: [String]
    let minHeartRate: Int
    let avgHeartRate: Int
    let maxHeartRate: Int
    var agreeToMarketing: Bool
    
    static var currentUser = User(
        nickname: "이",
        favoriteTeams: ["토트넘", "아스널", "맨시티"],
        minHeartRate: 45,
        avgHeartRate: 80,
        maxHeartRate: 120,
        agreeToMarketing: false
    )
}
