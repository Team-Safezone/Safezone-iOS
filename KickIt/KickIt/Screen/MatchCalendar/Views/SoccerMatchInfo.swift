//
//  SoccerMatchInfo.swift
//  KickIt
//
//  Created by 이윤지 on 5/18/24.
//

import SwiftUI

/// 축구 경기 정보 화면
struct SoccerMatchInfo: View {
    // MARK: - PROPERTY
    /// 사용자가 선택한 경기 객체
    var soccerMatch: SoccerMatch
    
    /// 경기 캘린더 뷰모델
    @StateObject var viewModel = MatchCalendarViewModel()
    
    /// 경기 예측 조회 뷰모델
    @StateObject var predictionViewModel = PredictionButtonViewModel()
    
    /// 경기 정보 텍스트 버튼 클릭 상태 여부
    @State private var isShowMatchInfo = true
    
    /// 오늘 날짜
    @State private var nowDate = Date()
    
    /// 타이머 뷰모델
    @StateObject private var timerViewModel = TimerViewModel()
    
    // MARK: - BODY
    var body: some View {
        ZStack(alignment: .top) {
            // 배경화면 색상 지정
            Color(.gray950Assets)
                .ignoresSafeArea(edges: .bottom)
            Color(.background)
                .ignoresSafeArea(edges: .top)
            
            VStack(spacing: 0) {
                // MARK: 상단 경기 정보
                TopMatchInfo()
                
                // 구분선
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.gray900Assets)
                
                ScrollView {
                    VStack(spacing: 0) {
                        // MARK: 팀 및 스코어 정보
                        CenterMatchInfo()
                        
                        ZStack {
                            // 하단 시트 색상 지정
                            SpecificRoundedRectangle(radius: 16, corners: [.topLeft, .topRight])
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.gray950Assets)
                            
                            VStack(spacing: 0) {
                                // MARK: 하단 버튼
                                MatchButton()
                                
                                // 경기 정보 버튼을 눌렀다면
                                if isShowMatchInfo {
                                    // MARK: 경기 정보
                                    MatchInfo()
                                    
                                    // 하단 공백
                                    Spacer()
                                        .frame(height: 200)
                                }
                                // 경기 예측 버튼을 눌렀다면
                                else {
                                    // MARK: 경기 예측
                                    MatchPrediction()
                                }
                            }
                        }
                        .padding(.top, 55)
                    } //: VSTACK
                } //: ScrollView
                .scrollIndicators(.never)
                .onAppear {
                    UIScrollView.appearance().bounces = false
                }
                .onDisappear {
                    UIScrollView.appearance().bounces = true
                }
            } //: VSTACK
        } //: ZSTACK
        .navigationTitle("\(soccerMatch.homeTeam.teamName) VS \(soccerMatch.awayTeam.teamName)")
        .tint(.white0)
    }
    
    // MARK: - FUNCTION
    /// 상단 경기 정보
    @ViewBuilder
    private func TopMatchInfo() -> some View {
        HStack(spacing: 5) {
            // 장소
            HStack(spacing: 4) {
                Image(uiImage: .mapPin)
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.gray500)
                
                Text("\(soccerMatch.stadium)")
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.gray200)
            }
            
            // 구분선
            RoundedRectangle(cornerRadius: 8)
                .rotation(Angle(degrees: 90))
                .fill(.gray500Text)
                .frame(width: 14, height: 1)
            
            // 라운드
            Text("\(soccerMatch.matchRound)R")
                .pretendardTextStyle(.SubTitleStyle)
                .foregroundStyle(.gray200)
            
            Spacer()
            
            // 경기 상태
            Text(soccerMatchLabel().0)
                .pretendardTextStyle(.Body3Style)
                .foregroundStyle(soccerMatchLabelColor().0)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(soccerMatchLabelColor().1, lineWidth: 2)
                )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.background)
    }
    
    /// 중앙의 팀 및 경기 정보
    @ViewBuilder
    private func CenterMatchInfo() -> some View {
        // MARK: 팀 정보 및 경기 날짜 정보
        HStack(alignment: .center) {
            // MARK: 홈팀
            VStack(alignment: .center, spacing: 0) {
                // 홈팀 엠블럼 이미지
                LoadableImage(image: soccerMatch.homeTeam.teamEmblemURL)
                    .frame(width: 88, height: 88)
                    .clipShape(Circle())
                
                HStack(spacing: 0) {
                    Image(uiImage: .homeTeam)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.gray500Text)
                    
                    // 팀 명
                    Text("\(soccerMatch.homeTeam.teamName)")
                        .pretendardTextStyle(.Body1Style)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white0)
                }
                .padding(.top, 8)
                .frame(width: 88, alignment: .center)
            }
            
            Spacer()
            
            // MARK: 경기 날짜&시간
            VStack(spacing: 2) {
                Text("\(dateToString2(date: soccerMatch.matchDate))")
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.white0)
                
                Text("\(timeToString(time: soccerMatch.matchTime))")
                    .pretendardTextStyle(.H2Style)
                    .foregroundStyle(.white0)
            }
            
            Spacer()
            
            // MARK: 원정 팀
            VStack(alignment: .center, spacing: 0) {
                // 원정 팀 엠블럼 이미지
                LoadableImage(image: soccerMatch.awayTeam.teamEmblemURL)
                    .frame(width: 88, height: 88)
                    .clipShape(Circle())
                
                // 팀 명
                Text("\(soccerMatch.awayTeam.teamName)")
                    .multilineTextAlignment(.center)
                    .pretendardTextStyle(.Body1Style)
                    .foregroundStyle(.white0)
                    .padding(.top, 8)
            }
            .frame(width: 88, alignment: .center)
        }
        .padding(.horizontal, 36)
        .padding(.top, 69)
        
        // MARK: - 스코어
        HStack(spacing: 0) {
            // 홈 팀 스코어
            Text("\(soccerMatch.homeTeamScore?.description ?? "-")")
                .font(.pretendard(.semibold, size: 30))
                .frame(width: 40)
            
            Spacer()
            
            // 원정 팀 스코어
            Text("\(soccerMatch.awayTeamScore?.description ?? "-")")
                .font(.pretendard(.semibold, size: 30))
                .frame(width: 40)
        }
        .foregroundStyle(soccerMatch.homeTeamScore == nil ? .gray500 : .white0)
        .padding(.top, 30)
        .padding(.horizontal, 60)
    }
    
    /// 경기 정보&경기 예측 버튼
    @ViewBuilder
    private func MatchButton() -> some View {
        VStack(spacing: 4) {
            Circle()
                .frame(width: 6, height: 6)
                .foregroundStyle(.lime)
                .offset(x: isShowMatchInfo ? -41 : 41) // 이동할 거리 설정
                .animation(.easeInOut(duration: 0.3), value: isShowMatchInfo)
            
            HStack(alignment: .center, spacing: 16) {
                Button {
                    withAnimation {
                        isShowMatchInfo = true
                    }
                } label: {
                    Text("경기 정보")
                        .pretendardTextStyle(viewModel.updateTextStyle(isShowMatchInfo: isShowMatchInfo))
                        .foregroundStyle(viewModel.updateTextColor(isShowMatchInfo: isShowMatchInfo))
                        .animation(.easeInOut(duration: 0.3), value: isShowMatchInfo) // 애니메이션 추가
                }
                
                Button {
                    withAnimation {
                        isShowMatchInfo = false
                        
                        // 경기 예측 조회 API 호출
                        predictionViewModel.getPredictionButtonClick(request: MatchIdRequest(matchId: soccerMatch.id))
                    }
                } label: {
                    Text("경기 예측")
                        .pretendardTextStyle(viewModel.updateTextStyle(isShowMatchInfo: !isShowMatchInfo))
                        .foregroundStyle(viewModel.updateTextColor(isShowMatchInfo: !isShowMatchInfo))
                        .animation(.easeInOut(duration: 0.3), value: !isShowMatchInfo) // 애니메이션 추가
                }
            }
        } //: VSTACK
        .padding(.top, 16)
    }
    
    /// 선발 라인업 버튼
    @ViewBuilder
    private func startingLineupButton() -> some View {
        ZStack {
            Image(uiImage: .matchInfoCard)
                .resizable()
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Text("선발 라인업")
                        .pretendardTextStyle(.Title2Style)
                        .foregroundStyle(.whiteAssets)
                    
                    Image(uiImage: .careRight)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.whiteAssets)
                }
                
                HStack {
                    Spacer()
                    Image(uiImage: .lineup)
                }
            }
            .padding(.top, 12)
            .padding(.leading, 12)
            
            // Overlay
            // 선발라인업 공개 전이라면
            if !timerViewModel.isShowLineup {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.16, green: 0.16, blue: 0.18))
                    .opacity(0.8)
            }
            
            // 선발라인업 공개 전이라면
            if !timerViewModel.isShowLineup {
                Text(timerViewModel.showLineupEndTime)
                    .pretendardTextStyle(.SubTitleStyle)
                    .foregroundStyle(.white0)
            }
        }
        .cardShadow()
    }
    
    /// 경기 정보
    @ViewBuilder
    private func MatchInfo() -> some View {
        HStack(spacing: 13) {
            // MARK: 경기 타임라인 버튼
            NavigationLink {
                TimelineEventView(match: soccerMatch)
                    .toolbarRole(.editor) // back 텍스트 숨기기
            } label: {
                ZStack {
                    Image(uiImage: .timelineCard)
                        .resizable()
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .center, spacing: 0) {
                            Text("경기 타임라인")
                                .pretendardTextStyle(.Title2Style)
                                .foregroundStyle(.whiteAssets)
                            
                            Image(uiImage: .careRight)
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.whiteAssets)
                        }
                        
                        Text(soccerMatchLabel().1)
                            .pretendardTextStyle(.Body3Style)
                            .foregroundStyle(.whiteAssets)
                        
                        Image(uiImage: .soccerObjects)
                    }
                    .padding(12)
                }
                .cardShadow()
            }
            
            VStack(spacing: 16) {
                // MARK: 선발 라인업 버튼
                // 선발라인업 공개 시간이 됐다면
                if timerViewModel.isShowLineup {
                    NavigationLink {
                        StartingLineup(soccerMatch: soccerMatch)
                            .toolbarRole(.editor) // back 텍스트 숨기기
                    } label: {
                        startingLineupButton()
                    }
                }
                // 선발라인업 공개 전이라면
                else {
                    startingLineupButton()
                        .disabled(true) // 클릭 비활성화
                }
                
                // MARK: 심박수 통계 버튼
                NavigationLink {
                    HeartRateView(match: soccerMatch)
                        .toolbarRole(.editor) // back 텍스트 숨기기
                } label: {
                    ZStack {
                        Image(uiImage: .matchInfoCard)
                            .resizable()
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(alignment: .center, spacing: 0) {
                                Text("심박수 통계")
                                    .pretendardTextStyle(.Title2Style)
                                    .foregroundStyle(.whiteAssets)
                                
                                Image(uiImage: .careRight)
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(.whiteAssets)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Spacer()
                                Image(uiImage: .chart)
                                    .padding(.trailing, 10)
                            }
                        }
                        .padding(.top, 12)
                        .padding(.leading, 12)
                        
                        if soccerMatch.matchCode != 3 {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 0.16, green: 0.16, blue: 0.18))
                                .opacity(0.8)
                        }
                        
                        if soccerMatch.matchCode != 3 {
                            Text("경기 종료 후 공개")
                                .pretendardTextStyle(.SubTitleStyle)
                                .foregroundStyle(.whiteAssets)
                        }
                    }
                    .cardShadow()
                }
            }
        }
        .onAppear {
            timerViewModel.startingLineupTimer(matchDate: soccerMatch.matchDate, matchTime: soccerMatch.matchTime)
        }
        .onDisappear {
            timerViewModel.stopLineupTimer()
        }
        .padding(.top, 32)
        .padding(.horizontal, 16)
    }
    
    /// 경기 예측
    @ViewBuilder
    private func MatchPrediction() -> some View {
        VStack(spacing: 0) {
            let prediction = PredictionQuestionModel(
                matchId: soccerMatch.id,
                matchCode: soccerMatch.matchCode,
                matchDate: soccerMatch.matchDate,
                matchTime: soccerMatch.matchTime,
                homeTeam: soccerMatch.homeTeam,
                awayTeam: soccerMatch.awayTeam
            )
            
            // 우승팀 예측이 종료된 경우
            if timerViewModel.isWinningTeamPredictionFinished {
                // 우승팀 예측 결과 화면으로 이동
                NavigationLink(value: NavigationDestination.resultWinningTeamPrediction(
                    data: ResultPredictionNVData(prediction: prediction, isOneBack: true))) {
                    MatchPredictionView(
                        soccerMatch: soccerMatch,
                        viewModel: viewModel,
                        pViewModel: predictionViewModel,
                        timerViewModel: timerViewModel
                    )
                }
            }
            // 우승팀 예측이 종료되지 않은 경우
            else {
                // 우승팀 예측을 한 경우
                if (predictionViewModel.matchPrediction.isParticipated) {
                    // 우승팀 예측 결과 화면으로 이동
                    NavigationLink(value: NavigationDestination.resultWinningTeamPrediction(
                        data: ResultPredictionNVData(prediction: prediction, isOneBack: true))) {
                        MatchPredictionView(
                            soccerMatch: soccerMatch,
                            viewModel: viewModel,
                            pViewModel: predictionViewModel,
                            timerViewModel: timerViewModel
                        )
                    }
                }
                // 우승팀 예측을 안 한 경우
                else {
                    // 우승팀 에측 화면으로 이동
                    NavigationLink(value: NavigationDestination.winningTeamPrediction(data: WinningTeamPredictionNVData(isRetry: false, soccerMatch: soccerMatch))) {
                        MatchPredictionView(
                            soccerMatch: soccerMatch,
                            viewModel: viewModel,
                            pViewModel: predictionViewModel,
                            timerViewModel: timerViewModel
                        )
                    }
                }
            }
            
            // 연결선
            HStack(spacing: 24) {
                Rectangle()
                    .foregroundStyle(.limeTransparent)
                    .frame(width: 2, height: 8)
                Spacer()
                Rectangle()
                    .foregroundStyle(.limeTransparent)
                    .frame(width: 2, height: 8)
            }
            .padding(.horizontal, 24)
            
            // 선발라인업 예측이 종료된 경우
            if timerViewModel.isLineupPredictionFinished {
                // 선발라인업 예측 완료 화면으로 이동
                NavigationLink(value: NavigationDestination.resultLineupPrediction(
                    data: ResultPredictionNVData(prediction: prediction, isOneBack: true))) {
                    LineupPredictionView(
                        soccerMatch: soccerMatch,
                        viewModel: viewModel,
                        pViewModel: predictionViewModel,
                        timerViewModel: timerViewModel
                    )
                }
            }
            // 선발라인업 예측이 종료되지 않은 경우
            else {
                // 선발라인업 예측을 한 경우
                if (predictionViewModel.lineupPrediction.isParticipated) {
                    // 선발라인업 예측 결과 화면으로 이동
                    NavigationLink(value: NavigationDestination.resultLineupPrediction(
                        data: ResultPredictionNVData(prediction: prediction, isOneBack: true))) {
                        LineupPredictionView(
                            soccerMatch: soccerMatch,
                            viewModel: viewModel,
                            pViewModel: predictionViewModel,
                            timerViewModel: timerViewModel
                        )
                    }
                }
                // 선발라인업 예측을 안 한 경우
                else {
                    // 선발라인업 예측 화면으로 이동
                    NavigationLink(value: NavigationDestination.lineupPrediction(data: soccerMatch)) {
                        LineupPredictionView(
                            soccerMatch: soccerMatch,
                            viewModel: viewModel,
                            pViewModel: predictionViewModel,
                            timerViewModel: timerViewModel
                        )
                    }
                }
            }
        }
        .onAppear {
            timerViewModel.winningTeamPredictionTimer(matchDate: soccerMatch.matchDate, matchTime: soccerMatch.matchTime, format: 0)
            timerViewModel.startLineupPredictionTimer(matchDate: soccerMatch.matchDate, matchTime: soccerMatch.matchTime, format: 0)
        }
        .onDisappear {
            timerViewModel.stopWinningTeamTimer()
            timerViewModel.stopLineupPredictionTimer()
        }
        .padding(16)
        .padding(.bottom, 30)
    }
    
    /// 경기 상태에 따른 경기 텍스트&배경 색상 값을 반환하는 함수
    private func soccerMatchLabelColor() -> (Color, Color) {
        switch (soccerMatch.matchCode) {
        case 0: return (.white0, .gray500)
        case 1: return (.lime, .lime)
        case 3: return (.gray500Text, .gray800)
        case 4: return (.gray500Text, .gray800)
        default: return (.white0, .gray500)
        }
    }
    
    /// 경기 상태 텍스트&타임라인 텍스트 값을 반환하는 함수
    private func soccerMatchLabel() -> (String, String) {
        switch (soccerMatch.matchCode) {
        case 0: return ("경기 예정", "아직 시작 전이에요")
        case 1: return ("경기중", "실시간 업데이트 중")
        case 3: return ("경기 종료", "업데이트 완료")
        case 4: return ("경기 연기", "경기가 연기됐어요")
        default: return ("경기 예정", "아직 시작 전이에요")
        }
    }
}

// MARK: - PREVIEW
#Preview("경기 정보") {
    SoccerMatchInfo(soccerMatch: dummySoccerMatches[0], viewModel: MatchCalendarViewModel())
}
