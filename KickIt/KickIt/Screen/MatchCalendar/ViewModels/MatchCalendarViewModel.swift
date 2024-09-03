//
//  DefaultMatchCalendarViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Combine
import Foundation

/// 경기 캘린더 화면의 뷰모델
/// 설명: 뷰모델에서 데이터 변환(DTO -> Entity), 응답에 따른 에러 핸들링을 처리하기
final class MatchCalendarViewModel: MatchCalendarViewModelProtocol {
    @Published var soccerSeason: String = "" // 축구 시즌
    @Published var matchDates: [Date] = [] // 한달 경기 날짜 리스트
    @Published var soccerTeamNames: [String] = [] // 팀 이름 리스트
    @Published var soccerMatches: [SoccerMatch] = [] // 하루 경기 일정 리스트
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 한달 경기 일정(날짜) 조회
    func getYearMonthSoccerMatches(request: SoccerMatchMonthlyRequest) {
        MatchCalendarAPI.shared.getYearMonthSoccerMatches(request: request)
            // DTO -> Entity로 변경
            .map { responseDTO in
                let dates = responseDTO.matchDates.compactMap { stringToDate2(date: $0) }
                let teamNames = responseDTO.soccerTeamNames
                let season = responseDTO.soccerSeason
                
                return (dates, teamNames, season)
            }
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
            // monthlyMatches에 publisher 응답 결과 업데이트
            receiveValue: { [weak self] (dates, teams, season) in
                self?.matchDates = dates
                self?.soccerTeamNames = ["전체"] + teams
                self?.soccerSeason = season
            })
            .store(in: &cancellables)
    }
    
    /// 하루 경기 일정 조회
    func getDailySoccerMatches(request: SoccerMatchDailyRequest) {
        MatchCalendarAPI.shared.getDailySoccerMatches(request: request)
            // DTO -> Entity로 변경
            .map { responseDTO in
                responseDTO.map { data in
                    SoccerMatch(
                        id: data.id,
                        soccerSeason: data.soccerSeason,
                        matchDate: stringToDate(date: data.matchDate),
                        matchTime: stringToTime(time: data.matchTime),
                        stadium: data.stadium,
                        matchRound: data.matchRound,
                        homeTeam: SoccerTeam(teamEmblemURL: data.homeTeamEmblemURL, teamName: data.homeTeamName),
                        awayTeam: SoccerTeam(teamEmblemURL: data.awayTeamEmblemURL, teamName: data.awayTeamName),
                        matchCode: data.matchCode)
                }
            }
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
