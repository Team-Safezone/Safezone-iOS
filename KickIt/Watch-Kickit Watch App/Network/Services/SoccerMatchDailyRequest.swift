//
//  SoccerMatchDailyRequest.swift
//  Watch-Kickit Watch App
//
//  Created by DaeunLee on 11/5/24.
//

import Foundation

/// 하루 경기 일정 조회 Request 모델
struct SoccerMatchDailyRequest: Codable {
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case date
    }
    
    init(date: Date) {
        self.date = date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormatter.string(from: date)
        try container.encode(dateString, forKey: .date)
    }
}
