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
}
