//
//  MatchEventsRequest.swift
//  KickIt
//
//  Created by DaeunLee on 9/25/24.
//

import Foundation

/// 타임라인 Request 모델
struct MatchEventsRequest: Encodable {
    let matchId: Int64 // 경기 id
}
