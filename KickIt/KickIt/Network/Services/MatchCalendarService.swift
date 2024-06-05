//
//  MatchCalendarService.swift
//  KickIt
//
//  Created by 이윤지 on 6/4/24.
//

import Alamofire
import Foundation

/// 경기 캘린더 화면의 Router
/// -> path, method, header, parameter를 라우터에 맞게 request를 만듦

enum MatchCalendarService {
    // 하루 경기 일정 조회 API
    case getDaySoccerMatches(date: String, teamName: String?)
}

extension MatchCalendarService: TargetType {
    // 각 API의 endpoint
    var endPoint: String {
        switch self {
        case .getDaySoccerMatches:
            return APIConstants.matchURL
        }
    }
    
    // 각 API의 HTTP 메서드
    var method: HTTPMethod {
        switch self {
        case .getDaySoccerMatches:
            return .get
        }
    }
    
    // 각 API의 header
    var header: HeaderType {
        switch self {
        case .getDaySoccerMatches(let date, let teamName):
            var headers: [String : String] = ["Date" : date]
            // 팀 이름이 없는 경우 nil을 반환
            if let teamName = teamName {
                headers["TeamName"] = teamName
            }
            return .headers(headers: headers)
        }
    }
    
    // 각 API의 파라미터
    var parameters: RequestParams {
        switch self {
        case .getDaySoccerMatches:
            return .requestPlain
        }
    }
}
