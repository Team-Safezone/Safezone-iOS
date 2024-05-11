//
//  DateExtensions.swift
//  KickIt
//
//  Created by 이윤지 on 5/11/24.
//

import Foundation

/// Date와 관련된 함수, 확장 함수를 모아두는 파일 
/// 축구 경기 날짜 반환
func soccerMatchDate(date: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY.MM.dd"
    
    if let stringToDate = formatter.date(from: date) {
        return stringToDate
    }
    else {
        return Date()
    }
}

/// 축구 경기 시간 반환
func soccerMatchTime(time: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    
    if let stringToTime = formatter.date(from: time) {
        return stringToTime
    }
    else {
        return Date()
    }
}
