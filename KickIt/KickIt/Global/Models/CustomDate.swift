//
//  CustomDate.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import Foundation

/// 커스텀한 DatePicker에 사용하는 날짜 모델
struct CustomDate: Identifiable {
    var id = UUID().uuidString // 고유 id
    var day: Int // 요일
    var date: Date // 날짜
}
