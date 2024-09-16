//
//  UserService.swift
//  KickIt
//
//  Created by DaeunLee on 9/16/24.
//

import Combine
import Alamofire

/// 사용자 관련 API 서비스를 정의하는 열거형
enum UserService {
    /// 사용자 닉네임 설정 API
    case setNickname(String)
    /// 사용자 선호 팀 설정 API
    case setFavoriteTeams([String])
    /// 마케팅 동의 설정 API
    case setMarketingConsent(Bool)
    /// 닉네임 중복 검사 API
    case checkNicknameDuplicate(String)
}

extension UserService: TargetType {
    /// HTTP 메소드 정의
    var method: HTTPMethod {
        switch self {
        case .setNickname, .setFavoriteTeams, .setMarketingConsent:
            return .post // POST 메소드 사용
        case .checkNicknameDuplicate:
            return .get // GET 메소드 사용
        }
    }
    
    /// API 엔드포인트 URL 정의
    var endPoint: String {
        switch self {
        case .setNickname:
            return "/user/nickname" // 닉네임 설정 엔드포인트
        case .setFavoriteTeams:
            return "/user/favorite-teams" // 선호 팀 설정 엔드포인트
        case .setMarketingConsent:
            return "/user/marketing-consent" // 마케팅 동의 설정 엔드포인트
        case .checkNicknameDuplicate:
            return "/user/check-nickname" // 닉네임 중복 검사 엔드포인트
        }
    }
    
    /// HTTP 헤더 타입 정의
    var header: HeaderType {
        return .basic // 모든 요청에 대해 기본 헤더 사용
    }
    
    /// API 요청 파라미터 정의
    var parameters: RequestParams {
        switch self {
        case .setNickname(let nickname):
            return .requestBody(["nickname": nickname]) // 닉네임을 요청 바디에 포함
        case .setFavoriteTeams(let teams):
            return .requestBody(["favoriteTeams": teams]) // 선호 팀 목록을 요청 바디에 포함
        case .setMarketingConsent(let consent):
            return .requestBody(["marketingConsent": consent]) // 마케팅 동의 여부를 요청 바디에 포함
        case .checkNicknameDuplicate(let nickname):
            return .query(["nickname": nickname]) // 닉네임을 쿼리 파라미터로 포함
        }
    }
}
