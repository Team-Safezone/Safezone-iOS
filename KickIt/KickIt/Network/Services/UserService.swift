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
    /// 프리미어리그 팀 URL, Name API
    case getTeams
}

extension UserService: TargetType {
    var method: HTTPMethod {
        switch self {
        case .setNickname, .setFavoriteTeams, .setMarketingConsent:
            return .post
        case .checkNicknameDuplicate, .getTeams:
            return .get
        }
    }
    
    /// API 엔드포인트 URL 정의
    var endPoint: String {
        switch self {
        case .setNickname:
            return "/user/nickname"
        case .setFavoriteTeams:
            return "/user/favorite-teams"
        case .setMarketingConsent:
            return "/user/marketing-consent"
        case .checkNicknameDuplicate:
            return "/user/check-nickname"
        case .getTeams:
            return "/eplTeams"
        }
    }
    
    /// HTTP 헤더 타입 정의
    var header: HeaderType {
        return .basic
    }
    
    /// API 요청 파라미터 정의
    var parameters: RequestParams {
        switch self {
        case .setNickname(let nickname):
            return .requestBody(["nickname": nickname])
        case .setFavoriteTeams(let teams):
            return .requestBody(["favoriteTeams": teams])
        case .setMarketingConsent(let consent):
            return .requestBody(["marketingConsent": consent])
        case .checkNicknameDuplicate(let nickname):
            return .query(["nickname": nickname])
        case .getTeams:
            return .requestPlain
        }
    }
}
