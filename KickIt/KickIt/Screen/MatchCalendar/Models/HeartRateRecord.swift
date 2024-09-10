//
//  HeartRateRecord.swift
//  KickIt
//
//  Created by 이윤지 on 9/4/24.
//

import Foundation

/// [Entity] 심박수 통계 화면에서 사용하는 사용자의 심박수 기록
struct HeartRateRecord {
    var heartRate: CGFloat // 심박수
    var heartRateRecordTime: Int // 경기 시간과 매치되도록 바꾼 심박수 기록시간 ex. 1분, 15분.. 이렇게 사용
    var date: String? // 심박수 기록 시간
}
