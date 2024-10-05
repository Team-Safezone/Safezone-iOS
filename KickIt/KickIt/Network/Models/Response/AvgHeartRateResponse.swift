//
//  AvgHeartRateResponse.swift
//  KickIt
//
//  Created by DaeunLee on 10/4/24.
//

import Foundation

/// [타임라인 화면] 사용자 평균 심박수 Response 모델
struct AvgHeartRateResponse: Codable {
    let avgHeartRate: Int // 평균 심박수
}
