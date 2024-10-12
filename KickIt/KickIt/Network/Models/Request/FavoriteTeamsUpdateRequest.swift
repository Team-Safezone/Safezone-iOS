//
//  FavoriteTeamsUpdateRequest.swift
//  KickIt
//
//  Created by DaeunLee on 10/11/24.
//

import Foundation

// 선호 팀 수정 Request
struct FavoriteTeamsUpdateRequest: Encodable {
    let favoriteTeams: [String]
}
