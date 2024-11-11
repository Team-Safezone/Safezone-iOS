//
//  NavigationDestination.swift
//  KickIt
//
//  Created by 이윤지 on 11/8/24.
//

import Foundation

/// [ENUM] 경기 캘린더 화면의 네비게이션 스택 관리용 열거형
enum NavigationDestination: Hashable {
    case soccerInfo(data: SoccerMatch)
    case winningTeamPrediction(data: WinningTeamPredictionNVData)
    case finishWinningTeamPrediction(data: FinishWinningTeamPredictionNVData)
    case resultWinningTeamPrediction(prediction: PredictionQuestionModel)
        
    // 각 케이스의 이름을 반환하는 계산 속성 추가
    var identifier: String {
        switch self {
        case .soccerInfo:
            return "SoccerInfo"
        case .winningTeamPrediction:
            return "WinningTeamPrediction"
        case .finishWinningTeamPrediction:
            return "FinishWinningTeamPrediction"
        case .resultWinningTeamPrediction:
            return "ResultWinningTeamPrediction"
        }
    }
    
    //case startingLineupPrediction
    //case finishStartingLineupPrediction
    //case resultStartingLineupPrediction
    
    // Hashable 구현
//    func hash(into hasher: inout Hasher) {
//        switch self {
//        case .soccerInfo:
//            break
//            
//        case .winningTeamPrediction(let data):
//            hasher.combine(data)
//            
//        case .finishWinningTeamPrediction(let data):
//            hasher.combine(data)
//            
//        case .resultWinningTeamPrediction(let prediction):
//            hasher.combine(prediction)
//            
//        //case .startingLineupPrediction:
//            //hasher.combine(0)
//            
//        //case .finishStartingLineupPrediction:
//            //hasher.combine(1)
//            
//        //case .resultStartingLineupPrediction:
//            //hasher.combine(2)
//        }
//    }
//    
//    // Equatable 구현 (Hashable이 Equatable을 상속받으므로 필요)
//    static func == (lhs: NavigationDestination, rhs: NavigationDestination) -> Bool {
//        switch (lhs, rhs) {
//        case (.soccerInfo, .soccerInfo):
//            return true
//            
//        case (.winningTeamPrediction(let lhsData), .winningTeamPrediction(let rhsData)):
//            return lhsData == rhsData
//            
//        case (.finishWinningTeamPrediction(let lhsData), .finishWinningTeamPrediction(let rhsData)):
//            return lhsData == rhsData
//        
//        case (.resultWinningTeamPrediction(let lhsData), .resultWinningTeamPrediction(let rhsData)):
//            return lhsData == rhsData
//            
//        //case (.startingLineupPrediction, .startingLineupPrediction): return true
//            
//        //case (.finishStartingLineupPrediction, .finishStartingLineupPrediction): return true
//            
//        //case (.resultStartingLineupPrediction, .resultStartingLineupPrediction): return true
//        default:
//            return false
//        }
//    }
}

//struct SoccerMatchInfoNVData: Hashable {
//    var uuid = UUID()
//    var viewModel: MatchCalendarViewModel
//}

struct WinningTeamPredictionNVData: Hashable {
    var isRetry: Bool
    var soccerMatch: SoccerMatch
}

struct FinishWinningTeamPredictionNVData: Hashable {
    var winningPrediction: WinningPrediction
    var prediction: PredictionQuestionModel
}

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
