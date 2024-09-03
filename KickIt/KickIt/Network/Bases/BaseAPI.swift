//
//  BaseAPI.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation
import Alamofire

/// 모든 API를 구현할 때 상속을 통해서 사용할 기본 클래스
class BaseAPI {
    enum TimeOut {
        static let requestTimeOut: Float = 60 // 네트워크 요청 시 타임아웃 시간(초)
        static let resourceTimeOut: Float = 60 // 리소스 요청 시 타임아웃 시간(초)
    }
    
    // Alomofire로 네트워크 요청을 보낼 때 사용
    let AFManager: Session = {
        var session = AF
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = TimeInterval(TimeOut.requestTimeOut)
        configuration.timeoutIntervalForResource = TimeInterval(TimeOut.resourceTimeOut)
        
        // 로그 출력
        let eventLogger = APIEventLogger()
        session = Session(configuration: configuration, eventMonitors: [eventLogger])
        return session
    }()
}
