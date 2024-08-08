//
//  MatchEventModel.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Foundation

struct MatchEvent: Codable, Identifiable {
    let id: UUID
    let eventCode: Int
    let eventTime: Int
    let eventName: String
    let player1: String
    let player2: String
    let teamName: String
    let teamUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventCode
        case eventTime
        case eventName
        case player1
        case player2
        case teamName
        case teamUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        eventCode = try container.decode(Int.self, forKey: .eventCode)
        eventTime = try container.decode(Int.self, forKey: .eventTime)
        eventName = try container.decode(String.self, forKey: .eventName)
        player1 = try container.decode(String.self, forKey: .player1)
        player2 = try container.decode(String.self, forKey: .player2)
        teamName = try container.decode(String.self, forKey: .teamName)
        teamUrl = try container.decode(String.self, forKey: .teamUrl)
    }
    
    init(id: UUID, eventCode: Int, eventTime: Int, eventName: String, player1: String, player2: String, teamName: String, teamUrl: String) {
        self.id = id
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
    /// 0: 경기 시작, 1: 전반, 2: 휴식, 3: 후반, 4: 추가 선언, 5: 추가, 6:경기 종료
    static let matchEvents: [MatchEvent] = [
        MatchEvent(id: UUID(), eventCode: 0, eventTime: 0, eventName: "경기시작", player1: "null", player2: "null", teamName: "null", teamUrl: "null"),
        MatchEvent(id: UUID(), eventCode: 1, eventTime: 10, eventName: "골!", player1: "누가", player2: "누구 도움", teamName: "팀A", teamUrl: "https://example.com/teamA.png"),
        MatchEvent(id: UUID(), eventCode: 4, eventTime: 30, eventName: "추가시간", player1: "4", player2: "null", teamName: "null", teamUrl: "null"),
        MatchEvent(id: UUID(), eventCode: 5, eventTime: 33, eventName: "경고", player1: "누구", player2: "null", teamName: "팀A", teamUrl: "https://example.com/teamA.png"),
        MatchEvent(id: UUID(), eventCode: 2, eventTime: 45, eventName: "하프타임", player1: "2", player2: "3", teamName: "null", teamUrl: "null"),
        MatchEvent(id: UUID(), eventCode: 3, eventTime: 60, eventName: "교체", player1: "손", player2: "흥민", teamName: "팀B", teamUrl: "https://example.com/teamB.png"),
        MatchEvent(id: UUID(), eventCode: 4, eventTime: 90, eventName: "추가시간", player1: "2", player2: "null", teamName: "null", teamUrl: "null"),
        MatchEvent(id: UUID(), eventCode: 6, eventTime: 93, eventName: "경기종료", player1: "null", player2: "null", teamName: "null", teamUrl: "null")
    ]
    
    static let heartRateRecords: [HeartRateRecord] = [
        HeartRateRecord(heartRate: 75, date: "00:05"),
        HeartRateRecord(heartRate: 80, date: "00:15"),
        HeartRateRecord(heartRate: 85, date: "00:30")
    ]
}

