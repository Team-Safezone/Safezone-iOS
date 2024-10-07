//
//  PredictionLineupInfo.swift
//  KickIt
//
//  Created by 이윤지 on 10/6/24.
//

import Foundation

/// [Entity] 선발라인업 예측 정보 - 경기 예측 버튼 클릭 조회
struct PredictionLineupInfo {
    var homePercentage: Int? // 홈팀의 1순위 포메이션 예측 비율(백분율)
    var awayPercentage: Int? // 원정팀의 1순위 포메이션 예측 비율(백분율)
    var homeFormation: Int? // 홈팀의 1순위 예상 포메이션
    var awayFormation: Int? // 원정팀의 1순위 예상 포메이션
    var isParticipated: Bool // 사용자가 우승팀 예측을 했는지에 대한 여부
    var participant: Int? // 예측에 참여한 사람의 수
    var isPredictionSuccessful: Bool? // 사용자가 예측을 성공했는지에 대한 여부
}
