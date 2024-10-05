//
//  ContentView.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

enum Tab {
    case home
    case calendar
    case diary
    case mypage
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
    
    // 탭바 색상 초기화
    init() {
        UITabBar.appearance().backgroundColor = UIColor.black0
    }
    
    var body: some View {
        TabView(selection: $selectedMenu) {
            /// 홈 화면
            Home(soccerMatch: dummySoccerMatches[0], selectedMenu: $selectedMenu, path: $path, viewModel: homeViewModel, calendarViewModel: matchCalendarViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                        .pretendardTextStyle(.Caption2Style)
                }
                .tag(Tab.home)
            
            /// 경기 일정 & 캘린더 화면
            MatchCalendar(path: $path, viewModel: matchCalendarViewModel)
                .tabItem {
                    Image(systemName: "soccerball")
                    Text("경기 캘린더")
                        .pretendardTextStyle(.Caption2Style)
                }
                .tag(Tab.calendar)
            
            /// 축구 경기 일기 화면
            SoccerDiary()
                .tabItem {
                    Image(systemName: "book")
                    Text("축구 일기")
                        .pretendardTextStyle(.Caption2Style)
                }
                .tag(Tab.diary)
            
            /// 마이페이지 화면
            MyPage()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("마이페이지")
                        .pretendardTextStyle(.Caption2Style)
                }
                .tag(Tab.mypage)
        }
    }
}

#Preview {
    ContentView()
}
