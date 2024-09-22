//
//  DefaultMatchCalendarViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 6/3/24.
//

import Foundation
import Combine
import WatchConnectivity

/// 경기 캘린더 화면의 뷰모델
/// 설명: 뷰모델에서 데이터 변환(DTO -> Entity), 응답에 따른 에러 핸들링을 처리하기
final class MatchCalendarViewModel: NSObject, MatchCalendarViewModelProtocol, ObservableObject, WCSessionDelegate {
    @Published var soccerSeason: String = "" // 축구 시즌
    @Published var matchDates: [Date] = [] // 한달 경기 날짜 리스트
    @Published var soccerTeamNames: [String] = [] // 팀 이름 리스트
    @Published var soccerMatches: [SoccerMatch] = [] // 하루 경기 일정 리스트
    
    private var cancellables = Set<AnyCancellable>() // Combine 구독을 저장하는 집합
    
    private var session: WCSession? // Watch Connectivity 세션
        
        override init() {
            super.init()
            setupWatchConnectivity()
        }
        
        /// Watch Connectivity 설정
        private func setupWatchConnectivity() {
            if WCSession.isSupported() {
                session = WCSession.default
                session?.delegate = self
                session?.activate()
            }
        }
    
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
                        soccerSeason: data.soccerSeason,
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
                self?.sendMatchesToWatch(matches: matches)
            })
            .store(in: &cancellables)
    }
    
    
    // MARK: - Watch로 경기 데이터를 전송
    /// - Parameter matches: 전송할 경기 목록
    private func sendMatchesToWatch(matches: [SoccerMatch]) {
        guard WCSession.isSupported() else {
            print("Watch Connectivity is not supported on this device")
            return
        }
        
        let session = WCSession.default
        
        // Watch로 전송할 수 있는 형태로 데이터 변환
        let matchesData = matches.map { match in
            [
                "id": match.id,
                "matchTime": match.matchTime,
                "homeTeamName": match.homeTeam.teamName,
                "awayTeamName": match.awayTeam.teamName
            ]
        }
        
        // applicationContext를 업데이트하여 Watch로 데이터 전송
        do {
            try session.updateApplicationContext(["matches": matchesData])
            print("Data sent successfully to Watch")
        } catch {
            print("Error sending data to Watch: \(error.localizedDescription)")
        }
    }
    
    // MARK: - WCSessionDelegate Methods
    
    /// WCSession 활성화가 완료되었을 때 호출되는 메서드
    /// - Parameters:
    ///   - session: 활성화된 WCSession 인스턴스
    ///   - activationState: 세션의 현재 활성화 상태
    ///   - error: 활성화 과정에서 발생한 오류 (있는 경우)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("iOS WCSession activation failed with error: \(error.localizedDescription)")
        } else {
            print("iOS WCSession activated with state: \(activationState.rawValue)") // 0: .notActivated 1: .inactive 2: .activated
        }
    }
    
    /// WCSession이 비활성 상태가 되었을 때 호출되는 메서드
    /// - Parameter session: 비활성화된 WCSession 인스턴스
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("iOS WCSession became inactive")
    }
    
    /// WCSession이 비활성화되고 새로운 세션으로 대체될 준비가 되었을 때 호출되는 메서드
    /// - Parameter session: 비활성화된 WCSession 인스턴스
    func sessionDidDeactivate(_ session: WCSession) {
        print("iOS WCSession deactivated")
        // 새로운 세션 활성화. 사용자가 다른 Apple Watch로 전환했을 때 필요.
        WCSession.default.activate()
    }
}
