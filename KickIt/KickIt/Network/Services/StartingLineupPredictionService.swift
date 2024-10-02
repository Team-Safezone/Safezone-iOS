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
    // 선발라인업 예측 조회 API
    case getStartingLineupPrediction(StartingLineupPredictionRequest)
}

extension StartingLineupPredictionService: TargetType {
    var method: HTTPMethod {
        switch self {
        // 선발라인업 예측 조회 API
        case .getStartingLineupPrediction:
            return .get
        }
    }
    
    var endPoint: String {
        switch self {
        // 선발라인업 예측 조회 API
        case .getStartingLineupPrediction:
            return APIConstants.startingLineupPredictionURL
        }
    }
    
    var header: HeaderType {
        switch self {
        // 선발라인업 예측 조회 API
        case .getStartingLineupPrediction:
            return .basic
        }
    }
    
    var parameters: RequestParams {
        switch self {
        // 선발라인업 예측 조회 API
        case .getStartingLineupPrediction(let request):
            return .query(["matchId" : request.matchId])
        }
    }
}
