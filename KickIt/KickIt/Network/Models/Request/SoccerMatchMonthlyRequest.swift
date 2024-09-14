//
//  SoccerMatchMonthlyRequest.swift
//  KickIt
//
//  Created by 이윤지 on 9/2/24.
//

import Foundation

/// 한달 경기 일정 조회 Request 모델
struct SoccerMatchMonthlyRequest: Encodable {
    let yearMonth: String // 조회하고 싶은 연도와 월
    let teamName: String? // 프리미어리그 축구 팀 이름
}
