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
    dateFormatter.dateFormat = "M월 dd일(E)"
    //dateFormatter.locale = Locale.autoupdatingCurrent // 사용자의 위치에 따른 로케일
    dateFormatter.locale = Locale(identifier: "ko_KR") // 대한민국 로케일
    
    let dateToString = dateFormatter.string(from: date)
    
    return dateToString
    
}

/// Date -> 0월 0일 형식으로 변경하는 함수
func dateToString3(date: Date?) -> String {
    guard let date = date else { return "" }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M월 dd일"
    //dateFormatter.locale = Locale.autoupdatingCurrent // 사용자의 위치에 따른 로케일
    dateFormatter.locale = Locale(identifier: "ko_KR") // 대한민국 로케일
    
    return dateFormatter.string(from: date)
}

/// Date -> yyyy/MM/dd 형식으로 변경하는 함수
func dateToString4(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    
    let dateToString = dateFormatter.string(from: date)
    
    return dateToString
}

/// Date -> String(yyyy/MM)으로 변경하는 함수
func dateToString5(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM"
    
    let dateToString = dateFormatter.string(from: date)
    
    return dateToString
}

/// Date -> 요일로 변경하는 함수
func dateToDay(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E요일"
    //dateFormatter.locale = Locale.autoupdatingCurrent // 사용자의 위치에 따른 로케일
    dateFormatter.locale = Locale(identifier: "ko_KR") // 대한민국 로케일
    
    let dateToString = dateFormatter.string(from: date)
    
    return dateToString
}

/// String -> Date yyyy/MM/dd 형식으로 변경하는 함수
func stringToDate(date: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
            
    let convertDate = dateFormatter.date(from: date) ?? Date() // Date 타입으로 변환
    return convertDate
}

/// String -> Date(yyyy.MM.dd) 형식으로 변경하는 함수
func stringToDate2(date: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"
            
    let convertDate = dateFormatter.date(from: date) ?? Date() // Date 타입으로 변환
    return convertDate
}

// String -> Date(yyyy/MM/dd HH:mm:ss) 형식으로 변경하는 함수
func stringToDate3(date: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    
    // Date 타입으로 변환
    if let convertDate = dateFormatter.date(from: date) {
        return convertDate
    } else {
        print("[타임라인] 날짜 변환 실패: \(date)")
        return nil // 변환 실패 시 nil 반환
    }
}

/// String -> String(M월 dd일) 형식으로 변경하는 함수
func stringToDateString(_ date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"
    
    let dateFormatter2 = DateFormatter()
    dateFormatter2.dateFormat = "M월 d일"
    dateFormatter2.locale = Locale(identifier: "ko_KR") // 대한민국 로케일
    
    let convertDate = dateFormatter.date(from: date) ?? Date()
    let dateToString = dateFormatter2.string(from: convertDate)
    
    // 오늘이라면
    if isToday(date: convertDate) {
        print(convertDate.description)
        return "오늘"
    }
    // 어제라면
    else if isYesterday(date: convertDate) {
        return "어제"
    }
    // 다른 날짜라면
    else {
        return dateToString
    }
}

/// 주어진 Date가 어제 날짜 인지 판단하는 함수
func isYesterday(date: Date) -> Bool {
    return Calendar.current.isDateInYesterday(date)
}

/// 주어진 Date가 오늘 날짜 인지 판단하는 함수
func isToday(date: Date) -> Bool {
    return Calendar.current.isDateInToday(date)
}

/// String -> Time h:mm 형식으로 변경하는 함수
func stringToTime(time: String) -> Date {
    //04:00
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
            
    let convertTime = dateFormatter.date(from: time) ?? Date() // Date 타입으로 변환
    return convertTime
}

/// Time -> String으로 변경하는 함수
func timeToString(time: Date?) -> String {
    guard let time = time else { return "시간 정보 없음" }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: time)
}

/// 두 날짜가 동일한 날짜인지 확인하는 함수
func isSameDay(date1: Date, date2: Date) -> Bool {
    return Calendar.current.isDate(date1, inSameDayAs: date2)
}

/// 두 날짜의 월이 동일한지 확인하는 함수
func isSameMonth(date1: Date, date2: Date) -> Bool {
    let calendar = Calendar.current

    let components1 = calendar.dateComponents([.month], from: date1)
    let components2 = calendar.dateComponents([.month], from: date2)
    
    return components1.month == components2.month
}

/// Date,Time -> String으로 변경하는 함수
func dateTimeToString(date3: Date) -> String {
    let datetimeFormatter = DateFormatter()
    datetimeFormatter.dateFormat = "yyyy/MM/dd HH:mm"
    
    let datetimeToString = datetimeFormatter.string(from: date3)
    
    return datetimeToString
}

/// Date,Time -> String으로 변경하는 함수
func dateToString4(date4: Date) -> String {
    let datetimeFormatter = DateFormatter()
    datetimeFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    
    let datetimeToString = datetimeFormatter.string(from: date4)
    
    return datetimeToString
}


/// 타임라인 시간 계산
func calculateEventTime(from matchStartTime: Date?, eventTime: String) -> Int {
    guard let startTime = matchStartTime else { return 0 }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone.current  // 현재 시간대 사용
    
    guard let eventDate = dateFormatter.date(from: eventTime) else {
        print("Failed to parse date: \(eventTime)")
        return 0
    }
    
    let elapsedTime = Int(eventDate.timeIntervalSince(startTime) / 60)
    return max(elapsedTime, 0)  // 음수 값 방지
}

/// 경기 시작 시간 설정
func setStartTime() -> DateComponents {
    var dateComponents = DateComponents()
    dateComponents.year = 2024      // 1. 경기 시작 시간
    dateComponents.month = 6
    dateComponents.day = 20
    dateComponents.hour = 14
    dateComponents.minute = 00
    dateComponents.second = 0
    
    return dateComponents
}

/// 경기 끝 시간 설정
func setEndTime() -> DateComponents {
    var dateComponents = DateComponents()
    dateComponents.year = 2024      // 2. 경기 종료 시간
    dateComponents.month = 6
    dateComponents.day = 20
    dateComponents.hour = 15
    dateComponents.minute = 30
    dateComponents.second = 0
    
    return dateComponents
}

/// 경기 이벤트 발생 시간에 따라 실제 시간 계산하는 함수
func setEventTime(plusMinute: Int) -> String {
    let dateComponents = setStartTime()
    
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
    
    let dateComponents = setEndTime()
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

/// [선발 라인업 공개] 선발라인업 공개까지 남은 시간을 계산하는 함수
func timeInterval(nowDate: Date, matchDate: Date, matchTime: Date) -> (Date, String) {
    let matchDateTime = extractDateTime(date: matchDate, time: matchTime)
    
    // 1시간 전의 날짜와 시간 계산
    let oneHourThirtyMinutesBefore = Calendar.current.date(byAdding: .minute, value: -90, to: matchDateTime)!
    
    let components = Calendar.current.dateComponents([.hour, .minute], from: nowDate, to: oneHourThirtyMinutesBefore)
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    
    return (oneHourThirtyMinutesBefore, "\(hour)시간 \(minute)분 후 공개")
}

/// [예측] 경기 예측 종료까지 남은 시간을 계산하는 함수
func timePredictionInterval1(nowDate: Date, matchDate: Date, matchTime: Date, format: Int) -> (Date, String) {
    let matchDateTime = extractDateTime(date: matchDate, time: matchTime)
    let components = Calendar.current.dateComponents([.hour, .minute, .second], from: nowDate, to: matchDateTime)
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    let second = components.second ?? 0
    
    var tempFormat = ""
    if format == 0 {
        tempFormat = String(format: "%02d:%02d:%02d", hour, minute, second)
    }
    else {
        tempFormat = "\(hour)시간 \(minute)분 \(second)초 남음"
    }
    
    return (matchDateTime, tempFormat)
}

/// [예측] 선발라인업 예측 종료까지 남은 시간을 계산하는 함수
func timePredictionInterval2(nowDate: Date, matchDate: Date, matchTime: Date, format: Int) -> (Date, String) {
    let matchDateTime = extractDateTime(date: matchDate, time: matchTime)
    
    // 1시간 30분 전의 날짜와 시간 계산
    let oneHourThirtyMinutesBefore = Calendar.current.date(byAdding: .minute, value: -90, to: matchDateTime)!
    
    let components = Calendar.current.dateComponents([.hour, .minute, .second], from: nowDate, to: oneHourThirtyMinutesBefore)
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    let second = components.second ?? 0
    
    var tempFormat = ""
    if format == 0 {
        tempFormat = String(format: "%02d:%02d:%02d", hour, minute, second)
    }
    else {
        tempFormat = "\(hour)시간 \(minute)분 \(second)초 남음"
    }
    
    return (oneHourThirtyMinutesBefore, tempFormat)
}

/// 입력받은 날짜, 시간 정보를 바탕으로 하나의 date값을 반환하는 함수
func extractDateTime(date: Date, time: Date) -> Date {
    let calendar = Calendar.current
    // 날짜의 연, 월, 일 추출
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
    
    // 시간의 시, 분 추출
    let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
    
    // 날짜와 시간을 결합
    var combinedComponents = DateComponents()
    combinedComponents.year = dateComponents.year
    combinedComponents.month = dateComponents.month
    combinedComponents.day = dateComponents.day
    combinedComponents.hour = timeComponents.hour
    combinedComponents.minute = timeComponents.minute
    combinedComponents.second = timeComponents.second
    
    return calendar.date(from: combinedComponents)!
}
