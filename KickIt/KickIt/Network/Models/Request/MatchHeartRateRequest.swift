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

struct MatchHeartRateRecord: Codable {
    let heartRate: Int // 심박수 수치
    let date: String // "yyyy/MM/dd HH:mm"
}
