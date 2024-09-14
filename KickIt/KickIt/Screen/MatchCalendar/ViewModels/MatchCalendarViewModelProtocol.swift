//
//  MatchCalendarViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation

/// 경기 캘린더 화면의 뷰모델 프로토콜
/// 설명: 기본 뷰모델에서 해당 프로토콜을 상속받아서 사용하기
protocol MatchCalendarViewModelProtocol: ObservableObject {
    /// 한달 경기 일정 조회 결과
    var soccerSeason: String { get } // 축구 시즌
    var matchDates: [Date] { get } // 한달 경기 날짜 리스트
    var soccerTeamNames: [String] { get } // 팀 이름 리스트
    
    /// 한달 경기 날짜 조회
    func getYearMonthSoccerMatches(request: SoccerMatchMonthlyRequest)
    
    /// 축구 경기 리스트
    var soccerMatches: [SoccerMatch] { get }
    
    /// 하루 경기 일정 조회
    func getDailySoccerMatches(request: SoccerMatchDailyRequest)
}
