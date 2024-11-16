//
//  ResultStartingLineupPrediction.swift
//  KickIt
//
//  Created by 이윤지 on 11/9/24.
//

import SwiftUI

/// 선발 라인업 예측 결과 화면
struct ResultStartingLineupPrediction: View {
    // MARK: - PROPERTY
    /// 1번 뒤로가기
    let popToOne: () -> Void
    
    /// 3번 뒤로가기
    let popToThreeStep: () -> Void
    
    /// 상단 카드뷰에 들어갈 데이터 모델
    var prediction: PredictionQuestionModel
    
    /// 뒤로가기 여부
    var isOneBack: Bool
    
    /// 뷰모델
    @StateObject var viewModel: ResultStartingLineupPredictionViewModel
    
    /// 타이머 뷰모델
    @StateObject var timerViewModel = TimerViewModel()
    
    /// 탭 바 애니메이션
    @Namespace private var animation
    
    init(popToOne: @escaping () -> Void, popToThreeStep: @escaping () -> Void, prediction: PredictionQuestionModel, isOneBack: Bool) {
        self.popToOne = popToOne
        self.popToThreeStep = popToThreeStep
        self.prediction = prediction
        self.isOneBack = isOneBack
        _viewModel = StateObject(wrappedValue: ResultStartingLineupPredictionViewModel(prediction: prediction))
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color(.backgroundDown)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                // MARK: 네비게이션 바
                ZStack {
                    // 중앙에 위치한 텍스트
                    Text("선발 라인업 예측")
                        .font(.pretendard(.semibold, size: 16))
                        .foregroundStyle(.white0)
                    
                    // 좌측 상단에 위치한 뒤로가기 버튼
                    HStack {
                        Button {
                            if isOneBack {
                                popToOne()
                            }
                            else {
                                popToThreeStep()
                            }
                        } label: {
                            Image(uiImage: .back)
                                .foregroundStyle(.white0)
                        }
                        .padding(.leading, -16)
                        
                        Spacer() // 오른쪽으로 공간 밀어내기
                    }
                    .padding(.leading) // 버튼을 좌측에 고정시키기 위해 여백 조정
                }
                
                // MARK: 상단 질문 카드 뷰
                PredictionQuestionView(
                    predictionType: 1, isRetry: true, matchCode: prediction.matchCode,
                    questionTitle: "선발 라인업 예측", question: "이번 경기에서 어떤 선발 라인업을 구성할까?",
                    matchDate: prediction.matchDate, matchTime: prediction.matchTime,
                    predictionUserNum: viewModel.participant, isResult: true, timerViewModel: timerViewModel)
                .padding(.top, 12)
                .padding(.horizontal, 16)
                
                // MARK: 상단 탭 바
                tabAnimate()
                    .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 0) {
                        // MARK: 결과 탭
                        if viewModel.selectedTab == .result {
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 100)
                            }
                            else {
                                // MARK: 홈팀
                                teamInfoView(true, viewModel.homeFormation ?? "-", viewModel.awayFormation ?? "-")
                                ZStack {
                                    soccerFiled(true)
                                    if let lineup = viewModel.homeLineups {
                                        lineups(isHomeTeam: true, for: viewModel.homeFormation ?? "", lineup: lineup)
                                    }
                                }
                                
                                // MARK: 원정팀
                                teamInfoView(false, viewModel.homeFormation ?? "", viewModel.awayFormation ?? "")
                                    .padding(.top, 60)
                                ZStack {
                                    soccerFiled(false)
                                    if let lineup = viewModel.awayLineups {
                                        lineups(isHomeTeam: false, for: viewModel.awayFormation ?? "", lineup: lineup)
                                    }
                                }
                            }
                        }
                        // MARK: 나의 예측
                        else if viewModel.selectedTab == .myPrediction {
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 100)
                            }
                            else {
                                // MARK: 홈팀
                                teamInfoView(
                                    true,
                                    formationToString(index: viewModel.userHomeFormation ?? 6),
                                    formationToString(index: viewModel.userAwayFormation ?? 6)
                                )
                                ZStack {
                                    soccerFiled(true)
                                    if let lineup = viewModel.userHomePrediction {
                                        predictionLineups(isHomeTeam: true, for: viewModel.userHomeFormation ?? -1, lineup: lineup)
                                    }
                                }
                                // 사용자의 홈팀 예측 성공 여부
                                resultView(viewModel.userPrediction?[0])
                                    .padding(.top, 8)
                                    .padding(.bottom, 20)
                                    .opacity(viewModel.userPrediction?.isEmpty == false && viewModel.userPrediction?[0] != nil ? 1 : 0)
                                
                                // MARK: 원정팀
                                teamInfoView(
                                    false,
                                    formationToString(index: viewModel.userHomeFormation ?? 6),
                                    formationToString(index: viewModel.userAwayFormation ?? 6)
                                )
                                ZStack {
                                    soccerFiled(false)
                                    if let lineup = viewModel.userAwayPrediction {
                                        predictionLineups(isHomeTeam: false, for: viewModel.userAwayFormation ?? -1, lineup: lineup)
                                    }
                                }
                                // 사용자의 원정팀 예측 성공 여부
                                resultView(viewModel.userPrediction?[1])
                                    .padding(.top, 8)
                            }
                        }
                        // MARK: 평균 예측
                        else {
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 100)
                            }
                            else {
                                // MARK: 홈팀
                                teamInfoView(
                                    true,
                                    formationToString(index: viewModel.avgHomeFormation ?? 6),
                                    formationToString(index: viewModel.avgAwayFormation ?? 6)
                                )
                                ZStack {
                                    soccerFiled(true)
                                    if let lineup = viewModel.avgHomePrediction {
                                        predictionLineups(isHomeTeam: true, for: viewModel.avgHomeFormation ?? -1, lineup: lineup)
                                    }
                                }
                                // 홈팀 평균 예측 성공 여부
                                resultView(viewModel.avgPrediction?[0])
                                    .padding(.top, 8)
                                    .padding(.bottom, 20)
                                    .opacity(viewModel.avgPrediction?.isEmpty == false && viewModel.avgPrediction?[0] != nil ? 1 : 0)
                                
                                // MARK: 원정팀
                                teamInfoView(
                                    false,
                                    formationToString(index: viewModel.avgHomeFormation ?? 6),
                                    formationToString(index: viewModel.avgAwayFormation ?? 6)
                                )
                                ZStack {
                                    soccerFiled(false)
                                    if let lineup = viewModel.avgAwayPrediction {
                                        predictionLineups(isHomeTeam: false, for: viewModel.avgAwayFormation ?? -1, lineup: lineup)
                                    }
                                }
                                // 원정팀 평균 예측 성공 여부
                                resultView(viewModel.avgPrediction?[1])
                                    .padding(.top, 8)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollIndicators(.never)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            timerViewModel.startLineupPredictionTimer(matchDate: prediction.matchDate, matchTime: prediction.matchTime, format: 1)
        }
        .onDisappear {
            timerViewModel.stopLineupTimer()
        }
    }
    
    // MARK: - FUNCTION
    /// 탭바 애니메이션
    @ViewBuilder
    private func tabAnimate() -> some View {
        VStack(spacing: 0) {
            ZStack {
                HStack(spacing: 0) {
                    ForEach(StartingLineupPredictionResultTabInfo.allCases, id: \.self) { item in
                        // 선발라인업 결과가 없을 경우, 결과 탭 띄우지 않기
                        if item != .result || viewModel.homeFormation != nil {
                            VStack(spacing: 0) {
                                Text(item.rawValue)
                                    .pretendardTextStyle(viewModel.selectedTab == item ? .SubTitleStyle : .Body2Style)
                                    .frame(maxWidth: .infinity/3, minHeight: 44, alignment: .center)
                                    .foregroundStyle(viewModel.selectedTab == item ? .limeText : .gray500Text)
                                    .background(Color.backgroundDown)
                                
                                if viewModel.selectedTab == item {
                                    Rectangle()
                                        .foregroundStyle(.limeText)
                                        .frame(height: 2)
                                        .matchedGeometryEffect(id: "info", in: animation)
                                }
                                else {
                                    Rectangle()
                                        .foregroundStyle(Color.backgroundDown)
                                        .frame(height: 2)
                                        .opacity(0)
                                        .background(.gray900Assets)
                                }
                            }
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    viewModel.selectedTab = item
                                }
                            }
                        }
                    }
                } //: HStack
            } //: ZStack
        } //: VStack
    }
    
    /// 팀 정보 뷰
    @ViewBuilder
    private func teamInfoView(_ isHomeTeam: Bool, _ homeFormation: String, _ awayFormation: String) -> some View {
        teamInfo(
            isHomeTeam,
            SoccerTeam(teamEmblemURL: prediction.homeTeam.teamEmblemURL, teamName: prediction.homeTeam.teamName),
            SoccerTeam(teamEmblemURL: prediction.awayTeam.teamEmblemURL, teamName: prediction.awayTeam.teamName),
            homeFormation,
            awayFormation
        )
    }
    
    /// 포메이션 이름 변환
    private func formationToString(index: Int) -> String {
        switch index {
        case 0: return "4-3-3"
        case 1: return "4-2-3-1"
        case 2: return "4-4-2"
        case 3: return "3-4-3"
        case 4: return "4-5-1"
        case 5: return "3-5-2"
        default: return "-"
        }
    }
}

// MARK: - PREVIEW
#Preview {
    ResultStartingLineupPrediction(popToOne: {}, popToThreeStep: {}, prediction: dummyPredictionQuestionModel, isOneBack: false)
}
