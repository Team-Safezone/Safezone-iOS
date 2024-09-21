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
    
    /// 현재 선택 중인 팀 포메이션
    var selectedFormation: Formation? { get set }
    
    /// 현재 선택 중인 팀 포메이션의 배열 순서
    var formationIndex: Int { get set }
    
    /// 사용자가 선택한 팀 선수 리스트
    var selectedPlayers: [SoccerPosition : StartingLineupPlayer] { get set }
    
    /// 현재 선택 중인 선수 포지션
    var selectedPositionToInt: Int? { get set }
    
    /// 현재 선택 중인 선수 상세 포지션
    var selectedPosition: SoccerPosition? { get set }
    
    /// 선수 선택 시트를 띄우기 위한 변수
    var isPlayerPresented: Bool { get set }
    
    /// 라디오그룹에서 선택한 포지션 아이디
    var selectedRadioBtnID: Int { get set }
    
    /// 라디오그룹에서 선택한 포지션 이름 정보
    var selectedPositionName: String? { get set }
    
    /// 팀의 선수 리스트
    var teamPlayers: [StartingLineupPlayer] { get set }
}
