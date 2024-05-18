//
//  Event.swift
//  KickIt
//
//  Created by DaeunLee on 5/18/24.
//

import Foundation

// 경기 이벤트
struct PlayEvent: Identifiable{
    var id = UUID().uuidString // 고유 id
    var eventTime: Int // 이벤트 발생 시간
    var eventName: String // 골, 교체, 자책골, 경고, 두 번째 경고, 퇴장, VAR 판독
    var player1: String // 선수명
    var player2: String // 선수명
    var realTime: String // 이벤트 발생 시각
}

func setEventTime(plusMinute: Int) -> String {
    var dateComponents = DateComponents()
    dateComponents.year = 2024
    dateComponents.month = 5
    dateComponents.day = 18
    dateComponents.hour = 16
    dateComponents.minute = 00
    dateComponents.second = 0
    
    // 기본 날짜 생성
    var realTime = Calendar.current.date(from: dateComponents) ?? Date()
    
    // plusMinute를 realTime에 더함
    if let updatedTime = Calendar.current.date(byAdding: .minute, value: plusMinute, to: realTime) {
        realTime = updatedTime
    }
    
    let realTimeString = dateTimeToString(date3: realTime)
    
    return realTimeString
}


var PlayEvents: [PlayEvent] = [
    PlayEvent(eventTime: 70, eventName: "골!", player1: "찰로바", player2: "캘러거 도움", realTime: setEventTime(plusMinute: 41)),
    PlayEvent(eventTime: 67, eventName: "골!", player1: "잭슨", player2: "none", realTime: setEventTime(plusMinute: 33)),
    PlayEvent(eventTime: 50, eventName: "교체", player1: "호이비에르", player2: "비수마", realTime: setEventTime(plusMinute: 30)),
    PlayEvent(eventTime: 39, eventName: "자책골", player1: "잭슨", player2: "none", realTime: setEventTime(plusMinute: 26)),
    PlayEvent(eventTime: 24, eventName: "경고", player1: "판 더 펜", player2: "none", realTime: setEventTime(plusMinute: 20)),
    PlayEvent(eventTime: 20, eventName: "두 번째 경고", player1: "아쳄퐁", player2: "none", realTime: setEventTime(plusMinute: 17)),
    PlayEvent(eventTime: 8, eventName: "퇴장", player1: "로 셀소", player2: "none", realTime: setEventTime(plusMinute: 7)),
    PlayEvent(eventTime: 5, eventName: "VAR 판독", player1: "VAR 판독", player2: "(득점 취소)", realTime: setEventTime(plusMinute: 3))
]
