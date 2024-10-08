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
    @Published var selectedSoccerMatch: SoccerMatch? = dummySoccerMatches[1] // FIXME: api연동시 초기값 삭제!
    
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
