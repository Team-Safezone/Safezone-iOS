//
//  Date+.swift
//  Watch-Kickit Watch App
//
//  Created by DaeunLee on 9/24/24.
//

import Foundation

/// Date -> 0월 0일 (요일) 형식으로 변경하는 함수
func dateToString2(date: Date) -> String { 
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M월 dd일 (E)"
    //dateFormatter.locale = Locale.autoupdatingCurrent // 사용자의 위치에 따른 로케일
    dateFormatter.locale = Locale(identifier: "ko_KR") // 대한민국 로케일
    
    let dateToString = dateFormatter.string(from: date)
    
    return dateToString
    
}
