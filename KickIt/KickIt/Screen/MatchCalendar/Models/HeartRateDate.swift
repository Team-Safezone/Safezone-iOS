//
//  HeartRateDate.swift
//  KickIt
//
//  Created by DaeunLee on 10/4/24.
//

import Foundation

/// healthkit에서 심박수를 가져올 때 사용하는 구조
struct HeartRateDate {
    let heartRate: Int // 심박수 수치
    let date: String // "yyyy/MM/dd HH:mm:ss"
}
