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

func dateToString3(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    //dateFormatter.locale = Locale.autoupdatingCurrent // 사용자의 위치에 따른 로케일
    dateFormatter.locale = Locale(identifier: "ko_KR") // 대한민국 로케일
    
    let dateToString = dateFormatter.string(from: date)
    
    return dateToString
}

// 문자열을 Date로 변환하는 헬퍼 메서드
func stringToDate(date: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: date) ?? Date()
}

// 문자열을 Time(Date)로 변환하는 헬퍼 메서드
func stringToTime(time: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.date(from: time) ?? Date()
}
