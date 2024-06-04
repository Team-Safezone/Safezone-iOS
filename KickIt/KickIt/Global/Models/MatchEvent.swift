//
//  Event.swift
//  KickIt
//
//  Created by DaeunLee on 5/18/24.
//

import Foundation

// 경기 이벤트
struct MatchEvent: Identifiable{
    var id = UUID().uuidString // 고유 id
    var eventTime: Int // 이벤트 발생 시간
    var eventName: String // 골, 교체, 자책골, 경고, 두 번째 경고, 퇴장, VAR 판독
    var player1: String // 선수명
    var player2: String // 선수명
}


var matchEvents: [MatchEvent] = [
    MatchEvent(eventTime: 72, eventName: "골!", player1: "찰로바", player2: "캘러거 도움"),
    MatchEvent(eventTime: 58, eventName: "골!", player1: "잭슨", player2: "none"),
    MatchEvent(eventTime: 46, eventName: "교체", player1: "호이비에르", player2: "비수마"),
    MatchEvent(eventTime: 35, eventName: "자책골", player1: "잭슨", player2: "none"),
    MatchEvent(eventTime: 32, eventName: "경고", player1: "판 더 펜", player2: "none"),
    MatchEvent(eventTime: 23, eventName: "두 번째 경고", player1: "아쳄퐁", player2: "none"),
    MatchEvent(eventTime: 22, eventName: "퇴장", player1: "로 셀소", player2: "none"),
    MatchEvent(eventTime: 17, eventName: "VAR 판독", player1: "득점 취소", player2: "득점 취소")
]
