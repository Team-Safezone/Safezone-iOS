//
//  SoccerTeamRequest.swift
//  KickIt
//
//  Created by DaeunLee on 9/21/24.
//

import Foundation

struct SoccerTeamRequest: Codable {
    let teamEmblemURL: String // 팀 url
    let teamName: String // 팀 이름
}

extension SoccerTeamRequest {
    func toEntity() -> SoccerTeam {
        return SoccerTeam(teamEmblemURL: self.teamEmblemURL, teamName: self.teamName)
    }
}
