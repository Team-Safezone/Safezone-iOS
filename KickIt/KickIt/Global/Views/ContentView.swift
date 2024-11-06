//
//  ContentView.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

/// 탭 메뉴 열거형
enum Tab {
    case home, calendar, diary, mypage
}

/// 메인 네비게이션 설정 화면
struct ContentView: View {
    /// 사용자가 선택한 네비게이션 화면 tag 변수
    @State private var selectedMenu: Tab = .home
    
    /// 네비게이션 스택 관리 변수
    @State private var path = NavigationPath()
    
    /// 홈 뷰모델
    @StateObject var homeViewModel = HomeViewModel()
    
    /// 경기 캘린더 뷰모델
    @StateObject var matchCalendarViewModel = MatchCalendarViewModel()
    
    /// 시스템 모드 반영
    @EnvironmentObject var myPageViewModel: MyPageViewModel
    
    /// 알림 관리자
    @StateObject private var notificationManager = NotificationManager.shared
    
    /// 선택된 경기 ID
    @State private var selectedMatchId: Int64?
    
    /// 홈 뷰 표시 여부
    @State private var showHomeView: Bool = false
    
    // 로그아웃 상태
    @Binding var isLoggedIn: Bool
    
    /// 초기화 메서드
//    init() {
//        // 탭바 색상 초기화
//        UITabBar.appearance().backgroundColor = UIColor.black0
//    }
    
    var body: some View {
        TabView(selection: $selectedMenu) {
            /// 홈 화면
            Home(soccerMatch: dummySoccerMatches[0], selectedMenu: $selectedMenu, path: $path, viewModel: homeViewModel, calendarViewModel: matchCalendarViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("홈").pretendardTextStyle(.Caption2Style)
                }
                .tag(Tab.home)
            
            /// 경기 일정 & 캘린더 화면
            MatchCalendar(path: $path, viewModel: matchCalendarViewModel)
                .tabItem {
                    Image(systemName: "soccerball")
                    Text("경기 캘린더").pretendardTextStyle(.Caption2Style)
                }
                .tag(Tab.calendar)
            
            /// 축구 경기 일기 화면
            SoccerDiary()
                .tabItem {
                    Image(systemName: "book")
                    Text("축구 일기").pretendardTextStyle(.Caption2Style)
                }
                .tag(Tab.diary)
            
            /// 마이페이지 화면
            MyPage(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("마이페이지").pretendardTextStyle(.Caption2Style)
                }
                .tag(Tab.mypage)
        }
        .onReceive(NotificationCenter.default.publisher(for: .didTapMatchNotification)) { notification in
            handleNotificationTap(notification)
        }
        .sheet(item: Binding(get: { selectedMatchId.map { Int64Identifier($0) } }, set: { selectedMatchId = $0?.id })) { _ in
            StartingLineup(viewModel: matchCalendarViewModel)
        }
        .fullScreenCover(isPresented: $showHomeView) {
            ContentView(isLoggedIn: $isLoggedIn)
        }
        .onAppear {
            setupNotifications()
        }
    }
    
    /// 알림 설정 및 스케줄링
    private func setupNotifications() {
        print("setupNotifications 시작")
        notificationManager.requestAuthorization { granted in
            DispatchQueue.main.async {
                if granted {
                    print("알림 권한 승인됨, 경기 데이터 요청 시작")
                    // 알림 스케줄링을 위한 경기 데이터 요청
                    let request = SoccerMatchDailyRequest(date: dateToString4(date: Date()), teamName: nil)
                    print("알림 요청 데이터: \(request)")
                    self.matchCalendarViewModel.getDailySoccerMatches(request: request)
                    
                    // 데이터가 로드되면 알림을 스케줄링
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
    
    /// 알림 탭 처리
    /// - Parameter notification: 수신된 알림 정보
    private func handleNotificationTap(_ notification: Notification) {
        if let matchId = notification.userInfo?["matchId"] as? Int64,
           let notificationType = notification.userInfo?["notificationType"] as? String {
            print("받은 알림 정보 - matchId: \(matchId), notificationType: \(notificationType)")
            if notificationType == "gameStart" {
                showHomeView = true
            } else if notificationType == "lineup" {
                selectedMatchId = matchId
                print("(알림) 선발 라인업 뷰 준비 - matchId: \(matchId)")
                let request = SoccerMatchDailyRequest(date: dateToString4(date: Date()), teamName: nil)
                matchCalendarViewModel.getDailySoccerMatches(request: request)
                
                // 데이터가 로드되면 선택된 경기를 설정
                matchCalendarViewModel.$soccerMatches
                    .sink { matches in
                        print("(알림) 받은 경기 수: \(matches.count)")
                        if let match = matches.first(where: { $0.id == matchId }) {
                            self.matchCalendarViewModel.selectedMatch(match: match)
                        }
                    }
                    .store(in: &matchCalendarViewModel.cancellables)
            }
        }
    }
}

/// Int64를 Identifiable로 만들기 위한 래퍼 구조체
struct Int64Identifier: Identifiable {
    let id: Int64
    init(_ id: Int64) { self.id = id }
}

#Preview {
    ContentView(isLoggedIn: .constant(true))
}
