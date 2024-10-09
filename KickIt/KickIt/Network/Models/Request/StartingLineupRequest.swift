//
//  StartingLineupRequest.swift
//  KickIt
//
//  Created by 이윤지 on 10/9/24.
//

import Foundation

/// 선발라인업 조회 Request 모델
struct StartingLineupRequest: Encodable {
    let matchId: Int64 // 경기 id
}
