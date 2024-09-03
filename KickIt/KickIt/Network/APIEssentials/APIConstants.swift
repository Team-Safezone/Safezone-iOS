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
    static let prodURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
    
    /// 테스트 서버 URL
    static let devURL = Bundle.main.object(forInfoDictionaryKey: "TEST_URL") as! String
    
    /// 한달 경기 일정 조회 URL
    static let monthlyMatchURL = "/fixture/dates"
    
    /// 하루 경기 일정 조회 URL
    static let dailyMatchURL = "/fixture"
}

/// 한글 인코딩
/// url에 한글을 넣기 위함
extension String {
    /// 인코딩
    func encodeURL() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    /// 디코딩
    func decedURL() -> String? {
        return self.removingPercentEncoding
    }
}
