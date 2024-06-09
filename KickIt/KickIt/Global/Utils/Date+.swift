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

/// Date -> 0월 0일 (요일) 형식으로 변경하는 함수
func dateToString2(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM월 dd일 (E)"
    //dateFormatter.locale = Locale.autoupdatingCurrent // 사용자의 위치에 따른 로케일
    dateFormatter.locale = Locale(identifier: "ko_KR") // 대한민국 로케일
    
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

/// 경기 이벤트 발생 시간에 따라 실제 시간 계산하는 함수
func setEventTime(plusMinute: Int) -> String {
    var dateComponents = DateComponents()
    dateComponents.year = 2024      // 2. 경기 시작 시간
    dateComponents.month = 6
    dateComponents.day = 3
    dateComponents.hour = 21
    dateComponents.minute = 20
    dateComponents.second = 0
    
    // 기본 날짜 생성
    var realTime = Calendar.current.date(from: dateComponents) ?? Date()
    
    // plusMinute를 realTime에 더함
    if let updatedTime = Calendar.current.date(byAdding: .minute, value: plusMinute, to: realTime) {
        realTime = updatedTime
    }
    
    let realTimeString = dateTimeToString(date3: realTime)
    
    return realTimeString
}

/// String -> 분 추출 함수
func minutesExtracted(from dateString: String) -> Int? {
    let calendar = Calendar.current
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
    guard let time1 = dateFormatter.date(from: dateString) else {
        return 0
    }
    
    var dateComponents = DateComponents()
    dateComponents.year = 2024          // 3. 경기 종료 시간
    dateComponents.month = 6
    dateComponents.day = 3
    dateComponents.hour = 22
    dateComponents.minute = 50
    guard let time2 = calendar.date(from: dateComponents) else {
        return 0
    }
    
    // 두 시간 사이의 차이 계산
    let components = calendar.dateComponents([.minute], from: time1, to: time2)
    if let minutes = components.minute {
        return minutes // 분 차이 반환
    } else {
        return 0
    }
}

/// 경기까지 남은 시간을 계산하는 함수
func timeInterval(nowDate: Date, matchDate: Date) -> String {
    let components = Calendar.current.dateComponents([.hour, .minute], from: nowDate, to: matchDate)
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    
    return "\(hour)시간 \(minute)분 후 공개"
}
