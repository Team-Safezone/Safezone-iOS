//
//  SoccerTeamResponse.swift
//  KickIt
//
//  Created by DaeunLee on 9/21/24.
//

import Foundation

struct SoccerTeamResponse: Codable {
    let teamUrl: String //  url
    let teamName: String    // 팀 이름
    
    enum CodingKeys: String, CodingKey {
        case teamUrl
        case teamName
    }
}

extension SoccerTeamResponse {
    func toEntity() -> SoccerTeam {
        return SoccerTeam(teamEmblemURL: self.teamUrl, teamName: self.teamName)
    }
}
