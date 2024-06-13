//
//  DefaultMatchCalendarViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Combine
import Foundation

/// 경기 캘린더 화면의 뷰모델
final class DefaultMatchCalendarViewModel: MatchCalendarViewModel {
    
    @Published var soccerMatches: [SoccerMatch] = [] // 하루 경기 일정 리스트
    @Published var monthlyMatchDates: [SoccerMatchDate] = [] // 한달 경기 날짜 리스트
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
    }
    
    /// 한달 경기 일정(날짜) 조회
    func requestYearMonthSoccerMatches(yearMonth: String, teamName: String?) {
        MatchCalendarAPI.shared.getYearMonthSoccerMatches(yearMonth: yearMonth, teamName: teamName)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] matchDates in
                self?.monthlyMatchDates = matchDates
            })
            .store(in: &cancellables)
    }
    
    /// 하루 경기 일정 조회
    func requestDaySoccerMatches(date: String, teamName: String?) {
        MatchCalendarAPI.shared.getDaySoccerMatches(date: date, teamName: teamName)
            // 메인 스레드에서 데이터 처리
            .receive(on: DispatchQueue.main)
            // publisher 결과 구독
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            },
            // publisher 결과 구독 성공
            receiveValue: { [weak self] matches in
                self?.soccerMatches = matches
            })
            .store(in: &cancellables)
    }
}
