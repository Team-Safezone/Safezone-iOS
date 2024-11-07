//
//  PredictionButtonResponse.swift
//  KickIt
//
//  Created by 이윤지 on 10/6/24.
//

import Foundation

/// 경기 예측 버튼 클릭 Response 모델
struct PredictionButtonResponse: Codable {
    var scorePredictions: ButtonMatchPredictionResponse // 우승팀 예측 결과
    var lineupPredictions: ButtonLineupPredictionResponse // 선발라인업 예측 결과
}

/// 우승팀 예측 결과
struct ButtonMatchPredictionResponse: Codable {
    var homePercentage: Int // 홈팀의 예측 우승확률(백분율)
    var isParticipated: Bool // 사용자가 우승팀 예측을 했는지에 대한 여부
    var participant: Int? // 예측에 참여한 사람의 수
    var isPredictionSuccessful: Bool? // 사용자가 예측을 성공했는지에 대한 여부
}

/// 선발라인업 예측 결과
struct ButtonLineupPredictionResponse: Codable {
    var homePercentage: Int? // 홈팀의 1순위 포메이션 예측 비율(백분율)
    var awayPercentage: Int? // 원정팀의 1순위 포메이션 예측 비율(백분율)
    var homeFormation: Int? // 홈팀의 1순위 예상 포메이션
    var awayFormation: Int? // 원정팀의 1순위 예상 포메이션
    var isParticipated: Bool // 사용자가 우승팀 예측을 했는지에 대한 여부
    var participant: Int? // 예측에 참여한 사람의 수
    var isPredictionSuccessful: Bool? // 사용자가 예측을 성공했는지에 대한 여부
}
