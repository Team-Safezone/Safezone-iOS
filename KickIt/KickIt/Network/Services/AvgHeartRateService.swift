//
//  AvgHeartRateService.swift
//  KickIt
//
//  Created by DaeunLee on 10/4/24.
//

import Foundation
import Alamofire

/// [타임라인 화면] 사용자 평균 심박수 Router
enum AvgHeartRateService {
    // 사용자 평균 심박수 API
    case getUserAverageHeartRate
}

extension AvgHeartRateService: TargetType {
    
    var method: HTTPMethod {
        switch self {
        case .getUserAverageHeartRate:
            return .get
        }
    }
    
    var endPoint: String {
        switch self {
        // 타임라인 이벤트 API
        case .getUserAverageHeartRate:
            return APIConstants.avgHeartRateURL
        }
    }
    
    var header: HeaderType {
        switch self {
        case .getUserAverageHeartRate:
            return .basic
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getUserAverageHeartRate:
            return .requestPlain
        }
    }
}
