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
    /// 네비게이션 스택 관리 변수
    @State private var path: [NavigationDestination] = []
    
    /// 3번 뒤로가기
    func popToThreeStep() {
        path.removeLast(3)
    }
    
    /// 2번 뒤로가기
    func popToTwoStep() {
        path.removeLast(2)
    }
    
    /// 1번 뒤로가기
    func popToOneStep() {
        path.removeLast(1)
    }
    
    /// 사용자가 선택한 네비게이션 화면 tag 변수
    @State private var selectedMenu: Tab = .home
    
    /// 홈 뷰모델
    @StateObject var homeViewModel = HomeViewModel()
    
    /// 경기 캘린더 뷰모델
    @StateObject var matchCalendarViewModel = MatchCalendarViewModel()
    
    /// 선택된 경기 ID
    @State private var selectedMatchId: Int64?
    
    /// 홈 뷰 표시 여부
    @State private var showHomeView: Bool = false
    
    var body: some View {
        NavigationStack(path: $path) {
            TabView(selection: $selectedMenu) {
                /// 홈 화면
                Home(soccerMatch: dummySoccerMatches[0], selectedMenu: $selectedMenu, viewModel: homeViewModel, calendarViewModel: matchCalendarViewModel)
                    .tabItem {
                        Image(systemName: "house")
                        Text("홈").pretendardTextStyle(.Caption2Style)
                    }
                    .tag(Tab.home)
                
                /// 경기 일정 & 캘린더 화면
                MatchCalendar(viewModel: matchCalendarViewModel)
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
                MyPage()
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                        Text("마이페이지").pretendardTextStyle(.Caption2Style)
                    }
                    .tag(Tab.mypage)
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                if destination.identifier == "SoccerInfo" {
                    if case let .soccerInfo(data) = destination {
                        SoccerMatchInfo(soccerMatch: data)
                            .toolbarRole(.editor) // back 텍스트 숨기기
                            .toolbar(.hidden, for: .tabBar) // 네비게이션
                            .tint(.white0)
                    }
                }
                else if destination.identifier == "WinningTeamPrediction" {
                    if case let .winningTeamPrediction(data) = destination {
                        WinningTeamPrediction(isRetry: data.isRetry, soccerMatch: data.soccerMatch)
                            .toolbarRole(.editor)
                    }
                }
                else if destination.identifier == "FinishWinningTeamPrediction" {
                    if case let .finishWinningTeamPrediction(data) = destination {
                        FinishWinningTeamPrediction(
                            popToSoccerInfoAction: popToTwoStep,
                            winningPrediction: data.winningPrediction,
                            prediction: data.prediction)
                        .navigationBarBackButtonHidden()
                    }
                }
                else if destination.identifier == "ResultWinningTeamPrediction" {
                    if case let .resultWinningTeamPrediction(data) = destination {
                        ResultWinningTeamPrediction(
                            popToOne: popToOneStep,
                            popToThreeStep: popToThreeStep,
                            prediction: data.prediction,
                            isOneBack: data.isOneBack)
                            .toolbarRole(.editor)
                    }
                }
                .tag(Tab.mypage)
        }
    }
}

#Preview {
    ContentView()
}
