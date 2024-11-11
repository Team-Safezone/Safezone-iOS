//
//  WinningPrediction.swift
//  KickIt
//
//  Created by 이윤지 on 6/10/24.
//

import Foundation

/// [Entity] 축구 경기 우승 팀 및 득점 예측 모델
struct WinningPrediction: Identifiable, Hashable {
    let id: Int64 // 고유 id
    let homeTeamName: String // 홈팀 이름
    let awayTeamName: String // 원정팀 이름
    var homeTeamScore: Int // 홈팀 예상 득점
    var awayTeamScore: Int // 원정팀 예상 득점
    var grade: Int // 등급
    var point: Int // 포인트
}

/// 우승팀 예측 모델 더미 데이터
let dummyWinningPrediction: WinningPrediction = WinningPrediction(id: 0, homeTeamName: "첼시", awayTeamName: "토트넘", homeTeamScore: 1, awayTeamScore: 2, grade: 0, point: 0)
