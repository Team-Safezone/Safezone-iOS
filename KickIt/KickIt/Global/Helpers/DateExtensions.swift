//
//  DateExtensions.swift
//  KickIt
//
//  Created by 이윤지 on 5/11/24.
//

import Foundation

/// Date와 관련된 함수, 확장 함수를 모아두는 파일
/// Date -> String으로 변경하는 함수
func dateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"
    
    let dateToString = dateFormatter.string(from: date)
    
    return dateToString
}

/// Time -> String으로 변경하는 함수
func timeToString(time: Date) -> String {
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:mm"
    
    let timeToString = timeFormatter.string(from: time)
    
    return timeToString
}

/// 두 날짜가 동일한 날짜인지 확인하는 함수
func isSameDay(date1: Date, date2: Date) -> Bool {
    return Calendar.current.isDate(date1, inSameDayAs: date2)
}

/// Date,Time -> String으로 변경하는 함수
func dateTimeToString(date3: Date) -> String {
    let datetimeFormatter = DateFormatter()
    datetimeFormatter.dateFormat = "yyyy/MM/dd HH:mm"
    
    let datetimeToString = datetimeFormatter.string(from: date3)
    
    return datetimeToString
}
