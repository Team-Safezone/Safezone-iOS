//
//  WinningTeamPredictionResponse.swift
//  KickIt
//
//  Created by 이윤지 on 11/7/24.
//

import Foundation

/// 우승팀 예측 Response 모델
struct WinningTeamPredictionResponse: Codable {
    let grade: Int
    let point: Int // 1~5
}
