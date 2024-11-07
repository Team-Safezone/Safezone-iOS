//
//  MatchEventService.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Foundation
import Alamofire

/// 경기 이벤트 서비스를 위한 Router
enum MatchEventService {
    // 타임라인 이벤트 API
    case getMatchEvents(MatchEventsRequest)
    // 사용자 평균 심박수 API
    case getUserAverageHeartRate
    // 사용자의 심박수 데이터 업로드 API
    case postMatchHeartRate(MatchHeartRateRequest)
    // 데이터 존제 체크 API
    case checkHeartRateDataExists(HeartRateDataExistsRequest)
}

extension MatchEventService: TargetType {
    
    var method: HTTPMethod {
        switch self {
        case .getMatchEvents, .getUserAverageHeartRate, .checkHeartRateDataExists:
            return .get
        case .postMatchHeartRate:
            return .post
        }
    }
    
    var endPoint: String {
        switch self {
        case .getMatchEvents:
            return APIConstants.matchEventURL
        case .postMatchHeartRate:
            return APIConstants.matchHeartRateURL
        case .getUserAverageHeartRate:
            return APIConstants.avgHeartRateURL
        case .checkHeartRateDataExists:
            return APIConstants.checkDataExistsURL
        }
    }
    
    var header: HeaderType {
        switch self {
        case .getMatchEvents, .postMatchHeartRate, .checkHeartRateDataExists, .getUserAverageHeartRate:
            return .basic
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getMatchEvents(let request):
            return .query(["matchId" : request.matchId])
            
        case .postMatchHeartRate(let request):
            return .requestBody(request)
            
        case .getUserAverageHeartRate:
            return .requestPlain
            
        case .checkHeartRateDataExists(let request):
            return .query(["matchId" : request.matchId])
        }
    }
}
