//
//  StartingLineupViewModelProtocol.swift
//  KickIt
//
//  Created by 이윤지 on 9/13/24.
//

import Foundation

/// 선발라인업 선발라인업 예측 화면의 뷰모델 프로토콜
protocol StartingLineupPredictionViewModelProtocol: ObservableObject {
    /// 홈팀 선수 리스트
    var homeTeamPlayers: [StartingLineupPlayer] { get }
    
    /// 원정팀 선수 리스트
    var awayTeamPlayers: [StartingLineupPlayer] { get }
    
    /// 사용자가 예측했던 홈팀 선수 리스트
    var homePredictions: UserStartingLineupPrediction? { get }
    
    /// 사용자가 예측했던 원정팀 선수 리스트
    var awayPredictions: UserStartingLineupPrediction? { get }
    
    /// 선발라인업 예측 조회
    func getStartingLineupPrediction(request: StartingLineupPredictionRequest)
}
