//
//  StartingLineupPredictions.swift
//  KickIt
//
//  Created by 이윤지 on 9/13/24.
//

import Foundation

/// [Entity] 사용자가 예측했던 선발 라인업 리스트
struct UserStartingLineupPrediction {
    var formation: Int? // 포메이션 1~6
    var goalkeeper: SoccerPlayer? // 골기퍼
    var defenders: [SoccerPlayer]? // 수비수
    var midfielders: [SoccerPlayer]? // 미드필더
    var strikers: [SoccerPlayer]? // 공격수
}
