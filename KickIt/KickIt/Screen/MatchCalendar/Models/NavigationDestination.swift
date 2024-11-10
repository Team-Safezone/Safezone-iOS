//
//  NavigationDestination.swift
//  KickIt
//
//  Created by 이윤지 on 11/8/24.
//

import Foundation

/// [ENUM] 경기 캘린더 화면의 네비게이션 스택 관리용 열거형
//enum NavigationDestination: Hashable {
//    case matchInfo
//    case winningTeamPrediction(data: WinnningTeamPredictionNVData)
//    case finishWinningTeamPrediction(data: FisnishWinningTeamPredictionNVData)
//    case resultWinningTeamPrediction(data: PredictionQuestionModel)
//    //case startingLineupPrediction
//    //case finishStaringLineupPrediction
//    //case resultStartingLineupPrediction
//    
//    func hash(into hasher: inout Hasher) {
//        switch self {
//        case .matchInfo:
//            hasher.combine(0)
//        case .winningTeamPrediction(let data):
//            hasher.combine(1)
//            hasher.combine(data.id)
//        case .finishWinningTeamPrediction(let data):
//            hasher.combine(2)
//            hasher.combine(data.id)
//        case .resultWinningTeamPrediction(let data):
//            hasher.combine(3)
//            hasher.combine(data.id)
//        }
//    }
//    
//    static func == (lhs: NavigationDestination, rhs: NavigationDestination) -> Bool {
//        switch (lhs, rhs) {
//        case (.matchInfo, .matchInfo):
//            return true
//        case (.winningTeamPrediction(let lhsData), .winningTeamPrediction(let rhsData)):
//            return lhsData.id == rhsData.id
//        case (.finishWinningTeamPrediction(let lhsData), .finishWinningTeamPrediction(let rhsData)):
//            return lhsData.id == rhsData.id
//        case (.resultWinningTeamPrediction(let lhsData), .resultWinningTeamPrediction(let rhsData)):
//            return lhsData.id == rhsData.id
//        default:
//            return false
//        }
//    }
//}
//
///// 우승팀 예측 화면 네비게이션 데이터 모델
//struct WinnningTeamPredictionNVData: Identifiable, Hashable {
//    let id = UUID()
//    var match: SoccerMatch
//}
//
///// 우승팀 예측 완료 화면 네비게이션 데이터 모델
//struct FisnishWinningTeamPredictionNVData: Identifiable, Hashable {
//    let id = UUID()
//    let match: SoccerMatch
//    let homeTeamScore: Int
//    let awayTeamScore: Int
//    let grade: Int
//    let point: Int
//}
//
///// 우승팀 예측 결과 화면 네비게이션 데이터 모델
//struct ResultWinningTeamPredictionNVData: Identifiable, Hashable {
//    let id = UUID()
//    let matchId: Int64
//    let matchCode: Int
//    let matchDate: Date
//    let matchTime: Date
//    let homeTeamName: String
//    let awayTeamName: String
//}
