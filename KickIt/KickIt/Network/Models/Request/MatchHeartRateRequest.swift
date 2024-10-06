//
//  MatchHeartRateRequest.swift
//  KickIt
//
//  Created by DaeunLee on 10/4/24.
//

import Foundation

// [타임라인 화면] 사용자 심박수 전송
struct MatchHeartRateRequest: Codable {
    let matchId: Int64  // 경기 id
    let MatchHeartRateRecords: [MatchHeartRateRecord] // 심박수 정보
}

struct MatchHeartRateRecord: Codable, Hashable {
    let heartRate: Int
    let date: Int  // 경기 시작 후 경과 시간(분)

    func hash(into hasher: inout Hasher) {
        hasher.combine(heartRate)
        hasher.combine(date)
    }

    static func == (lhs: MatchHeartRateRecord, rhs: MatchHeartRateRecord) -> Bool {
        return lhs.heartRate == rhs.heartRate && lhs.date == rhs.date
    }
}
