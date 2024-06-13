//
//  HomeService.swift
//  KickIt
//
//  Created by 이윤지 on 6/14/24.
//

import Alamofire
import Foundation

/// 홈 화면의 Router
enum HomeService {
    // 프리미어리그 팀 조회 API
    case getSoccerTeams(soccerSeason: String)
}

extension HomeService: TargetType {
    // method
    var method: Alamofire.HTTPMethod {
        // 프리미어리그 팀 조회
        switch self {
        case .getSoccerTeams:
            return .get
        }
    }
    
    // endpoint
    var endPoint: String {
        switch self {
        // 프리미어리그 팀 조회
        case .getSoccerTeams(let soccerSeason):
            var components = URLComponents()
            components.path = APIConstants.teamURL
            components.queryItems = [
                URLQueryItem(name: "soccerSeason", value: soccerSeason)
            ]
            
            return components.url!.absoluteString
        }
    }
    
    // 헤더
    var header: HeaderType {
        switch self {
            // 프리미어리그 팀 조회
        case .getSoccerTeams:
            return .basic
        }
    }
    
    // 파라미터
    var parameters: RequestParams {
        switch self {
            // 프리미어리그 팀 조회
        case .getSoccerTeams:
            return .requestPlain
        }
    }
}
