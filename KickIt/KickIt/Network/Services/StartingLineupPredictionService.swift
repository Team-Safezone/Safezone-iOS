//
//  StartingLineupPredictionService.swift
//  KickIt
//
//  Created by 이윤지 on 9/11/24.
//

import Foundation
import Alamofire

/// 선발라인업 예측 Router
enum StartingLineupPredictionService {
    // 선발라인업 예측 API
    case postStartingLineupPrediction(MatchIdRequest)
    
    // 선발라인업 예측 조회 API
    case getStartingLineupPredictionResult(MatchIdRequest)
}

extension StartingLineupPredictionService: TargetType {
    var method: HTTPMethod {
        switch self {
        case .postStartingLineupPrediction:
            return .post
        // 선발라인업 예측 조회 API
        case .getStartingLineupPredictionResult:
            return .get
        }
    }
    
    var endPoint: String {
        switch self {
        case .postStartingLineupPrediction:
            return APIConstants.startingLineupPredictionURL
        // 선발라인업 예측 조회 API
        case .getStartingLineupPredictionResult:
            return APIConstants.startingLineupPredictionResultURL
        }
    }
    
    var header: HeaderType {
        return .basic
    }
    
    var parameters: RequestParams {
        switch self {
        case .postStartingLineupPrediction(let query):
            return .query(["matchId" : query.matchId])
        // 선발라인업 예측 조회 API
        case .getStartingLineupPredictionResult(let query):
            return .query(["matchId" : query.matchId])
        }
    }
}
