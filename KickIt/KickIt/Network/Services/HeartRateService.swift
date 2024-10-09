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
    case getHeartRateStatistics(HeartRateStatisticsRequest)
}

extension HeartRateService: TargetType {
    // method
    var method: HTTPMethod {
        switch self {
        // 심박수 통계 조회 API
        case .getHeartRateStatistics:
            return .get

        }
    }
    
    // endpoint
    var endPoint: String {
        switch self {
        // 심박수 통계 조회 API
        case .getHeartRateStatistics:
            return APIConstants.heartRateStatisticsURL
        }
    }
    
    // 헤더
    var header: HeaderType {
        switch self {
        // 심박수 통계 조회 API
        case .getHeartRateStatistics:
            return .basic
        }
    }
    
    // 파라미터
    var parameters: RequestParams {
        switch self {
        // 심박수 통계 조회 API
        case .getHeartRateStatistics(let request):
            return .query(["matchId" : request.matchId])
        }
    }
}
