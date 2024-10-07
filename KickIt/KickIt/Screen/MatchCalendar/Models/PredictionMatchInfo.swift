//
//  PredictionMatchInfo.swift
//  KickIt
//
//  Created by 이윤지 on 10/6/24.
//

import Foundation

/// [Entity] 우승팀 예측 정보 - 경기 예측 버튼 클릭 조회
struct PredictionMatchInfo {
    var homePercentage: Int // 홈팀의 예측 우승확률(백분율)
    var isParticipated: Bool // 사용자가 우승팀 예측을 했는지에 대한 여부
    var participant: Int? // 예측에 참여한 사람의 수
    var isPredictionSuccessful: Bool? // 사용자가 예측을 성공했는지에 대한 여부
}
