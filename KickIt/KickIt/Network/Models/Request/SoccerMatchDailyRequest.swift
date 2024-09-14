//
//  SoccerMatchDailyRequest.swift
//  KickIt
//
//  Created by 이윤지 on 9/2/24.
//

import Foundation

/// 하루 경기 일정 조회 Request 모델
struct SoccerMatchDailyRequest: Encodable {
    let date: String // 조회하고 싶은 경기 날짜
    let teamName: String? // 프리미어리그 축구 팀 이름
}
