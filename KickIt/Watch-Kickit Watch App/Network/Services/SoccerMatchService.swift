//
//  SoccerMatchService.swift
//  Kickit-Watch Watch App
//
//  Created by DaeunLee on 9/21/24.
//

import Foundation
import Combine

class SoccerMatchService {
    func getDailySoccerMatches(for date: Date) -> AnyPublisher<[SoccerMatch], Error> {
        // 여기에 실제 API 호출 코드를 구현합니다.
        // 예시를 위해 더미 데이터를 반환합니다.
        let dummyMatches = [
            SoccerMatch(id: 1, matchTime: "15:00", homeTeamName: "Team A", awayTeamName: "Team B"),
            SoccerMatch(id: 2, matchTime: "18:00", homeTeamName: "Team C", awayTeamName: "Team D")
        ]
        return Just(dummyMatches)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func recordHeartRate(for matchId: Int64) {
        // 서버에 경기 ID 저장 로직 구현
        print("Recording heart rate for match ID: \(matchId)")
    }
}
