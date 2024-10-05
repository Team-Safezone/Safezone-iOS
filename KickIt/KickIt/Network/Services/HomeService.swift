//
//  HomeService.swift
//  KickIt
//
//  Created by 이윤지 on 9/27/24.
//

import Foundation
import Alamofire

/// 홈 화면의 Router

enum HomeService {
    // 홈 조회 API
    case getHome
}

extension HomeService: TargetType {
    var method: HTTPMethod {
        switch self {
        case .getHome:
            return .get
        }
    }
    
    var endPoint: String {
        switch self {
        case .getHome:
            return APIConstants.homeURL
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getHome:
            return .requestPlain
        }
    }
    
    var header: HeaderType {
        switch self {
        case .getHome:
            return .basic
        }
    }
}
