//
//  DefaultMatchCalendarViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation
import Combine
import UIKit
import SwiftUI

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
    
    /// 사용자가 선택한 경기
    @Published var selectedSoccerMatch: SoccerMatch?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 한달 경기 날짜 조회 API 호출
        getYearMonthSoccerMatches(request: SoccerMatchMonthlyRequest(yearMonth: dateToString5(date: Date()), teamName: nil))
        
        // 하루 경기 일정 조회 API 연결
        getDailySoccerMatches(request: SoccerMatchDailyRequest(date: dateToString4(date: Date()), teamName: nil))
    }
    
    /// 한달 경기 일정(날짜) 조회
    func getYearMonthSoccerMatches(request: SoccerMatchMonthlyRequest) {
        MatchCalendarAPI.shared.getYearMonthSoccerMatches(request: request)
            // DTO -> Entity로 변경
            .map { responseDTO in
                let dates: [Date] = responseDTO.matchDates.compactMap { stringToDate2(date: $0) }
                let teamNames: [String] = responseDTO.soccerTeamNames ?? []
                let season: String = responseDTO.soccerSeason
                
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
            receiveValue: { [weak self] (dates, teamNames, season) in
                self?.matchDates = dates
                if !teamNames.isEmpty {
                    self?.soccerTeamNames = ["전체"] + teamNames
                }
                self?.soccerSeason = season
            })
            .store(in: &cancellables)
    }
    
    /// 하루 경기 일정 조회
    func getDailySoccerMatches(request: SoccerMatchDailyRequest) {
        MatchCalendarAPI.shared.getDailySoccerMatches(request: request)
            // DTO -> Entity로 변경
            .map { responseDTO in
                let matches = responseDTO.map { data in
                    SoccerMatch(
                        id: data.id,
                        matchDate: stringToDate(date: data.matchDate),
                        matchTime: stringToTime(time: data.matchTime),
                        stadium: data.stadium,
                        matchRound: data.matchRound,
                        homeTeam: SoccerTeam(teamEmblemURL: data.homeTeamEmblemURL, teamName: data.homeTeamName),
                        awayTeam: SoccerTeam(teamEmblemURL: data.awayTeamEmblemURL, teamName: data.awayTeamName),
                        matchCode: data.matchCode)
                }
                return matches
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
                print("날짜 \(matches)")
                self?.soccerMatches = matches
            })
            .store(in: &cancellables)
    }
    
    /// 경기 일정 변환 함수(DTO -> Entity)
    private func matchesToEntity(_ dto: [SoccerMatchDailyResponse]) -> [SoccerMatch] {
        return dto.compactMap { data in
            SoccerMatch(
                id: data.id,
                matchDate: stringToDate(date: data.matchDate),
                matchTime: stringToTime(time: data.matchTime),
                stadium: data.stadium,
                matchRound: data.matchRound,
                homeTeam: SoccerTeam(teamEmblemURL: data.homeTeamEmblemURL, teamName: data.homeTeamName),
                awayTeam: SoccerTeam(teamEmblemURL: data.awayTeamEmblemURL, teamName: data.awayTeamName),
                matchCode: data.matchCode)
        }
    }
    
    /// 라디오 버튼 클릭 이벤트
    func selectedTeam(_ teamName: String, id: Int) {
        selectedRadioBtnID = id
        setSelectedTeamName(teamName: teamName)
    }
    
    /// 팀 이름 전환 함수
    func setSelectedTeamName(teamName: String?) {
        if (teamName == "전체") {
            selectedTeamName = nil
        }
        else {
            selectedTeamName = teamName
        }
    }
    
    /// 사용자가 선택한 경기 정보 업데이트
    func selectedMatch(match: SoccerMatch) {
        selectedSoccerMatch = match
    }
    
    /// 텍스트 스타일 업데이트
    func updateTextStyle(isShowMatchInfo: Bool) -> TextStyle {
        return isShowMatchInfo ? .Title1Style : TextStyle(font: .pretendard(.medium, size: 18), tracking: -0.4, uiFont: UIFont(name: "Pretendard-Medium", size: 18)!, lineHeight: 24)
    }
    
    /// 텍스트 색상업데이트
    func updateTextColor(isShowMatchInfo: Bool) -> Color {
        return isShowMatchInfo ? Color.white0 : Color.gray500
    }
    
    /// 선발라인업 공개 타이머(텍스트)
    func startingLineupTimeInterval(_ nowDate: Date) -> String {
        timeInterval(nowDate: nowDate, matchDate: selectedSoccerMatch!.matchDate, matchTime: selectedSoccerMatch!.matchTime).1
    }
    
    /// 선발라인업 공개 타이머(날짜)
    func startingLineupShowDate(_ nowDate: Date) -> Date {
        timeInterval(nowDate: nowDate, matchDate: selectedSoccerMatch!.matchDate, matchTime: selectedSoccerMatch!.matchTime).0
    }
    
    /// 우승팀 예측 종료 타이머(텍스트)
    func matchEndTimePredictionInterval(_ nowDate: Date) -> String {
        timePredictionInterval3(nowDate: nowDate, matchDate: selectedSoccerMatch!.matchDate, matchTime: selectedSoccerMatch!.matchTime).1
    }
    
    /// 우승팀 예측 종료 타이머(날짜)
    func matchEndTimePredictionShowDate(_ nowDate: Date) -> Date {
        timePredictionInterval3(nowDate: nowDate, matchDate: selectedSoccerMatch!.matchDate, matchTime: selectedSoccerMatch!.matchTime).0
    }
    
    /// 선발라인업 예측 종료 타이머(텍스트)
    func lineupEndTimePredictionInterval(_ nowDate: Date) -> String {
        timePredictionInterval4(nowDate: nowDate, matchDate: selectedSoccerMatch!.matchDate, matchTime: selectedSoccerMatch!.matchTime).1
    }
    
    /// 선발라인업 예측 종료 타이머(날짜)
    func lineupEndTimePredictionShowDate(_ nowDate: Date) -> Date {
        timePredictionInterval4(nowDate: nowDate, matchDate: selectedSoccerMatch!.matchDate, matchTime: selectedSoccerMatch!.matchTime).0
    }
    
    /// 팀 정보에 따른 값(이름, 이미지) 반환
    func teamInfoView(for isHomeTeam: Bool) -> (String, String) {
        let team = isHomeTeam ? selectedSoccerMatch?.homeTeam : selectedSoccerMatch?.awayTeam
        return (team?.teamEmblemURL ?? "", team?.teamName ?? "")
    }
}
