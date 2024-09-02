//
//  BaseAPI.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Alamofire
import Foundation

/// 모든 API를 구현할 때 상속을 통해서 사용할 기본 클래스
class BaseAPI {
    enum TimeOut {
        static let requestTimeOut: Float = 60 // 네트워크 요청 시 타임아웃 시간(초)
        static let resourceTimeOut: Float = 60 // 리소스 요청 시 타임아웃 시간(초)
    }
    
    // Alomofire로 네트워크 요청을 보낼 때 사용
    let AlamoFireManager: Session = {
        var session = AF
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = TimeInterval(TimeOut.requestTimeOut)
        configuration.timeoutIntervalForResource = TimeInterval(TimeOut.resourceTimeOut)
        
        // 로그 출력
        let eventLogger = APIEventLogger()
        session = Session(configuration: configuration, eventMonitors: [eventLogger])
        return session
    }()
    
    // 서버의 status 값에 따른 결과 반환 함수
    func judgeStatus<T: Codable>(by statusCode: Int, _ data: Data, _ type: T.Type) -> NetworkResult<T> {
        // CommonResponse 타입으로 JSON 데이터 디코딩
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(CommonResponse<T>.self, from: data) else {
            // 디코딩 실패
            return .pathErr
        }
        switch statusCode {
        case 200...201: // 성공
            if (decodedData.data == nil) {
                return .success(decodedData.soccerTeams ?? "None-Data" as! T)
            }
            else {
                return .success(decodedData.data ?? "None-Data" as! T)
            }
        case 202..<300: // 성공
            return .success(decodedData.status as! T)
        case 400..<500: // 실패
            return .requestErr(decodedData.status)
        case 500: // 서버 오류
            return .serverErr
        default: // 네트워크 연결 실패
            return .networkFail
        }
    }
}
