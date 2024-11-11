//
//  LineupPrediction.swift
//  KickIt
//
//  Created by 이윤지 on 11/9/24.
//

import Foundation

/// [Entity] 축구 경기 선발라인업 예측 모델
struct LineupPrediction: Identifiable, Hashable {
    let id: Int64 // 고유 id
    var grade: Int // 등급
    var point: Int // 포인트
}

let dummyLineupPrediction: LineupPrediction = LineupPrediction(id: 0, grade: 0, point: 1)
