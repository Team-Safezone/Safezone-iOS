//
//  NotificationManager.swift
//  KickIt
//
//  Created by DaeunLee on 11/5/24.
//

import UserNotifications

// 알림 매니저
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
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
        let content = UNMutableNotificationContent()
        content.title = "경기 시작 알림"
        content.body = "\(match.homeTeam.teamName) vs \(match.awayTeam.teamName) 경기가 곧 시작됩니다!"
        content.sound = .default
        content.userInfo = ["matchId": match.id, "notificationType": "gameStart"]
        
        let gameStartTime = Calendar.current.date(byAdding: .minute, value: -5, to: match.matchTime)!
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: gameStartTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "gameStart-\(match.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("경기 시작 알림 스케줄링 실패: \(error.localizedDescription)")
            } else {
                print("경기 시작 알림이 성공적으로 스케줄링되었습니다. 매치 ID: \(match.id), 알림 시간: \(gameStartTime)")
            }
        }
    }
    
    /// 선발 라인업 알림 스케줄링
    /// - Parameter match: 경기 정보
    func scheduleLineupNotification(for match: SoccerMatch) {
        let content = UNMutableNotificationContent()
        content.title = "선발 라인업 공개"
        content.body = "\(match.homeTeam.teamName) vs \(match.awayTeam.teamName) 선발라인업이 공개되었습니다!"
        content.sound = .default
        content.userInfo = ["matchId": match.id, "notificationType": "lineup"]
        
        let lineupTime = Calendar.current.date(byAdding: .hour, value: -1, to: match.matchTime)!
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: lineupTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "lineup-\(match.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("선발 라인업 알림 스케줄링 실패: \(error.localizedDescription)")
            } else {
                print("선발 라인업 알림이 성공적으로 스케줄링되었습니다. 매치 ID: \(match.id), 알림 시간: \(lineupTime)")
            }
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
