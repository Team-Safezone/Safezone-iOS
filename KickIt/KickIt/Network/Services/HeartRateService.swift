//
//  HeartRateService.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Alamofire
import Foundation

/// 심박수 통계 Router
enum HeartRateService {
    // 홈 팀 시청자 비율 조회 API
    case getViewerPercentage(matchID: Int)
    
    // 팀 별 심박수 데이터 조회 API
    case getTeamHeartRate(teamName: String)
    
    // 사용자의 심박수 데이터 업로드 API
    case postUserHeartRate(teamName: String, min: Double, avg: Double, max: Double)
}

extension HeartRateService: TargetType {
    // method
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getViewerPercentage, .getTeamHeartRate:
            return .get
        case .postUserHeartRate:
            return .post
        }
    }
    
    // endpoint
    var endPoint: String {
        switch self {
        case .getViewerPercentage(let matchID):
            return "/viewerPercentage/\(matchID)"
        case .getTeamHeartRate(let teamName):
            return "/teamHeartRate/\(teamName)"
        case .postUserHeartRate:
            return "/userHeartRate"
        }
    }
    
    // 헤더
    var header: HeaderType {
        switch self {
        case .getViewerPercentage, .getTeamHeartRate:
            return .basic
        case .postUserHeartRate:
            return .auth
        }
    }
    
    // 파라미터
    var parameters: RequestParams {
        switch self {
        case .getViewerPercentage, .getTeamHeartRate:
            return .requestPlain
        case .postUserHeartRate(let teamName, let min, let avg, let max):
            let body: [String: Any] = [
                "teamName": teamName,
                "min": min,
                "avg": avg,
                "max": max
            ]
            return .requestBody(body)
        }
    }
}
