//
//  APIConstants.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation

/// API 주소를 모아두는 파일
struct APIConstants {
    /// 서버 URL
    static let baseURL = devURL
    
    /// 실서버 URL
    static let prodURL = loadSecrets()?.baseURL
    
    /// 테스트 서버 URL
    static let devURL = "http://localhost:8080/"
    
    /// 하루 경기 일정 조회 URL
    static let matchURL = "fixture/{date}/{teamName}"
}
