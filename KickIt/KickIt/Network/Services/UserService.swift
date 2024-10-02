//
//  UserService.swift
//  KickIt
//
//  Created by DaeunLee on 9/16/24.
//

import Combine
import Alamofire

import Combine
import Alamofire

/// 사용자 관련 API 서비스를 정의하는 열거형
enum UserService {
    /// 회원가입 API
    case signUp(SignUpRequest)
    /// 닉네임 중복 검사 API
    case checkNicknameDuplicate(String)
    /// 프리미어리그 팀 목록 조회 API
    case getTeams
}

extension UserService: TargetType {
    /// HTTP 요청 메서드 정의
    var method: HTTPMethod {
        switch self {
        case .signUp:
            return .post
        case .checkNicknameDuplicate, .getTeams:
            return .get
        }
    }
    
    /// API 엔드포인트 URL 정의
    var endPoint: String {
            switch self {
            case .signUp:
                return APIConstants.signupURL
            case .checkNicknameDuplicate:
                return APIConstants.checkNicknameDuplicateURL
            case .getTeams:
                return APIConstants.getTeamsURL
            }
        }
    
    /// HTTP 헤더 타입 정의
    var header: HeaderType {
        return .basic
    }
    
    /// API 요청 파라미터 정의
    var parameters: RequestParams {
        switch self {
        case .signUp(let signUpData):
            return .requestBody(signUpData)
        case .checkNicknameDuplicate(let nickname):
            return .query(["nickname": nickname])
        case .getTeams:
            return .requestPlain
        }
    }
}
