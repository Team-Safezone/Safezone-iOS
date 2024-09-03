//
//  MatchCalendarService.swift
//  KickIt
//
//  Created by 이윤지 on 6/4/24.
//

import Foundation
import Alamofire

/// 경기 캘린더 화면의 Router
/// -> path, method, header, parameter를 라우터에 맞게 request를 만듦

enum MatchCalendarService {
    // 한달 경기 일정 조회 API
    case getYearMonthSoccerMatches(SoccerMatchMonthlyRequest)
    
    // 하루 경기 일정 조회 API
    case getDailySoccerMatches(SoccerMatchDailyRequest)
}

extension MatchCalendarService: TargetType {
    // 각 API의 endpoint
    var endPoint: String {
        switch self {
        // 한달 경기 일정 조회 API
        case .getYearMonthSoccerMatches(let request):
            var components = URLComponents()
            components.path = APIConstants.monthlyMatchURL
            components.queryItems = [
                URLQueryItem(name: "yearMonth", value: request.yearMonth)
            ]
            if let teamName = request.teamName {
                components.queryItems?.append(URLQueryItem(name: "teamName", value: teamName))
            }
            
            return components.url!.absoluteString
            
        // 하루 경기 일정 조회 API
        case .getDailySoccerMatches(let request):
            var components = URLComponents()
            components.path = APIConstants.dailyMatchURL
            components.queryItems = [
                URLQueryItem(name: "date", value: request.date)
            ]
            if let teamName = request.teamName {
                components.queryItems?.append(URLQueryItem(name: "teamName", value: teamName))
            }
            
            return components.url!.absoluteString
        }
    }
    
    // 각 API의 HTTP 메서드
    var method: HTTPMethod {
        switch self {
        // 한달 경기 일정 조회
        case .getYearMonthSoccerMatches:
            return .get
            
        // 하루 경기 일정 조회
        case .getDailySoccerMatches:
            return .get
        }
    }
    
    // 각 API의 header
    var header: HeaderType {
        switch self {
        // 한달 경기 일정 조회
        case .getYearMonthSoccerMatches:
            return .basic
        
        // 하루 경기 일정 조회
        case .getDailySoccerMatches:
            return .basic
        }
    }
    
    // 각 API의 파라미터
    var parameters: RequestParams {
        switch self {
        // 한달 경기 일정 조회
        case .getYearMonthSoccerMatches:
            return .requestPlain
        
        // 하루 경기 일정 조회
        case .getDailySoccerMatches:
            return .requestPlain
        }
    }
}
