//
//  DefaultMatchCalendarViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation
import Combine

/// 경기 캘린더 화면의 뷰모델
/// 설명: 뷰모델에서 데이터 변환(DTO -> Entity), 응답에 따른 에러 핸들링을 처리하기
final class MatchCalendarViewModel: MatchCalendarViewModelProtocol {
    @Published var soccerSeason: String = "" // 축구 시즌
    @Published var matchDates: [Date] = [] // 한달 경기 날짜 리스트
    @Published var soccerTeamNames: [String] = [] // 팀 이름 리스트
    @Published var soccerMatches: [SoccerMatch] = [] // 하루 경기 일정 리스트
    
    /// 라디오그룹에서 선택한 팀 아이디
    @Published var selectedRadioBtnID: Int = 0
    
    /// 라디오그룹에서 선택한 팀 이름 정보
    @Published var selectedTeamName: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 한달 경기 일정(날짜) 조회
    func getYearMonthSoccerMatches(request: SoccerMatchMonthlyRequest) {
        MatchCalendarAPI.shared.getYearMonthSoccerMatches(request: request)
            // DTO -> Entity로 변경
            .map { responseDTO in
                // FIXME: dates, teamNames, season가 있는 버전으로 바꾸기. -> 주석 삭제!
                let dates = responseDTO.compactMap { stringToDate2(date: $0.matchDates) }
                //let dates = responseDTO.matchDates.compactMap { stringToDate2(date: $0) }
                //let teamNames = responseDTO.soccerTeamNames
                //let season = responseDTO.soccerSeason
                
                return (dates)
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
            receiveValue: { [weak self] (dates) in
                self?.matchDates = dates
                //self?.soccerTeamNames = ["전체"] + teams
                //self?.soccerSeason = season
            })
            .store(in: &cancellables)
    }
    
    /// 하루 경기 일정 조회
    // FIXME: 홈팀, 원정팀 엠블럼 데이터 받아올 수 있게 되면, 추가하기!
    func getDailySoccerMatches(request: SoccerMatchDailyRequest) {
        MatchCalendarAPI.shared.getDailySoccerMatches(request: request)
            // DTO -> Entity로 변경
            .map { responseDTO in
                responseDTO.map { data in
                    SoccerMatch(
                        id: data.id,
                        matchDate: stringToDate(date: data.matchDate),
                        matchTime: stringToTime(time: data.matchTime),
                        stadium: data.stadium,
                        matchRound: data.matchRound,
                        homeTeam: SoccerTeam(teamEmblemURL: "", teamName: data.homeTeamName),
                        awayTeam: SoccerTeam(teamEmblemURL: "", teamName: data.awayTeamName),
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
    
    /// 라디오 버튼 클릭 이벤트
    func selectedTeam(_ teamName: String, id: Int) {
        selectedRadioBtnID = id
        
        if (selectedTeamName == "전체") {
            selectedTeamName = nil
        }
        else {
            selectedTeamName = teamName
        }
    }
}
