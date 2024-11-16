//
//  AppDelegate.swift
//  KickIt
//
//  Created by DaeunLee on 11/5/24.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    let notificationManager = NotificationManager.shared
    let matchCalendarViewModel = MatchCalendarViewModel()
    let alertViewModel = AlertViewModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupNotifications()
        return true
    }

    private func setupNotifications() {
        print("setupNotifications 시작")
        notificationManager.requestAuthorization { granted in
            DispatchQueue.main.async {
                if granted {
                    print("알림 권한 승인됨, 경기 데이터 요청 시작")
                    self.notificationManager.removeAllNotifications()
                    
                    let request = SoccerMatchDailyRequest(date: dateToString4(date: Date()), teamName: nil)
                    print("알림 요청 데이터: \(request)")
                    self.matchCalendarViewModel.getDailySoccerMatches(request: request)
                    
                    self.matchCalendarViewModel.$soccerMatches
                        .sink { matches in
                            print("(알림) 받은 경기 수: \(matches.count)")
                            for match in matches {
                                self.notificationManager.scheduleGameStartNotification(for: match)
                                self.notificationManager.scheduleLineupNotification(for: match)
                            }
                        }
                        .store(in: &self.matchCalendarViewModel.cancellables)
                } else {
                    print("알림 권한 미승인")
                }
            }
        }
    }
}
