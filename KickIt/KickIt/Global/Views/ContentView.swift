//
//  ContentView.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

/// 메인 네비게이션 설정 화면
struct ContentView: View {
    /// 사용자가 선택한 네비게이션 화면 tag 변수
    @State private var selectedMenu: Int = 1
    
    var body: some View {
        TabView(selection: $selectedMenu) {
            /// 홈 화면
            Home()
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(1)
            
            /// 경기 일정 & 캘린더 화면
            MatchCalendar()
                .tabItem {
                    Image(systemName: "soccerball")
                }
                .tag(2)
            
            /// 축구 경기 일기 화면
            SoccerDiary()
                .tabItem {
                    Image(systemName: "book")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
}
