//
//  WinningTeamPredictionRequest.swift
//  KickIt
//
//  Created by 이윤지 on 11/7/24.
//

import Foundation

/// 우승팀 예측 Request 모델
struct WinningTeamPredictionRequest: Encodable {
    let homeTeamScore: Int
    let awayTeamScore: Int
}
