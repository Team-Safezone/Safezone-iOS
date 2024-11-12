//
//  HeartRateService.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Foundation
import Alamofire

/// 심박수 통계 Router
enum HeartRateService {
    // 심박수 통계 조회 API
    case getHeartRateStatistics(matchId: Int64)
}

extension HeartRateService: TargetType {
    // method
    var method: HTTPMethod {
        switch self {
        case .getHeartRateStatistics:
            return .get
        }
    }
    
    // endpoint
    var endPoint: String {
        switch self {
        case .getHeartRateStatistics(let matchId):
            return "\(APIConstants.heartRateStatisticsURL)/matchId/\(matchId)"
        }
    }
    
    // 헤더
    var header: HeaderType {
        switch self {
        case .getHeartRateStatistics:
            return .basic
        }
    }
    
    // 파라미터
    var parameters: RequestParams {
        switch self {
        case .getHeartRateStatistics:
            return .requestPlain
        }
    }
}
