//
//  WinningTeamPredictionService.swift
//  KickIt
//
//  Created by 이윤지 on 11/6/24.
//

import Foundation
import Alamofire

/// 우승팀 예측 화면의 Router
enum WinningTeamPredictionService {
    // 우승팀 예측 API
    case postWinningTeamPrediction(MatchIdRequest, WinningTeamPredictionRequest)
    
    // 우승팀 예측 결과 조회 API
    case getWinningTeamPredictionResult(MatchIdRequest)
}

extension WinningTeamPredictionService: TargetType {
    var method: HTTPMethod {
        switch self {
        case .postWinningTeamPrediction:
            return .post
        case .getWinningTeamPredictionResult:
            return .get
        }
    }
    
    var endPoint: String {
        switch self {
        case .postWinningTeamPrediction:
            return APIConstants.winningTeamPredictionURL
        case .getWinningTeamPredictionResult:
            return APIConstants.winningTeamPredictionResultURL
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .postWinningTeamPrediction(let query, let request):
            return .queryBody(["matchId" : query.matchId], request)
        case .getWinningTeamPredictionResult(let query):
            return .query(["matchId" : query.matchId])
        }
    }
    
    var header: HeaderType {
        return .basic
    }
}
