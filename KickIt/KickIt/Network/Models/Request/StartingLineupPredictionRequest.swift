//
//  StartingLineupPredictionRequest.swift
//  KickIt
//
//  Created by 이윤지 on 9/11/24.
//

import Foundation

/// 선발라인업 예측 조회 Request 모델
struct StartingLineupPredictionRequest: Encodable {
    let matchId: Int64 // 경기 id
}
