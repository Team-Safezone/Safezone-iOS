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
    
    /// 홈 조회 URL
    static let homeURL = "/url~"
    
    /// 한달 경기 일정 조회 URL
    static let monthlyMatchURL = "/fixture/dates"
    
    /// 하루 경기 일정 조회 URL
    static let dailyMatchURL = "/fixture"
    
    /// 경기 예측 버튼 클릭 URL
    static let predictionButtonClickURL = "/"
    
    /// 선발라인업 조회 URL
    static let startingLineupPredictionURL = "/"
    
    /// 심박수 통계 조회 URL
    static let heartRateStatisticsURL = "/"
    
    /// 경기 이벤트 조회 URL
    static let matchEventURL = "/realTime"
    
    /// 사용자 평균 심박수 URL
    static let avgHeartRateURL = "/avgHeartRate"
    
    /// 사용자 심박수 데이터 존재 여부 URL
    static let checkDataExistsURL = "/check-dataExists"
    
    /// 사용자 심박수 전송 URL
    static let matchHeartRateURL = "/match-heart-rate"
    
    /// 회원 가입 정보 전송 URL
    static let signupURL = "/users/signup"
    
    /// 닉네임 중복 검사 조회 URL
    static let checkNicknameDuplicateURL = "/users/check-nickname"
    
    /// 팀 로고, 이름 조회 URL
    static let getTeamsURL = "/eplTeams"
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
