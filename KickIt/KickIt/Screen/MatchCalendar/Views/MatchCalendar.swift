//
//  MatchCalendar.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

/// 경기 일정 & 캘린더 화면
struct MatchCalendar: View {
    
    /// 현재 선택한 날짜
    @State var currentDate: Date = Date()
    
    /// 경기 정보 클릭 여부
    @State private var isMatchSelected = false
    
    /// 클릭한 경기 정보
    @State private var selectedMatch: SoccerMatch?
    
    /// 경기 캘린더 뷰모델
    @ObservedObject var viewModel = DefaultMatchCalendarViewModel()
    
    /// 라디오그룹에서 선택한 팀 아이디, 팀 이름 정보
    @State private var selectedRadioBtnID: Int = 0
    @State private var selectedTeamName: String? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background)
                
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: - 상단 정보
                    HStack(alignment: .top, spacing: 0) {
                        // MARK: 타이틀
                        VStack(alignment: .leading, spacing: 4) {
                            Text("경기 캘린더")
                                .font(.Title1)
                                .foregroundStyle(.black0)
                                .padding(.top, 60)
                            
                            // TODO: 홈 화면 API에서 시즌 정보 받아서 정보 동적으로 교체하기
                            Text("프리미어리그 2023-24 시즌")
                                .font(.SubTitle)
                                .foregroundStyle(.lime)
                                .padding(.top, 4)
                        }
                        
                        Spacer()
                        
                        // MARK: 랭킹 화면 이동 버튼
                        Image(.trophy)
                            .frame(width: 28, height: 28)
                            .padding(.top, 57)
                    }
                    .padding(.horizontal, 16)
                    
                    // MARK: - 프리미어리그 팀 리스트
                    ScrollView(.horizontal, showsIndicators: false) {
                        RadioButtonGroup(
                            // TODO: 홈에서 전달받은 팀 리스트 띄우기
                            items: ["전체", "맨시티", "아스널", "리버풀", "아스톤 빌라", "토트넘"],
                            selectedId: $selectedRadioBtnID,
                            selectedTeamName: $selectedTeamName,
                            callback: { previous, current, teamName in
                                selectedRadioBtnID = current
                                
                                if (selectedTeamName == "전체") {
                                    selectedTeamName = nil
                                }
                                else {
                                    selectedTeamName = teamName
                                }
                                
                                print("teamName 팀 이름 \(selectedTeamName ?? "null")")
                                requestYearMonthSoccerMatches(yearMonth: dateToString5(date: currentDate), teamName: selectedTeamName)
                                requestDaySoccerMatches(date: dateToString4(date: currentDate), teamName: selectedTeamName)
                            }
                        )
                        .frame(height: 32)
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                    
                    // MARK: - 달력
                    CustomDatePicker(currentDate: $currentDate, matchDates: $viewModel.monthlyMatchDates)
                        .onChange(of: currentDate) { preDate, newDate in
                            // 같은 달이라면
                            if (isSameMonth(date1: preDate, date2: newDate)) {
                                // 하루 경기 일정 조회 API 연결
                                requestDaySoccerMatches(date: dateToString4(date: currentDate), teamName: selectedTeamName)
                            }
                            // 다른 달이라면
                            else {
                                // 한달 경기 날짜 조회 API 연결
                                requestYearMonthSoccerMatches(yearMonth: dateToString5(date: currentDate), teamName: selectedTeamName)
                            }
                        }
                    
                    
                    // MARK: - 경기 일정 리스트
                    soccerMatchesView()
                        .background(
                            SpecificRoundedRectangle(radius: 30, corners: [.topLeft, .topRight])
                                .fill(.gray950)
                        )
                        .padding(.top, 12)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .onAppear(perform: {
            // 초기 진입 시, 한달 경기 날짜 조회 API 호출
            requestYearMonthSoccerMatches(yearMonth: dateToString5(date: currentDate), teamName: selectedTeamName)
        })
        .tint(.black0)
        .navigationBarBackButtonHidden()
    }
    
    /// 하루 축구 경기 일정 불러오기
    private func requestDaySoccerMatches(date: String, teamName: String?) {
        viewModel.requestDaySoccerMatches(date: date, teamName: teamName)
    }
    
    /// 한달 축구 경기 일정 불러오기
    private func requestYearMonthSoccerMatches(yearMonth: String, teamName: String?) {
        viewModel.requestYearMonthSoccerMatches(yearMonth: yearMonth, teamName: teamName)
    }
    
    /// 경기 일정 리스트
    @ViewBuilder
    func soccerMatchesView() -> some View {
        VStack(alignment: .center, spacing: 0) {
            // 인디케이터
            DragIndicator()
            
            HStack(spacing: 0) {
                Text("경기 일정")
                    .pretendardTextStyle(.SubTitleStyle)
                    .foregroundStyle(.gray200)
                
                Text("\(viewModel.soccerMatches.count)")
                    .pretendardTextStyle(.SubTitleStyle)
                    .foregroundStyle(.black0)
                    .padding(.leading, 6)
                
                Spacer()
                
                Text("\(dateToString2(date: currentDate))")
                    .pretendardTextStyle(.SubTitleStyle)
                    .foregroundStyle(.gray200)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            // MARK: - 경기 리스트
            // TODO: 뷰 적용 필요
            ScrollView(.vertical, showsIndicators: false) {
                if !viewModel.soccerMatches.isEmpty {
                    ForEach(viewModel.soccerMatches) { match in
                        SoccerMatchRow(soccerMatch: match)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 12)
                            .onTapGesture {
                                selectedMatch = match
                                isMatchSelected = true
                            }
                    }
                    // 경기 정보 화면으로 이동
                    .navigationDestination(isPresented: $isMatchSelected) {
                        if let match = selectedMatch {
                            SoccerMatchInfo(soccerMatch: match)
                                .toolbarRole(.editor) // back 텍스트 숨기기
                                .toolbar(.hidden, for: .tabBar) // 네비게이션 숨기기
                        }
                    }
                }
                else {
                    Text("경기 일정이 없습니다.")
                        .pretendardTextStyle(.Body1Style)
                        .foregroundStyle(.gray500)
                        .padding(.top, 52)

//                    // TODO: 없음으로 바꾸기
//                    ForEach(dummySoccerMatches) { match in
//                        SoccerMatchRow(soccerMatch: match)
//                            .padding(.horizontal, 16)
//                            .padding(.bottom, 12)
//                            .onTapGesture {
//                                selectedMatch = match
//                                isMatchSelected = true
//                            }
//                    }
//                    // 경기 정보 화면으로 이동
//                    .navigationDestination(isPresented: $isMatchSelected) {
//                        if let match = selectedMatch {
//                            SoccerMatchInfo(soccerMatch: match)
//                                
//                        }
//                    }
                }
            }
        }
    }
}

#Preview {
    MatchCalendar()
}
