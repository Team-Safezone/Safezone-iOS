//
//  FinishWinningTeamPrediction.swift
//  KickIt
//
//  Created by 이윤지 on 6/9/24.
//

import SwiftUI

/// 우승팀 예측 완료 화면
struct FinishWinningTeamPrediction: View {
    /// 우승팀 예측 모델 객체
    var winningPrediction: WinningPrediction
    
    /// 뒤로가기 변수
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(.background)
            
            VStack(alignment: .center, spacing: 0) {
                Text("예측 완료")
                    .pretendardTextStyle(.H1Style)
                    .foregroundStyle(.white)
                    .padding(.top, 175)
                
                // MARK: 예측 결과
                HStack(spacing: 0) {
                    // 홈팀의 우승을 예상했다면
                    if (winningPrediction.homeTeamScore > winningPrediction.awayTeamScore) {
                        Text("\(winningPrediction.homeTeamName)의 승리를 예측하셨네요!")
                            .pretendardTextStyle(.Title2Style)
                            .foregroundStyle(.gray500)
                    }
                    // 원정팀의 우승을 예상했다면
                    else if (winningPrediction.homeTeamScore < winningPrediction.awayTeamScore) {
                        Text("\(winningPrediction.awayTeamName)의 승리를 예측하셨네요!")
                            .pretendardTextStyle(.Title2Style)
                            .foregroundStyle(.gray500)
                    }
                    // 무승부를 예상했다면
                    else {
                        Text("\(winningPrediction.homeTeamName)와 \(winningPrediction.awayTeamName)의 무승부를 예측하셨네요!")
                            .pretendardTextStyle(.Title2Style)
                            .foregroundStyle(.gray500)
                    }
                }
                .padding(.top, 12)
                
                // MARK: 획득 포인트
                HStack(spacing: 4) {
                    Text("+")
                        .pretendardTextStyle(.Title1Style)
                        .foregroundStyle(.lime)
                    
                    Text("1")
                        .pretendardTextStyle(.Title1Style)
                        .foregroundStyle(.lime)
                    
                    Text("GOAL")
                        .pretendardTextStyle(.Body1Style)
                        .foregroundStyle(.gray200)
                }
                .padding(.top, 22)
                
                // MARK: 그래픽 이미지
                Image(uiImage: .coin)
                    .padding(.top, 8)
                
                Spacer()
                
                // MARK: 내 등급 박스
                VStack(alignment: .leading, spacing: 12) {
                    Text("내 등급")
                        .pretendardTextStyle(.Body2Style)
                        .foregroundStyle(.gray200)
                    
                    HStack(alignment: .center, spacing: 0) {
                        Image(uiImage: .rubberBall)
                        
                        Text("탱탱볼")
                            .padding(.leading, 16)
                            .pretendardTextStyle(.Title2Style)
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Text("10")
                            .pretendardTextStyle(.Title1Style)
                            .foregroundStyle(.lime)
                            .padding(.trailing, 4)
                        
                        Text("GOAL")
                            .pretendardTextStyle(.Body1Style)
                            .foregroundStyle(.gray200)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray950)
                        .stroke(.gray900, style: StrokeStyle(lineWidth: 1))
                )
                .padding(.horizontal, 37)
                .padding(.bottom, 30)
                
                Spacer()
                
                HStack(spacing: 13) {
                    // MARK: 닫기 버튼
                    Button {
                        dismiss()
                    } label: {
                        DesignHalfButton(label: "닫기", labelColor: Color.white, btnBGColor: Color.gray900)
                    }
                    
                    // MARK: 예측 결과보기 버튼
                    Button {
                        
                    } label: {
                        DesignHalfButton(label: "결과보기", labelColor: Color.black, btnBGColor: Color.green0)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 34)
            }
        }
        .ignoresSafeArea(edges: .all)
    }
}

#Preview {
    FinishWinningTeamPrediction(winningPrediction: dummyWinningPrediction)
}
