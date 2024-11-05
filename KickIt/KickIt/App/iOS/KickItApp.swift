//
//  KickItApp.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

@main
struct KickItApp: App {
    /// 앱 델리게이트 어댑터
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    /// 선택된 경기 ID
    @State private var selectedMatchId: Int64?  // Optional로 변경
    
    /// 홈 뷰 표시 여부
    @State private var showHomeView: Bool = false
    
    /// 온보딩 뷰모델
    @StateObject private var viewModel = MainViewModel()
    
    /// 마이페이지 뷰모델
    @StateObject private var myPageViewModel = MyPageViewModel()
    
    /// 경기 캘린더 뷰모델
    @StateObject private var matchCalendarViewModel = MatchCalendarViewModel()
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(myPageViewModel)
                .preferredColorScheme(myPageViewModel.isDarkMode ? .dark : .light)
                .onReceive(NotificationCenter.default.publisher(for: .didTapMatchNotification)) { notification in
                    if let matchId = notification.userInfo?["matchId"] as? Int64,
                       let notificationType = notification.userInfo?["notificationType"] as? String {
                        if notificationType == "gameStart" {
                            showHomeView = true
                        } else if notificationType == "lineup" {
                            selectedMatchId = matchId
                            // 선택된 경기 정보 업데이트
                            if let match = dummySoccerMatches.first {  // 안전하게 첫 번째 요소 접근
                                matchCalendarViewModel.selectedMatch(match: match)
                            }
                        }
                    }
                }
                .sheet(item: Binding(
                    get: { selectedMatchId.map { Int64Identifier($0) } },
                    set: { selectedMatchId = $0?.id }
                )) { _ in
                    // 선발 라인업 뷰 표시
                    StartingLineup(viewModel: matchCalendarViewModel)
                }
                .fullScreenCover(isPresented: $showHomeView) {
                    // 홈 뷰 표시
                    ContentView()
                }
        }
    }
}

// Int64를 Identifiable로 만들기 위한 래퍼 구조체
struct Int64Identifier: Identifiable {
    let id: Int64
    
    init(_ id: Int64) {
        self.id = id
    }
}
