//
//  MatchEventsResponse.swift
//  KickIt
//
//  Created by DaeunLee on 9/25/24.
//

import Foundation

/// 타임라인 Response 모델
struct MatchEventsData: Codable {
    let eventTime: String // 이벤트 발생 시각
    let eventCode: Int // 0: 경기 시작, 1: 전반, 2: 휴식, 3: 후반, 4: 추가 선언, 5: 추가, 6:경기 종료
    let player2: String? // 정보2(어시스트 선수, 교체 OUT 선수, 어웨이팀 점수)
    let player1: String? // 정보1(골 넣은 선수,경고or 퇴장 선수, 교체 IN 선수, 홈팀 점수)
    let matchId: Int // 경기 고유 id
    let eventName: String // 이벤트 명칭
    let teamName: String? // 이벤트 발생 팀 이름
    let teamUrl: String? // 이벤트 발생 팀 url
}

struct MatchEventsResponse: Codable {
    let message: String
    let data: [MatchEventsData]
    let status: Int
}

