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
    
    // 사용자의 심박수 데이터 업로드 API
    case postUserHeartRate(teamName: String, min: Double, avg: Double, max: Double)
}

extension HeartRateService: TargetType {
    // method
    var method: HTTPMethod {
        switch self {
        // 심박수 통계 조회 API
        case .getHeartRateStatistics:
            return .get
        
        case .postUserHeartRate:
            return .post
        }
    }
    
    // endpoint
    var endPoint: String {
        switch self {
        // 심박수 통계 조회 API
        case .getHeartRateStatistics(let request):
            var components = URLComponents()
            components.path = APIConstants.heartRateStatisticsURL
            components.queryItems = [
                URLQueryItem(name: "matchId", value: String(request.matchId))
            ]
            return components.url!.absoluteString
        
        case .postUserHeartRate:
            return "/userHeartRate"
        }
    }
    
    // 헤더
    var header: HeaderType {
        switch self {
        // 심박수 통계 조회 API
        case .getHeartRateStatistics:
            return .basic
        
        case .postUserHeartRate:
            return .basic
        }
    }
    
    // 파라미터
    var parameters: RequestParams {
        switch self {
        // 심박수 통계 조회 API
        case .getHeartRateStatistics:
            return .requestPlain
        
        case .postUserHeartRate(let teamName, let min, let avg, let max):
            let body: [String: Any] = [
                "teamName": teamName,
                "min": min,
                "avg": avg,
                "max": max
            ]
            return .requestPlain
        }
    }
}
