//
//  MyPageService.swift
//  KickIt
//
//  Created by DaeunLee on 10/11/24.
//

import Foundation
import Alamofire

// 마이페이지 메뉴
enum MyPageService {
    // 사용자 데이터 GET API
    case getUserInfo
    // 닉네임 수정 POST API
    case updateNickname(NicknameUpdateRequest)
    // 선호 팀 수정 POST API
    case updateFavoriteTeams(FavoriteTeamsUpdateRequest)
    
}

extension MyPageService: TargetType {
    var method: HTTPMethod {
        switch self {
        case .getUserInfo:
            return .get
        case .updateNickname, .updateFavoriteTeams:
            return .post
        }
    }
    
    var endPoint: String {
        switch self {
        case .getUserInfo:
            return APIConstants.getUserInfoURL
        case .updateNickname:
            return APIConstants.updateNicknameURL
        case .updateFavoriteTeams:
            return APIConstants.updateFavoriteTeamsURL
        }
    }
    
    var header: HeaderType {
        switch self {
        case .updateNickname, .updateFavoriteTeams, .getUserInfo:
            return .basic
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .getUserInfo:
            return .requestPlain
        case .updateNickname(let request):
            return .requestBody(request)
        case .updateFavoriteTeams(let request):
            return .requestBody(request)
        }
    }
}
