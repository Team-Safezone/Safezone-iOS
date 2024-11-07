//
//  NotificationManager.swift
//  KickIt
//
//  Created by DaeunLee on 11/5/24.
//

import UserNotifications

// 알림 매니저
class NotificationManager: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    // 싱글톤 인스턴스
    static let shared = NotificationManager()
    
    // 프라이빗 이니셜라이저로 외부에서 인스턴스 생성 방지
    override private init() {
        super.init()
        // 현재 인스턴스를 UNUserNotificationCenter의 델리게이트로 설정
        UNUserNotificationCenter.current().delegate = self
    }
    
    /// 알림 권한 요청
    /// - Parameter completion: 권한 부여 여부를 Bool 값으로 전달하는 완료 핸들러
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            // 메인 스레드에서 완료 핸들러 호출
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    /// 경기 시작 알림 스케줄링
    /// - Parameter match: 경기 정보
    func scheduleGameStartNotification(for match: SoccerMatch) {
        // 기존의 중복된 알림 삭제
        removeExistingNotifications(for: match.id, type: "gameStart")
        
        let content = UNMutableNotificationContent()
        content.title = "경기 시작 알림"
        content.body = "\(match.homeTeam.teamName) vs \(match.awayTeam.teamName) 경기가 곧 시작됩니다!"
        content.sound = .default
        content.userInfo = ["matchId": match.id, "notificationType": "gameStart"]
        
        // 오늘 날짜의 경기 시작 시간 설정
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let timeComponents = calendar.dateComponents([.hour, .minute], from: match.matchTime)
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        
        // 경기 시작 5분 전으로 설정
        dateComponents.minute! -= 5
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "gameStart-\(match.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("경기 시작 알림 스케줄링 실패: \(error.localizedDescription)")
            } else {
                if let notificationTime = calendar.date(from: dateComponents) {
                    print("경기 시작 알림이 성공적으로 스케줄링되었습니다. 매치 ID: \(match.id), 알림 시간: \(notificationTime)")
                }
            }
        }
    }
    
    /// 선발 라인업 알림 스케줄링
    /// - Parameter match: 경기 정보
    func scheduleLineupNotification(for match: SoccerMatch) {
        // 기존의 중복된 알림 삭제
        removeExistingNotifications(for: match.id, type: "lineup")
        
        let content = UNMutableNotificationContent()
        content.title = "선발 라인업 공개"
        content.body = "\(match.homeTeam.teamName) vs \(match.awayTeam.teamName) 선발라인업이 공개되었습니다!"
        content.sound = .default
        content.userInfo = ["matchId": match.id, "notificationType": "lineup"]
        
        // 오늘 날짜의 라인업 공개 시간 설정 (경기 1시간 전)
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let timeComponents = calendar.dateComponents([.hour, .minute], from: match.matchTime)
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        
        // 경기 시작 1시간 전으로 설정
        dateComponents.hour! -= 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "lineup-\(match.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("선발 라인업 알림 스케줄링 실패: \(error.localizedDescription)")
            } else {
                if let notificationTime = calendar.date(from: dateComponents) {
                    print("선발 라인업 알림이 성공적으로 스케줄링되었습니다. 매치 ID: \(match.id), 알림 시간: \(notificationTime)")
                }
            }
        }
    }
    
    /// 기존의 중복된 알림 삭제
    /// - Parameters:
    ///   - matchId: 경기 ID
    ///   - type: 알림 타입 ("gameStart" 또는 "lineup")
    private func removeExistingNotifications(for matchId: Int64, type: String) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            let identifiersToRemove = requests.filter { request in
                if let userInfo = request.content.userInfo as? [String: Any],
                   let notificationMatchId = userInfo["matchId"] as? Int64,
                   let notificationType = userInfo["notificationType"] as? String {
                    return notificationMatchId == matchId && notificationType == type
                }
                return false
            }.map { $0.identifier }
            
            center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
        }
    }
    
    /// 예약된 알림 제거
    /// - Parameter identifier: 제거할 알림의 식별자
    func removeScheduledNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    /// 앱이 포그라운드에 있을 때 알림을 어떻게 표시할지 결정하는 델리게이트 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    /// 사용자가 알림을 탭했을 때 호출되는 델리게이트 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("사용자가 알림을 탭했습니다: \(userInfo)")
        
        if let matchId = userInfo["matchId"] as? Int64,
           let notificationType = userInfo["notificationType"] as? String {
            NotificationCenter.default.post(
                name: .didTapMatchNotification,
                object: nil,
                userInfo: ["matchId": matchId, "notificationType": notificationType]
            )
        }
        completionHandler()
    }
}

extension Notification.Name {
    static let didTapMatchNotification = Notification.Name("didTapMatchNotification")
}

extension NotificationManager {
    /// 지난 경기의 알림 삭제
    func removePastNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            let currentDate = Date()
            let identifiersToRemove = requests.compactMap { request -> String? in
                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                   let nextTriggerDate = trigger.nextTriggerDate(),
                   nextTriggerDate < currentDate {
                    return request.identifier
                }
                return nil
            }
            center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
        }
    }
    
    /// 모든 알림 삭제
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
