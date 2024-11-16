//
//  TimerViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 11/16/24.
//

import Foundation

/// 타이머 뷰모델
class TimerViewModel: ObservableObject {
    /// 선발라인업 예측 종료 타이머
    private var lineupTimer: Timer?
    
    /// 우승팀 예측 종료 타이머
    private var winningTeamTimer: Timer?
    
    /// 우승팀 예측 종료 여부
    @Published var isWinningTeamPredictionFinished: Bool = false
    
    /// 선발라인업 예측 종료 여부
    @Published var isLineupPredictionFinished: Bool = false
    
    /// 우승팀 예측 종료 시간
    @Published var winningTeamEndTime: String = ""
    
    /// 선발라인업 예측 종료 시간
    @Published var lineupEndTime: String = ""
    
    /// 우승팀 예측 종료 타이머(텍스트)
    func matchEndTimePredictionInterval(_ nowDate: Date, _ matchDate: Date, _ matchTime: Date, format: Int) -> String {
        timePredictionInterval1(nowDate: nowDate, matchDate: matchDate, matchTime: matchTime, format: format).1
    }
    
    /// 우승팀 예측 종료 타이머(날짜)
    func matchEndTimePredictionShowDate(_ nowDate: Date, _ matchDate: Date, _ matchTime: Date, format: Int) -> Date {
        timePredictionInterval1(nowDate: nowDate, matchDate: matchDate, matchTime: matchTime, format: format).0
    }
    
    /// 선발라인업 예측 종료 타이머(텍스트)
    func lineupEndTimePredictionInterval(_ nowDate: Date, _ matchDate: Date, _ matchTime: Date, format: Int) -> String {
        timePredictionInterval2(nowDate: nowDate, matchDate: matchDate, matchTime: matchTime, format: format).1
    }
    
    /// 선발라인업 예측 종료 타이머(날짜)
    func lineupEndTimePredictionShowDate(_ nowDate: Date, _ matchDate: Date, _ matchTime: Date, format: Int) -> Date {
        timePredictionInterval2(nowDate: nowDate, matchDate: matchDate, matchTime: matchTime, format: format).0
    }
    
    /// 우승팀 예측 종료 마감까지의 시간 계산
    func winningTeamPredictionTimer(matchDate: Date, matchTime: Date, format: Int) {
        stopWinningTeamTimer() // 기존 타이머 정리
        winningTeamTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let currentDate = Date()
            
            // 예측 타이머 종료 시간이 됐다면
            if currentDate >= matchEndTimePredictionShowDate(currentDate, matchDate, matchTime, format: format) {
                self.stopWinningTeamTimer()
                self.isWinningTeamPredictionFinished = true
            }
            
            DispatchQueue.main.async {
                self.winningTeamEndTime = self.matchEndTimePredictionInterval(currentDate, matchDate, matchTime, format: format)
            }
        }
    }
    
    /// 선발라인업 예측 종료 마감까지의 시간 계산
    func startLineupPredictionTimer(matchDate: Date, matchTime: Date, format: Int) {
        stopLineupTimer() // 기존 타이머 정리
        lineupTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let currentDate = Date()
            
            // 예측 타이머 종료 시간이 됐다면
            if currentDate >= lineupEndTimePredictionShowDate(currentDate, matchDate, matchTime, format: format) {
                self.stopLineupTimer()
                self.isLineupPredictionFinished = true
            }
            
            DispatchQueue.main.async {
                self.lineupEndTime = self.lineupEndTimePredictionInterval(currentDate, matchDate, matchTime, format: format)
            }
        }
    }
    
    /// 선발라인업 예측 타이머 종료
    func stopLineupTimer() {
        lineupTimer?.invalidate()
        lineupTimer = nil
    }
    
    /// 우승팀 예측 타이머 종료
    func stopWinningTeamTimer() {
        winningTeamTimer?.invalidate()
        winningTeamTimer = nil
    }
}
