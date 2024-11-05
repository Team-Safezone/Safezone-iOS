//
//  APIConstantsWatch.swift
//  Watch-Kickit Watch App
//
//  Created by DaeunLee on 9/22/24.
//

import Foundation

struct APIConstantsWatch {
    /// 서버 URL
    static let baseURL: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String, !url.isEmpty else {
            fatalError("BASE_URL is missing or invalid in Info.plist")
        }
        return url
    }()
    
    /// 테스트 서버 URL
    static let devURL: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "TEST_URL") as? String, !url.isEmpty else {
            fatalError("TEST_URL is missing or invalid in Info.plist")
        }
        return url
    }()
    
    /// 당일 경기 일정 조회 URL
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
