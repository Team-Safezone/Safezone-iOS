//
//  ViewerPercentageRequest.swift
//  KickIt
//
//  Created by 이윤지 on 9/3/24.
//

import Foundation

/// 심박수 통계 조회 Request 모델
struct HeartRateStatisticsRequest: Encodable {
    let matchId: Int64 // 경기 id
}
