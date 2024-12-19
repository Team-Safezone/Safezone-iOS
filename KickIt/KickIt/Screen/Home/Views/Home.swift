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
        ZStack(alignment: .top) {
            Color(.background)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 상단 헤더 뷰
                Header()
                
                // API 호출 중일 경우
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 300)
                }
                // API 호출이 완료됐다면
                else {
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
                                // 우승팀 예측 화면으로 이동
                                NavigationLink(value: NavigationDestination.winningTeamPrediction(data: WinningTeamPredictionNVData(isRetry: false, soccerMatch: SoccerMatch(
                                    id: predictions.matchId, matchDate: stringToDate(date: predictions.matchDate), matchTime: stringToTime(time: predictions.matchTime), stadium: "", matchRound: 0,
                                    homeTeam: predictions.homeTeam, awayTeam: predictions.awayTeam, matchCode: 0)))) {
                                    MatchEventCardView(match: predictions)
                                        .padding(.top, 16)
                                }
                            }
                            
                            // MARK: 일기 쓰기
                            if let diarys = viewModel.matchDiarys {
                                // 일기 쓰기 화면으로 이동
                                NavigationLink(value: NavigationDestination.createSoccerDiary(data: CreateSoccerDiaryNVData(match: SelectSoccerMatch(
                                    id: diarys.diaryId,
                                    matchDate: stringToDate(date: diarys.matchDate),
                                    matchTime: diarys.matchTime,
                                    homeTeamEmblemURL: diarys.homeTeam.teamEmblemURL,
                                    awayTeamEmblemURL: diarys.awayTeam.teamEmblemURL,
                                    homeTeamName: diarys.homeTeam.teamName,
                                    awayTeamName: diarys.awayTeam.teamName,
                                    homeTeamScore: 0,
                                    awayTeamScore: 0
                                ), isOneBack: 0))) {
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
                                                    .simultaneousGesture(TapGesture().onEnded {
                                                        // 화면 전환 전에 선택한 경기 업데이트
                                                        calendarViewModel.selectedMatch(match: matches[i])
                                                        print("버튼 클릭! 경기 정보로 이동!")
                                                    })
                                            }
                                        }
                                    }
                                }
                                // 경기 일정이 없을 경우
                                else {
                                    VStack(alignment: .center, spacing: 0) {
                                        Image(uiImage: .calendarDots)
                                            .resizable()
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
                }
            } //: VSTACK
        } //: ZSTACK
        .tint(.gray200)
    }
    
    /// 상단 뷰
    @ViewBuilder
    func Header() -> some View {
        HStack(spacing: 0) {
            Image(uiImage: .homeAppIcon)
                .resizable()
                .frame(width: 32, height: 32)
            
            Spacer()
            
            HStack(spacing: 2) {
                Image(uiImage: .coin)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                Text(viewModel.gradePoint.description)
                    .pretendardTextStyle(.Title2Style)
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
