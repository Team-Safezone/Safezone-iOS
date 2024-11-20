//
//  AlertViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 11/16/24.
//

import Foundation
import Combine

// 알림 뷰모델
class AlertViewModel: ObservableObject {
    @Published var alerts: [KickitAlert] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupNotificationObserver()
        loadAlerts()
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.publisher(for: .didTapMatchNotification)
            .sink { [weak self] notification in
                self?.handleNotificationTap(notification)
            }
            .store(in: &cancellables)
    }
    
    // 현재 존재하는 알림 가져오기
    private func loadAlerts() {
        alerts = NotificationManager.shared.unreadAlerts
    }
    
    // 새로운 알림
    private func handleNotificationTap(_ notification: Notification) {
        if let matchId = notification.userInfo?["matchId"] as? Int64,
           let notificationType = notification.userInfo?["notificationType"] as? String {
            print("받은 알림 정보 - matchId: \(matchId), notificationType: \(notificationType)")
            let newAlert = KickitAlert(id: UUID(), matchId: matchId, type: notificationType)
            DispatchQueue.main.async {
                print("(알림) 받은 경기: \(newAlert)")
                self.alerts.append(newAlert)
            }
        }
    }
    
    // 알람을 읽기
    func markAlertAsRead(_ alert: KickitAlert) {
        NotificationManager.shared.markAlertAsRead(alert)
        if let index = alerts.firstIndex(where: { $0.id == alert.id }) {
            alerts.remove(at: index)
        }
    }
}

struct KickitAlert: Identifiable {
    let id: UUID
    let matchId: Int64
    let type: String
}
