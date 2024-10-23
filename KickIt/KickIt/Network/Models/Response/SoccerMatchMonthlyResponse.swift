//
//  SoccerMatchMonthResponseModel.swift
//  KickIt
//
//  Created by 이윤지 on 6/12/24.
//

import Foundation

/// 한달 경기 일정 조회 Response 모델
struct SoccerMatchMonthlyResponse: Codable {
    let soccerSeason: String // 축구 시즌
    let matchDates: [String] // 축구 경기 날짜
    let soccerTeamNames: [String]? // 팀 이름
    
    enum CodingKeys: String, CodingKey {
        case soccerSeason = "soccerSeason"
        case matchDates = "matchDates"
        case soccerTeamNames = "soccerTeamNames"
    }
}
