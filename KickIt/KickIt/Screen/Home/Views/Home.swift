//
//  Home.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

/// 홈 화면
struct Home: View {
    var soccerMatch: SoccerMatch
    
    /// 프리미어리그 팀 리스트
    @State private var soccerTeams: [SoccerTeam] = []
    
    /// 사용자가 선택한 축구 경기
    @State private var selectedMatch: SoccerMatch?
    
    /// 네비게이션 선택 변수
    @Binding var selectedMenu: Tab
    
    /// 홈 뷰모델
    @ObservedObject var viewModel: HomeViewModel
    
    /// 경기 캘린더 뷰모델
    @ObservedObject var calendarViewModel: MatchCalendarViewModel
    
    /// 알림 뷰모델
    @StateObject private var alertViewModel = AlertViewModel()
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 상단 헤더 뷰
                Header()
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 0) {
                        if viewModel.matchPredictions != nil {
                            if viewModel.matchDiarys != nil {
                                Text("진행 중인 경기 이벤트")
                                    .pretendardTextStyle(.H2Style)
                                    .foregroundStyle(.white0)
                                    .padding(.top, 16)
                                Text("참여하면 골을 얻을 수 있어요")
                                    .pretendardTextStyle(.Body2Style)
                                    .foregroundStyle(.gray500Text)
                            }
                        }
                        
                        // MARK: 경기 예측하기
                        if let predictions = viewModel.matchPredictions {
                            NavigationLink {
                                WinningTeamPrediction(
                                    isRetry: true,
                                    soccerMatch: SoccerMatch(
                                        id: predictions.matchId,
                                        matchDate: stringToDate(date: predictions.matchDate),
                                        matchTime: stringToTime(time: predictions.matchTime),
                                        stadium: "",
                                        matchRound: 0,
                                        homeTeam: predictions.homeTeam,
                                        awayTeam: predictions.awayTeam,
                                        matchCode: 0,
                                        homeTeamScore: 0,
                                        awayTeamScore: 0
                                    )
                                )
                                .toolbarRole(.editor) // back 텍스트 숨기기
                                .toolbar(.hidden, for: .tabBar) // 네비게이션 숨기기
                            } label: {
                                MatchEventCardView(match: predictions)
                                    .padding(.top, 16)
                            }
                        }
                        
                        // MARK: 일기 쓰기
                        if let diarys = viewModel.matchDiarys {
                            NavigationLink {
                                // TODO: 일기 쓰기 화면 연결
                            } label: {
                                DiaryEventCardView(match: diarys)
                                    .padding(.top, 12)
                            }
                        }
                        
                        // MARK: 경기 일정
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 7) {
                                    Text("나를 위한 경기 일정")
                                        .pretendardTextStyle(.H2Style)
                                        .foregroundStyle(.white0)
                                    
                                    // MARK: 선호하는 팀 이미지 리스트
                                    HStack(spacing: 0) {
                                        ForEach(0..<viewModel.favoriteImagesURL.count, id: \.self) { i in
                                            LoadableImage(image: viewModel.favoriteImagesURL[i])
                                                .clipShape(Circle())
                                                .frame(width: 24, height: 24)
                                        }
                                    }
                                }
                                
                                Text("내가 관심있는 팀의 경기 일정만 모아봐요")
                                    .pretendardTextStyle(.Body2Style)
                                    .foregroundStyle(.gray500Text)
                            }
                            .padding(.top, 20)
                            
                            // MARK: 경기 일정 리스트
                            if let matches = viewModel.matches {
                                VStack(spacing: 12) {
                                    ForEach(0..<(matches.count), id: \.self) {i in
                                        // 경기 정보 화면으로 이동
                                        NavigationLink(
                                            value: NavigationDestination.soccerInfo(data: matches[i])
                                        ) {
                                            MatchCardView(soccerMatch: matches[i])
                                                .onTapGesture {
                                                    calendarViewModel.selectedMatch(match: matches[i])
                                                }
                                        }
                                    }
                                }
                            }
                            // 경기 일정이 없을 경우
                            else {
                                VStack(alignment: .center, spacing: 0) {
                                    // FIXME: 추후 그래픽 이미지로 변경 필요
                                    Rectangle()
                                        .frame(width: 80, height: 80)
                                    
                                    Text("현재 선호하는 팀의 경기 일정이 없습니다")
                                        .pretendardTextStyle(.Body1Style)
                                        .foregroundStyle(.white0)
                                        .padding(.top, 16)
                                    
                                    Text("다른 팀의 경기 일정을 확인해 보시겠어요?")
                                        .pretendardTextStyle(.Body2Style)
                                        .foregroundStyle(.gray500Text)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 8)
                            }
                            
                            // MARK: 경기 더보기
                            Button {
                                withAnimation {
                                    // 경로를 초기화하고 새로운 경로로 이동
                                    selectedMenu = .calendar
                                }
                            } label: {
                                DesignHalfButton2(label: "경기 더보기", labelColor: .white0, btnBGColor: .background, img: .right)
                            }
                            .padding(.top, 8)
                            .padding(.bottom, 20)
                        } //: 경기 일정 리스트 VSTACK
                    } //: VSTACK
                    .padding(.horizontal, 16)
                } //: SCROLLVIEW
                .scrollIndicators(.never)
            } //: VSTACK
        } //: ZSTACK
        .tint(.gray200)
    }
    
    /// 상단 뷰
    @ViewBuilder
    func Header() -> some View {
        HStack(spacing: 0) {
            Text("LOGO")
                .font(.pretendard(.semibold, size: 20))
                .foregroundStyle(.white0)
            
            Spacer()
            
            HStack(spacing: 2){
                Image(uiImage: .coin)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24, alignment: .center)
                Text(viewModel.gradePoint.description)
                    .pretendardTextStyle(.SubTitleStyle)
                    .foregroundStyle(.white0)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            
            NavigationLink(destination: AlertView(viewModel: alertViewModel)) {
                Image(viewModel.hasNewAlerts ? "Alarm" : "AlarmOn")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .center)
            }
            .padding(10)
        }
        .padding(.horizontal, 16)
    }
}

#Preview("홈 화면") {
    Home(soccerMatch: dummySoccerMatches[0], selectedMenu: .constant(.home), viewModel: HomeViewModel(), calendarViewModel: MatchCalendarViewModel())
}
