//
//  SoccerTeam.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation

/// 축구 팀 응답 모델
struct SoccerTeamResponseModel: Codable {
    var ranking: Int // 순위
    let teamEmblemURL: String // 팀 엠블럼 이미지
    let teamName: String // 팀 이름
    var soccerSeason: String
    
    enum CodingKeys: String, CodingKey {
        case soccerSeason = "season"
        case teamEmblemURL = "logoUrl"
        case teamName = "team"
        case ranking
    }
}
