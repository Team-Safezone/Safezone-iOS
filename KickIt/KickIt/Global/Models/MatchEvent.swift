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
    var eventCode: Int // 0: 예정, 1: 전반, 2: 휴식, 3: 후반, 4: 추가 선언, 5: 추가, 6:종료
    var eventTime: Int // 이벤트 발생 시간
    var eventName: String // 골, 교체, 자책골, 경고, 두 번째 경고, 퇴장, VAR 판독
    var player1: String // 선수명
    var player2: String // 선수명
    var team: SoccerTeam
}


var dummymatchEvents: [MatchEvent] = [
//    MatchEvent(eventCode: 6, eventTime: 0, eventName: "경기종료", player1: "null", player2: "null", team: dummySoccerMatches[0].homeTeam),
//    MatchEvent(eventCode: 5, eventTime: 1, eventName: "골!", player1: "찰로바", player2: "캘러거 도움", team: dummySoccerMatches[0].homeTeam),
//    MatchEvent(eventCode: 4, eventTime: 3, eventName: "추가시간", player1: "null", player2: "null", team: dummySoccerMatches[0].homeTeam),
    MatchEvent(eventCode: 3, eventTime: 58, eventName: "골!", player1: "잭슨", player2: "null", team: dummySoccerMatches[0].homeTeam),
    MatchEvent(eventCode: 3, eventTime: 46, eventName: "교체", player1: "호이비에르", player2: "비수마", team: dummySoccerMatches[0].awayTeam),
    MatchEvent(eventCode: 2, eventTime: 45, eventName: "하프타임", player1: "1", player2: "0", team: dummySoccerMatches[0].homeTeam),
    MatchEvent(eventCode: 5, eventTime: 2, eventName: "경고", player1: "판 더 펜", player2: "null", team: dummySoccerMatches[0].homeTeam),
    MatchEvent(eventCode: 4, eventTime: 3, eventName: "추가시간", player1: "null", player2: "null", team: dummySoccerMatches[0].homeTeam),
    MatchEvent(eventCode: 1, eventTime: 23, eventName: "두 번째 경고", player1: "아쳄퐁", player2: "null", team: dummySoccerMatches[0].homeTeam),
    MatchEvent(eventCode: 1, eventTime: 22, eventName: "퇴장", player1: "로 셀소", player2: "null", team: dummySoccerMatches[0].homeTeam),
    MatchEvent(eventCode: 1, eventTime: 17, eventName: "VAR 판독", player1: "득점 취소", player2: "득점 취소", team: dummySoccerMatches[0].awayTeam),
    MatchEvent(eventCode: 1, eventTime: 5, eventName: "자책골", player1: "잭슨", player2: "null", team: dummySoccerMatches[0].homeTeam),
    MatchEvent(eventCode: 0, eventTime: 0, eventName: "null", player1: "null", player2: "null", team: dummySoccerMatches[0].homeTeam)
]
