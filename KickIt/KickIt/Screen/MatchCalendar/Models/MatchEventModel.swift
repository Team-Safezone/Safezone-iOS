//
//  MatchEventModel.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Foundation

// linechartview 더미데이터
struct DummyData {
    static let homeTeamHeartRateRecords: [HeartRateRecord] = [
        HeartRateRecord(heartRate: 82, heartRateRecordTime: 0),
        HeartRateRecord(heartRate: 72, heartRateRecordTime: 15),
        HeartRateRecord(heartRate: 80, heartRateRecordTime: 30),
        HeartRateRecord(heartRate: 82, heartRateRecordTime: 45),
        HeartRateRecord(heartRate: 94, heartRateRecordTime: 60),
        HeartRateRecord(heartRate: 80, heartRateRecordTime: 75),
        HeartRateRecord(heartRate: 88, heartRateRecordTime: 90)
    ]
    
    static let awayTeamHeartRateRecords: [HeartRateRecord] = [
        HeartRateRecord(heartRate: 62, heartRateRecordTime: 0),
        HeartRateRecord(heartRate: 73, heartRateRecordTime: 15),
        HeartRateRecord(heartRate: 65, heartRateRecordTime: 30),
        HeartRateRecord(heartRate: 95, heartRateRecordTime: 45),
        HeartRateRecord(heartRate: 80, heartRateRecordTime: 60),
        HeartRateRecord(heartRate: 87, heartRateRecordTime: 75),
        HeartRateRecord(heartRate: 93, heartRateRecordTime: 90)
    ]
    
    static let heartRateMatchEvents: [HeartRateMatchEvent] = [
        HeartRateMatchEvent(teamURL: "https://example.com/team1.png", eventName: "골!", player1: "손흥민", eventMTime: 7),
        HeartRateMatchEvent(teamURL: "https://example.com/team1.png", eventName: "자책골", player1: "베일", eventMTime: 15),
        HeartRateMatchEvent(teamURL: "https://example.com/team2.png", eventName: "교체", player1: "케인", eventMTime: 30),
        HeartRateMatchEvent(teamURL: "https://example.com/team2.png", eventName: "교체", player1: "손흥민", eventMTime: 45),
        HeartRateMatchEvent(teamURL: "https://example.com/team2.png", eventName: "경고", player1: "베일", eventMTime: 60),
        HeartRateMatchEvent(teamURL: "https://example.com/team2.png", eventName: "골!", player1: "케인", eventMTime: 75)
    ]
}
