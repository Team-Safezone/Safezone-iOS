//
//  SoccerMatchMonthResponseModel.swift
//  KickIt
//
//  Created by 이윤지 on 6/12/24.
//

import Foundation

/// 한달 경기 일정 조회 Response 모델
struct SoccerMatchMonthResponseModel: Codable {
    let matchDate: String // 축구 경기 날짜
    
    enum CodingKeys: String, CodingKey {
        case matchDate = "date"
    }
}
