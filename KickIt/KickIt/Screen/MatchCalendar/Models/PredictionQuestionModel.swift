//
//  PredictionQuestionModel.swift
//  KickIt
//
//  Created by 이윤지 on 11/7/24.
//

import Foundation

/// [Entity] 예측 화면, 예측 결과 화면의 상단 질문 박스에 필요한 데이터 모델
struct PredictionQuestionModel: Identifiable, Hashable {
    let id = UUID()
    let matchId: Int64
    let matchCode: Int
    let matchDate: Date
    let matchTime: Date
    let homeTeamName: String
    let awayTeamName: String
}

let dummyPredictionQuestionModel: PredictionQuestionModel = PredictionQuestionModel(matchId: 0, matchCode: 0, matchDate: Date(), matchTime: Date(), homeTeamName: "토트넘", awayTeamName: "아스널")
