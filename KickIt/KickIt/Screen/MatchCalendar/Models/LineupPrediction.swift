//
//  LineupPrediction.swift
//  KickIt
//
//  Created by 이윤지 on 11/9/24.
//

import Foundation

/// [Entity] 축구 경기 선발라인업 예측 모델
struct LineupPrediction: Identifiable {
    let id: Int64 // 고유 id
    var type: String // 포메이션 타입
    var grade: Int // 등급
    var point: Int // 포인트
}

let dummyLineupPrediction: LineupPrediction = LineupPrediction(id: 0, type: "공격형", grade: 0, point: 1)
