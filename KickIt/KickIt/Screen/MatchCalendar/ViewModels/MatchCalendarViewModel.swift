//
//  MatchCalendarViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation

/// 경기 캘린더 화면의 뷰모델 프로토콜
protocol MatchCalendarViewModel: ObservableObject {
    /// 한달 경기 날짜 리스트
    var monthlyMatchDates: [SoccerMatchDate] { get }
    
    /// 한달 경기 날짜 조회
    func requestYearMonthSoccerMatches(yearMonth: String, teamName: String?)
    
    /// 축구 경기 리스트
    var soccerMatches: [SoccerMatch] { get }
    
    /// 하루 경기 일정 조회
    func requestDaySoccerMatches(date: String, teamName: String?)
}
