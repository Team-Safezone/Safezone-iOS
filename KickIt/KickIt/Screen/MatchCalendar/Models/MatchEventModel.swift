//
//  MatchEventModel.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Foundation

struct MatchEvent: Codable, Identifiable {
    let id: UUID
    let matchId: Int
    let eventCode: Int
    let eventTime: String
    let eventName: String
    let player1: String
    let player2: String
    let teamName: String
    let teamUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, matchId, eventCode, eventTime, eventName, player1, player2, teamName, teamUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        matchId = try container.decode(Int.self, forKey: .matchId)
        eventCode = try container.decode(Int.self, forKey: .eventCode)
        eventTime = try container.decode(String.self, forKey: .eventTime)
        eventName = try container.decode(String.self, forKey: .eventName)
        player1 = try container.decode(String.self, forKey: .player1)
        player2 = try container.decode(String.self, forKey: .player2)
        teamName = try container.decode(String.self, forKey: .teamName)
        teamUrl = try container.decode(String.self, forKey: .teamUrl)
    }
    
    init(id: UUID = UUID(), matchId: Int, eventCode: Int, eventTime: String, eventName: String, player1: String, player2: String, teamName: String, teamUrl: String) {
        self.id = id
        self.matchId = matchId
        self.eventCode = eventCode
        self.eventTime = eventTime
        self.eventName = eventName
        self.player1 = player1
        self.player2 = player2
        self.teamName = teamName
        self.teamUrl = teamUrl
    }
}

struct DummyData {
    static let matchEvents: [MatchEvent] = [
        MatchEvent(matchId: 225, eventCode: 0, eventTime: "2024/09/04 21:00:03", eventName: "경기시작", player1: "null", player2: "null", teamName: "null", teamUrl: "null"),
        MatchEvent(matchId: 225, eventCode: 1, eventTime: "2024/09/04 21:15:03", eventName: "골!", player1: "손흥민", player2: "케인", teamName: "토트넘", teamUrl: "https://example.com/tottenham.png"),
        MatchEvent(matchId: 225, eventCode: 2, eventTime: "2024/09/04 21:45:03", eventName: "하프타임", player1: "1", player2: "0", teamName: "null", teamUrl: "null"),
        MatchEvent(matchId: 225, eventCode: 3, eventTime: "2024/09/04 22:00:03", eventName: "교체", player1: "손흥민", player2: "베일", teamName: "토트넘", teamUrl: "https://example.com/tottenham.png"),
        MatchEvent(matchId: 225, eventCode: 4, eventTime: "2024/09/04 22:30:03", eventName: "추가선언", player1: "3", player2: "null", teamName: "null", teamUrl: "null"),
        MatchEvent(matchId: 225, eventCode: 5, eventTime: "2024/09/04 22:31:03", eventName: "골!", player1: "케인", player2: "null", teamName: "토트넘", teamUrl: "https://example.com/tottenham.png"),
        MatchEvent(matchId: 225, eventCode: 6, eventTime: "2024/09/04 22:33:03", eventName: "경기종료", player1: "3", player2: "0", teamName: "null", teamUrl: "null")
    ]
    
    static let heartRateRecords: [HeartRateRecord] = [
            HeartRateRecord(heartRate: 65, date: "2024/09/04 21:05"),
            HeartRateRecord(heartRate: 80, date: "2024/09/04 21:15"),
            HeartRateRecord(heartRate: 85, date: "2024/09/04 21:30")
        ]
}

