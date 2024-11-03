//
//  SoccerDiaryService.swift
//  KickIt
//
//  Created by 이윤지 on 10/23/24.
//

import Foundation
import Alamofire

/// 축구 일기 Router
enum SoccerDiaryService {
    // 추천 축구 일기 조회 API
    case getRecommendDiary
    
    // 내 축구 일기 조회 API
    case getMyDiary
}

extension SoccerDiaryService: TargetType {
    var method: HTTPMethod {
        switch self {
        case .getRecommendDiary:
            return .get
        case .getMyDiary:
            return .get
        }
    }
    
    var endPoint: String {
        switch self {
        case .getRecommendDiary:
            return APIConstants.recommendDiaryURL
        case .getMyDiary:
            return APIConstants.myDiaryURL
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getRecommendDiary:
            return .requestPlain
        case .getMyDiary:
            return .requestPlain
        }
    }
    
    var header: HeaderType {
        switch self {
        case .getRecommendDiary:
            return .basic
        case .getMyDiary:
            return .basic
        }
    }
}
