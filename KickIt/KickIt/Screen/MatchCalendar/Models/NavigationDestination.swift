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
    case lineupPrediction(data: SoccerMatch)
    case finishLineupPrediction(data: FinishLineupPredictionNVData)
    case resultLineupPrediction(prediction: PredictionQuestionModel)
    
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
        case .lineupPrediction:
            return "LineupPrediction"
        case .finishLineupPrediction:
            return "FinishLineupPrediction"
        case .resultLineupPrediction:
            return "ResultLineupPrediction"
        }
    }
}

struct WinningTeamPredictionNVData: Hashable {
    var isRetry: Bool
    var soccerMatch: SoccerMatch
}

struct FinishWinningTeamPredictionNVData: Hashable {
    var winningPrediction: WinningPrediction
    var prediction: PredictionQuestionModel
}

struct FinishLineupPredictionNVData: Hashable {
    var lineupPrediction: LineupPrediction
    var prediction: PredictionQuestionModel
}
