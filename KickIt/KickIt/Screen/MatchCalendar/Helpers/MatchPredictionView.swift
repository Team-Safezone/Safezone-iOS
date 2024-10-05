//
//  MatchPredictionView.swift
//  KickIt
//
//  Created by 이윤지 on 10/5/24.
//

import SwiftUI

/// 경기 정보 화면에서 사용되는 우승팀 예측하기 레이아웃
struct MatchPredictionView: View {
    // MARK: - PROPERTY
    @ObservedObject var viewModel: MatchCalendarViewModel
    
    /// 현재 날짜 및 시간
    @State private var nowDate = Date()
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.grayCard)
                .stroke(.limeTransparent, lineWidth: 1)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    // 질문
                    VStack(alignment: .leading) {
                        Text("이번 경기 결과는?")
                            .pretendardTextStyle(.Title2Style)
                            .foregroundStyle(.white0)
                        HStack(spacing: 4) {
                            switch viewModel.selectedSoccerMatch?.matchCode {
                            // 예정
                            case 0:
                                Text("진행중")
                                    .pretendardTextStyle(.Body3Style)
                                    .foregroundStyle(.limeText)
                                
                                Text(timePredictionInterval3(nowDate: nowDate, matchDate: viewModel.selectedSoccerMatch!.matchDate, matchTime: viewModel.selectedSoccerMatch!.matchTime))
                                    .pretendardTextStyle(.Body3Style)
                                    .foregroundStyle(.white0)
                                    .onAppear {
                                        startTimer()
                                    }
                            // 경기중, 휴식, 종료
                            case 1, 2, 3:
                                Text("예측 종료")
                                    .pretendardTextStyle(.Body3Style)
                                    .foregroundStyle(.gray300)
                                // TODO: 경기 예측 뷰모델 변경
                                Text("300명 참여")
                                    .pretendardTextStyle(.Body3Style)
                                    .foregroundStyle(.white0)
                            // 연기
                            case 4:
                                EmptyView()
                            default:
                                EmptyView()
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 참여여부
                    ZStack {
                        Image(uiImage: .dashCircle)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.gray800Btn)
                        Text("참여")
                            .pretendardTextStyle(.Caption2Style)
                            .foregroundStyle(.gray500Text)
                    }
                    
                } //: HSTACK
                
                // 실시간 예측
                HStack(spacing: 4) {
                    Rectangle()
                        .foregroundStyle(.gray800)
                        .frame(height: 1)
                    Text("실시간 예측")
                        .pretendardTextStyle(.Body3Style)
                        .foregroundStyle(.gray300)
                    Rectangle()
                        .foregroundStyle(.gray800)
                        .frame(height: 1)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                
                HStack {
                    // 홈팀
                    VStack(spacing: 6) {
                        LoadableImage(image: (viewModel.selectedSoccerMatch?.homeTeam.teamEmblemURL)!)
                            .frame(width: 54, height: 54)
                        Text((viewModel.selectedSoccerMatch?.homeTeam.teamName)!)
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(.white0)
                            .frame(width: 54)
                    }
                    
                    Spacer()
                    
                    // 각팀 우승 확률
                    HStack(spacing: 10) {
                        Text("90%")
                            .pretendardTextStyle(.H1Style)
                            .foregroundStyle(.limeText)
                        
                        Text("VS")
                            .pretendardTextStyle(.Title2Style)
                            .foregroundStyle(.white0)
                        
                        Text("10%")
                            .pretendardTextStyle(.H1Style)
                            .foregroundStyle(.gray300)
                    }
                    
                    Spacer()
                    
                    // 원정팀
                    VStack(spacing: 6) {
                        LoadableImage(image: (viewModel.selectedSoccerMatch?.awayTeam.teamEmblemURL)!)
                            .frame(width: 54, height: 54)
                        Text((viewModel.selectedSoccerMatch?.awayTeam.teamName)!)
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(.white0)
                            .frame(width: 54)
                    }
                }
                .padding(.horizontal, 8)
                
                // 버튼
                Button {
                    
                } label: {
                    Text("참여하기")
                        .pretendardTextStyle(.SubTitleStyle)
                        .foregroundStyle(.blackAssets)
                }
                .padding(.vertical, 11)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundStyle(.lime)
                )
                .padding(.top, 16)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
        }
    }
    
    // MARK: - FUNCTION
    /// 예측 종료 마감까지의 시간 계산
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.nowDate = Date()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    MatchPredictionView(viewModel: MatchCalendarViewModel())
}
