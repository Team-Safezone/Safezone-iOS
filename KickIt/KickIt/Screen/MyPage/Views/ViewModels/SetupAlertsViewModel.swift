//
//  SetupAlertsViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 10/10/24.
//
import SwiftUI
import UserNotifications

// 알람 설정 뷰모델
class SetupAlertsViewModel: ObservableObject {
    // 경기 시작 알림 설정 상태
    @Published var isGameStartAlertOn: Bool = true
    
    // 선발 라인업 알림 설정 상태
    @Published var isLineupAlertOn: Bool = true
    
    // 경기 일정 저장 배열
    private var matches: [SoccerMatch] = []
    
    init() {
        // 뷰모델 초기화 시 알림 권한 요청
        requestNotificationPermission()
        // 더미 데이터로 경기 일정 설정
        setupMatches()
        // 알림 스케줄링
        scheduleNotifications()
    }
    
    /// 경기 시작 알림 토글 처리
    func toggleGameStartAlert() {
        if isGameStartAlertOn {
            scheduleGameStartAlerts()
        } else {
            removeGameStartAlerts()
        }
    }
    
    /// 선발 라인업 알림 토글 처리
    func toggleLineupAlert() {
        if isLineupAlertOn {
            scheduleLineupAlerts()
        } else {
            removeLineupAlerts()
        }
    }
    
    /// 경기 시작 알림 스케줄링
    private func scheduleGameStartAlerts() {
        for match in matches {
            NotificationManager.shared.scheduleGameStartNotification(for: match)
        }
    }
    
    /// 경기 시작 알림 제거
    private func removeGameStartAlerts() {
        for match in matches {
            NotificationManager.shared.removeScheduledNotification(identifier: "gameStart-\(match.id)")
        }
    }
    
    /// 선발 라인업 알림 스케줄링
    private func scheduleLineupAlerts() {
        for match in matches {
            NotificationManager.shared.scheduleLineupNotification(for: match)
        }
    }
    
    /// 선발 라인업 알림 제거
    private func removeLineupAlerts() {
        for match in matches {
            NotificationManager.shared.removeScheduledNotification(identifier: "lineup-\(match.id)")
        }
    }
    
    /// 알림 권한 요청
    private func requestNotificationPermission() {
        NotificationManager.shared.requestAuthorization { granted in
            if !granted {
                DispatchQueue.main.async {
                    // 권한이 거부되면 알림 설정을 비활성화
                    self.isGameStartAlertOn = false
                    self.isLineupAlertOn = false
                }
            }
        }
    }
    
    /// 더미 데이터로 경기 일정 설정
    private func setupMatches() {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        dateComponents.hour = 20
        dateComponents.minute = 10
        
        guard let matchTime = calendar.date(from: dateComponents) else {
            print("Failed to create match time")
            return
        }
        
        let dummyMatch = SoccerMatch(
            id: 175,
            matchDate: matchTime,
            matchTime: matchTime,
            stadium: "Stadium",
            matchRound: 1,
            homeTeam: SoccerTeam(teamEmblemURL: "", teamName: "토트넘"),
            awayTeam: SoccerTeam(teamEmblemURL: "", teamName: "맨시티"),
            matchCode: 0
        )
        
        matches = [dummyMatch]
    }
    
    /// 알림 스케줄링
    private func scheduleNotifications() {
        if isGameStartAlertOn {
            scheduleGameStartAlerts()
        }
        if isLineupAlertOn {
            scheduleLineupAlerts()
        }
    }
}
