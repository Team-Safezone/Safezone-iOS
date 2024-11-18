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
    
    /// 카카오 회원가입 URL
    static let kakaoSignUpURL = "/users/signup/kakao"
    
    /// 카카오 로그인 URL
    static let kakaoLoginURL = "/users/login/kakao"
    
    /// 닉네임 중복 검사 조회 URL
    static let checkNicknameDuplicateURL = "/users/check-nickname"
    
    /// 팀 로고, 이름 조회 URL
    static let getTeamsURL = "/eplTeams"
    
    /// 홈 조회 URL
    static let homeURL = "/url~"
    
    /// 한달 경기 일정 조회 URL
    static let monthlyMatchURL = "/fixture/dates"
    
    /// 하루 경기 일정 조회 URL
    static let dailyMatchURL = "/fixture"
    
    /// 랭킹 조회 URL
    static let rankingURL = "/ranking"
    
    /// 경기 예측 버튼 클릭 URL
    static let predictionButtonClickURL = "/match-predict"
    
    /// 선발라인업 조회 URL
    static let startingLineupURL = "/match-lineup"
    
    /// 우승팀 예측 URL
    static let winningTeamPredictionURL = "/score-predict/save"
    
    /// 우승팀 예측 결과 조회 URL
    static let winningTeamPredictionResultURL = "/score-predict/result"
    
    /// 선발라인업 예측 URL
    static let startingLineupPredictionURL = "/lineup-predict/save"
    
    /// 선발라인업 예측 조회 URL
    static let startingLineupPredictionDefaultURL = "/lineup-predict"
    
    /// 선발라인업 예측 결과 조회 URL
    static let startingLineupPredictionResultURL = "/lineup-predict/result"
    
    /// 심박수 통계 조회 URL
    static let heartRateStatisticsURL = "/"
    
    /// 경기 이벤트 조회 URL
    static let matchEventURL = "/realTime"
    
    /// 사용자 평균 심박수 URL
    static let avgHeartRateURL = "/users/avgHeartRate"
    
    /// 사용자 심박수 데이터 존재 여부 URL
    static let checkDataExistsURL = "/check-dataExists"
    
    /// 사용자 심박수 전송 URL
    static let matchHeartRateURL = "/match-heart-rate"
    
    /// 추천 일기 조회 URL
    static let recommendDiaryURL = "/diary/recommend/"
    
    /// 내 일기 조회 URL
    static let myDiaryURL = "/diary/mine/"
    
    /// 일기 신고하기 URL
    static let notifyDiaryURL = "/diary/report/"
    
    /// 일기 좋아요 이벤트 URL
    static let likeDiaryURL = "/diary/isLiked/"
    
    /// 일기 삭제 이벤트 URL
    static let deleteDiaryURL = "/diary/delete/"
    
    /// 축구 일기로 기록하고 싶은 경기 선택을 위한 경기 일정 조회 URL
    static let selectSoccerDiaryMatchURL = "/fixture/diary-select"
    
    /// 축구 일기 작성 때 보여줄 최고 BPM 조회 URL
    static let getSoccerDiaryMaxHeartRateURL = "/diary/max-heartRate/"
    
    /// 축구 일기 작성 URL
    static let createSoccerDiaryURL = "/diary/upload"
    
    /// 사용자 데이터 조회 URL
    static let getUserInfoURL = ""
    /// 닉네임 수정 URL
    static let updateNicknameURL = ""
    /// 선호 팀 수정 URL
    static let updateFavoriteTeamsURL = ""
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
