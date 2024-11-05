//
//  SoccerMatchService.swift
//  Kickit-Watch Watch App
//
//  Created by DaeunLee on 9/21/24.
//

import Foundation
import Combine
import Alamofire

enum SoccerMatchService: TargetType {
    
    /// 특정 날짜의 경기 일정을 가져오는 케이스
    case getDailySoccerMatches(SoccerMatchDailyRequest)
    
    /// API의 기본 URL
    var baseURL: String {
        return APIConstantsWatch.baseURL
    }
    
    /// HTTP 요청 메서드
    var method: HTTPMethod {
        switch self {
        case .getDailySoccerMatches:
            return .get
        }
    }
    
    /// API 엔드포인트 (URL의 경로 부분)
    var endPoint: String {
        switch self {
        case .getDailySoccerMatches:
            return APIConstantsWatch.dailyMatchURL
        }
    }
    
    /// API 요청 파라미터
    var parameters: RequestParams {
            switch self {
            case .getDailySoccerMatches(let request):
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd"
                let dateString = dateFormatter.string(from: request.date)
                return .query([
                    "date": dateString
                ])
            }
        }
    
    /// 요청 헤더 타입 (여기서는 기본 헤더 사용)
    /// 요청 헤더 타입
    var header: HeaderType {
        switch self {
        case .getDailySoccerMatches:
            return .basic
        }
    }
    
    /// 멀티파트 폼 데이터 (여기서는 사용하지 않지만, TargetType 프로토콜 준수를 위해 구현)
    var multipart: MultipartFormData {
        return MultipartFormData()
    }
}
