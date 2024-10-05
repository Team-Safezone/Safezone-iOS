//
//  SoccerMatchService.swift
//  Kickit-Watch Watch App
//
//  Created by DaeunLee on 9/21/24.
//

import Foundation
import Combine
import Alamofire

// MARK: - API 요청을 위한 라우터 열거형
enum SoccerMatchRouter: TargetType {
    
    /// 특정 날짜의 경기 일정을 가져오는 케이스
    case fetchMatches(date: Date)
    
    /// API의 기본 URL
    var baseURL: String {
        return APIConstantsWatch.baseURL
    }
    
    /// HTTP 요청 메서드
    var method: HTTPMethod {
        switch self {
        case .fetchMatches:
            return .get
        }
    }
    
    /// API 엔드포인트 (URL의 경로 부분)
    var endPoint: String {
        switch self {
        case .fetchMatches:
            return APIConstantsWatch.dailyMatchURL
        }
    }
    
    /// API 요청 파라미터
    var parameters: RequestParams {
        switch self {
        case .fetchMatches(let date):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let dateString = dateFormatter.string(from: date)
            return .query(["date": dateString])
        }
    }
    
    /// 요청 헤더 타입 (여기서는 기본 헤더 사용)
    /// 요청 헤더 타입
    var header: HeaderType {
        switch self {
        case .fetchMatches:
            return .basic
        }
    }
    
    /// 멀티파트 폼 데이터 (여기서는 사용하지 않지만, TargetType 프로토콜 준수를 위해 구현)
    var multipart: MultipartFormData {
        return MultipartFormData()
    }
}



// MARK: - 축구 경기 정보를 가져오는 서비스 클래스
class SoccerMatchService {
    /// 싱글톤 인스턴스
    static let shared = SoccerMatchService()
    /// Alamofire 세션 객체
    private var session: Session!
    
    private init() {
        let configuration = URLSessionConfiguration.default
        
        // 로그 출력을 위한 EventMonitor 객체 추가
        let eventLogger = APIEventLogger()
        
        // session 생성 시 eventMonitors 배열에 eventLogger를 추가하여 로그 출력 설정
        session = Session(configuration: configuration, eventMonitors: [eventLogger])
    }
    
    /// 특정 날짜의 축구 경기 정보를 가져오는 메서드
    /// - Parameter date: 경기 일정을 조회할 날짜
    /// - Returns: 축구 경기 정보 배열을 포함하는 AnyPublisher
    func fetchMatches(for date: Date) -> AnyPublisher<[SoccerMatchWatch], Error> {
        // 라우터 인스턴스 생성
        let router = SoccerMatchRouter.fetchMatches(date: date)
        return performRequest(router)
    }
    
    // Alamofire를 사용하여 API 요청 수행
    private func performRequest(_ router: SoccerMatchRouter) -> AnyPublisher<[SoccerMatchWatch], Error> {
        return session.request(router)  // AF.request가 아닌 session.request 사용
            .validate()
            .publishDecodable(type: SoccerMatchResponse.self)
            .value()
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
