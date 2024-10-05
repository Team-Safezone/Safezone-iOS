//
//  MatchCalendar.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

/// 경기 일정 & 캘린더 화면
struct MatchCalendar: View {
    /// 네비게이션 경로
    @Binding var path: NavigationPath
    
    /// 현재 선택한 날짜
    @State var currentDate: Date = Date()
    
    /// 경기 캘린더 뷰모델
    @ObservedObject var viewModel = MatchCalendarViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(.background)
                
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: - 상단 정보
                    HStack(alignment: .top, spacing: 0) {
                        // MARK: 타이틀
                        VStack(alignment: .leading, spacing: 3) {
                            Text("경기 캘린더")
                                .font(.pretendard(.bold, size: 18))
                                .foregroundStyle(.white0)
                                .padding(.top, 60)
                            
                            // MARK: 프리미어리그 시즌
                            Text("프리미어리그 \(viewModel.soccerSeason) 시즌")
                                .pretendardTextStyle(.SubTitleStyle)
                                .foregroundStyle(.gray500Text)
                        }
                        
                        Spacer()
                        
                        // MARK: 랭킹 화면 이동 버튼
                        NavigationLink {
                            
                        } label: {
                            Image(.trophy)
                                .frame(width: 44, height: 44)
                                .padding(.top, 57)
                                .foregroundStyle(.lime)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // MARK: - 프리미어리그 팀 리스트
                    ScrollView(.horizontal) {
                        RadioButtonGroup(
                            // 팀 리스트 띄우기
                            items: viewModel.soccerTeamNames,
                            padding: 8,
                            selectedId: $viewModel.selectedRadioBtnID,
                            selectedTeamName: $viewModel.selectedTeamName,
                            callback: { previous, current, teamName in
                                // 팀 선택
                                viewModel.selectedTeam(teamName, id: current)
                                
                                // 한달 경기 일정 조회
                                getDayYearMonthSoccerMatches()
                                
                                // 하루 경기 일정 조회
                                getDailySoccerMatches()
                            }
                        )
                        .frame(height: 32)
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 20)
                    .scrollIndicators(.never)
                    
                    ScrollView(.vertical) {
                        // MARK: - 달력
                        CustomDatePicker(currentDate: $currentDate, matchDates: $viewModel.matchDates)
                            .onChange(of: currentDate) { preDate, newDate in
                                // 같은 달이라면
                                if (isSameMonth(date1: preDate, date2: newDate)) {
                                    // 하루 경기 일정 조회 API 연결
                                    getDailySoccerMatches()
                                }
                                // 다른 달이라면
                                else {
                                    // 한달 경기 날짜 조회 API 연결
                                    getDayYearMonthSoccerMatches()
                                }
                            }
                            .padding(.top, 20)
                        
                        // MARK: - 경기 일정 리스트
                        soccerMatchesView()
                            .padding(.top, 12)
                            .padding(.bottom, 32)
                    }
                    .scrollIndicators(.never)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .onAppear(perform: {
            // 초기 진입 시, 한달 경기 날짜 조회 API 호출
            getDayYearMonthSoccerMatches()
            
            // 하루 경기 일정 조회 API 연결
            getDailySoccerMatches()
        })
        .tint(.gray200)
        .navigationBarBackButtonHidden()
    }
    
    /// 하루 축구 경기 일정 불러오기
    private func getDailySoccerMatches() {
        viewModel.getDailySoccerMatches(
            request: SoccerMatchDailyRequest(
                date: dateToString4(date: currentDate),
                teamName: viewModel.selectedTeamName
            )
        )
    }
    
    /// 한달 축구 경기 일정 불러오기
    private func getDayYearMonthSoccerMatches() {
        viewModel.getYearMonthSoccerMatches(
            request: SoccerMatchMonthlyRequest(
                yearMonth: dateToString5(date: currentDate),
                teamName: viewModel.selectedTeamName
            )
        )
    }
    
    /// 경기 일정 리스트
    @ViewBuilder
    func soccerMatchesView() -> some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(spacing: 0) {
                Text("경기 일정")
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.gray200)
                
                Text("\(viewModel.soccerMatches.count)")
                    .pretendardTextStyle(.SubTitleStyle)
                    .foregroundStyle(.white0)
                    .padding(.leading, 4)
                
                Spacer()
                
                Text("\(dateToString2(date: currentDate))")
                    .pretendardTextStyle(.SubTitleStyle)
                    .foregroundStyle(.white0)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            // MARK: - 경기 리스트
            if !viewModel.soccerMatches.isEmpty {
                ForEach(viewModel.soccerMatches) { match in
                    NavigationLink {
                        SoccerMatchInfo(soccerMatch: match)
                            .toolbarRole(.editor) // back 텍스트 숨기기
                            .toolbar(.hidden, for: .tabBar) // 네비게이션 숨기기
                    } label: {
                        SoccerMatchRow(soccerMatch: match)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 12)
                    }
                }
            }
            else {
                Text("경기 일정이 없습니다.")
                    .pretendardTextStyle(.Body1Style)
                    .foregroundStyle(.gray500Text)
                    .padding(.top, 48)
                
                    // FIXME: api 연결 시, 아래 코드 삭제하기
                    ForEach(dummySoccerMatches) { match in
                        NavigationLink {
                            SoccerMatchInfo(soccerMatch: match)
                                .toolbarRole(.editor) // back 텍스트 숨기기
                                .toolbar(.hidden, for: .tabBar) // 네비게이션 숨기기
                        } label: {
                            SoccerMatchRow(soccerMatch: match)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 12)
                        }
                    }
            }
        }
    }
}

#Preview("경기 캘린더") {
    MatchCalendar(path: .constant(NavigationPath()))
}
