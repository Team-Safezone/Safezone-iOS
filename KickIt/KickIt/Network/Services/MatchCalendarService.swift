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
    // 한달 경기 일정 조회 API
    case getYearMonthSoccerMatches(yearMonth: String, teamName: String?)
    
    // 하루 경기 일정 조회 API
    case getDaySoccerMatches(date: String, teamName: String?)
}

extension MatchCalendarService: TargetType {
    // 각 API의 endpoint
    var endPoint: String {
        switch self {
        // 한달 경기 일정 조회 API
        case .getYearMonthSoccerMatches(let yearMonth, let teamName):
            var components = URLComponents()
            components.path = APIConstants.monthURL
            components.queryItems = [
                URLQueryItem(name: "yearMonth", value: yearMonth)
            ]
            if let teamName = teamName {
                components.queryItems?.append(URLQueryItem(name: "teamName", value: teamName))
            }
            
            return components.url!.absoluteString
            
        // 하루 경기 일정 조회 API
        case .getDaySoccerMatches(let date, let teamName):
            var components = URLComponents()
            components.path = APIConstants.matchURL
            components.queryItems = [
                URLQueryItem(name: "date", value: date)
            ]
            if let teamName = teamName {
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
        case .getDaySoccerMatches:
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
        case .getDaySoccerMatches:
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
        case .getDaySoccerMatches:
            return .requestPlain
        }
    }
}
