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
    let oneHourBefore = Calendar.current.date(byAdding: .hour, value: -1, to: matchDateTime)!
    
    let components = Calendar.current.dateComponents([.hour, .minute], from: nowDate, to: oneHourBefore)
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    
    return (oneHourBefore, "\(hour)시간 \(minute)분 후 공개")
}

/// [우승팀 예측] 경기까지 남은 시간을 계산하는 함수
func timePredictionInterval(nowDate: Date, matchDate: Date, matchTime: Date) -> String {
    let matchDateTime = extractDateTime(date: matchDate, time: matchTime)
    let components = Calendar.current.dateComponents([.hour, .minute, .second], from: nowDate, to: matchDateTime)
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    let second = components.second ?? 0
    
    return "\(hour)시간 \(minute)분 \(second)초 남음"
}

/// [선발라인업 예측] 선발라인업 예측 종료까지 남은 시간을 계산하는 함수
func timePredictionInterval2(nowDate: Date, matchDate: Date, matchTime: Date) -> String {
    let matchDateTime = extractDateTime(date: matchDate, time: matchTime)
    
    // 1시간 전의 날짜와 시간 계산
    guard let oneHourBefore = Calendar.current.date(byAdding: .hour, value: -1, to: matchDateTime) else {
        return "00:00:00"
    }
    
    let components = Calendar.current.dateComponents([.hour, .minute, .second], from: nowDate, to: oneHourBefore)
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    let second = components.second ?? 0
    
    return "\(hour)시간 \(minute)분 \(second)초 남음"
}

/// [경기 정보-예측] 경기 예측 종료까지 남은 시간을 계산하는 함수
func timePredictionInterval3(nowDate: Date, matchDate: Date, matchTime: Date) -> (Date, String) {
    let matchDateTime = extractDateTime(date: matchDate, time: matchTime)
    let components = Calendar.current.dateComponents([.hour, .minute, .second], from: nowDate, to: matchDateTime)
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    let second = components.second ?? 0
    
    return (matchDateTime, String(format: "%02d:%02d:%02d", hour, minute, second))
}

/// [경기 정보-예측] 선발라인업 예측 종료까지 남은 시간을 계산하는 함수
func timePredictionInterval4(nowDate: Date, matchDate: Date, matchTime: Date) -> (Date, String) {
    let matchDateTime = extractDateTime(date: matchDate, time: matchTime)
    
    // 1시간 전의 날짜와 시간 계산
    let oneHourBefore = Calendar.current.date(byAdding: .hour, value: -1, to: matchDateTime)!
    
    let components = Calendar.current.dateComponents([.hour, .minute, .second], from: nowDate, to: oneHourBefore)
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    let second = components.second ?? 0
    
    return (oneHourBefore, String(format: "%02d:%02d:%02d", hour, minute, second))
}

/// 입력받은 날짜, 시간 정보를 바탕으로 하나의 date값을 반환하는 함수
func extractDateTime(date: Date, time: Date) -> Date {
    // 날짜 formatter
    //let dateFormatter = DateFormatter()
    //dateFormatter.dateFormat = "yyyy-MM-dd"
    
    // 시간 formatter
    //let timeFormatter = DateFormatter()
    //timeFormatter.dateFormat = "HH:mm"
    
    //guard let fullMatchDate = dateFormatter.date(from: matchDate),
          //let fullMatchTime = timeFormatter.date(from: matchTime) else {
        //return ""
    //}
    
    // 구성요소 추출
    let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
    let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: time)
    
    // 날짜 + 시간 결합
    var fullDateComponents = DateComponents()
    fullDateComponents.year = dateComponents.year
    fullDateComponents.month = dateComponents.month
    fullDateComponents.day = dateComponents.day
    fullDateComponents.hour = timeComponents.hour
    fullDateComponents.minute = timeComponents.minute
    fullDateComponents.second = timeComponents.second
    
    return Calendar.current.date(from: fullDateComponents)!
}
