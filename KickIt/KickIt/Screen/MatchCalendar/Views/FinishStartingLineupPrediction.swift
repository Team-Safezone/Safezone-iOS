//
//  FinishStartingLineupPrediction.swift
//  KickIt
//
//  Created by 이윤지 on 11/9/24.
//

import SwiftUI

/// 선발라인업 예측 완료 화면
struct FinishStartingLineupPrediction: View {
    /// 경기 정보 화면으로 이동 함수
    let popToSoccerInfoAction: () -> Void
    
    /// 우승팀 예측 모델 객체
    var lineupPrediction: LineupPrediction
    
    /// 상단 카드뷰에 들어갈 데이터 모델
    var prediction: PredictionQuestionModel
    
    var body: some View {
        ZStack {
            Color(.backgroundDown)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                Text("예측 완료")
                    .pretendardTextStyle(.H1Style)
                    .foregroundStyle(.white0)
                    .padding(.top, 131)
                
                // MARK: 예측 결과
                Text("과연 누구의 라인업이 더 강할까요?")
                    .pretendardTextStyle(.Title2Style)
                    .foregroundStyle(.gray500Text)
                    .padding(.top, 12)
                
                // MARK: 획득 포인트
                HStack(spacing: 4) {
                    Text("+")
                        .pretendardTextStyle(.Title1Style)
                        .foregroundStyle(.lime)
                    
                    Text("1")
                        .pretendardTextStyle(.Title1Style)
                        .foregroundStyle(.lime)
                    
                    Text("골")
                        .pretendardTextStyle(.Body1Style)
                        .foregroundStyle(.gray200)
                }
                .padding(.top, 22)
                
                // MARK: 그래픽 이미지
                Image(uiImage: .coin)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.top, 8)
                
                Spacer()
                
                // MARK: 내 등급 박스
                VStack(alignment: .leading, spacing: 12) {
                    Text("내 등급")
                        .pretendardTextStyle(.Body2Style)
                        .foregroundStyle(.gray200)
                    
                    HStack(alignment: .center, spacing: 0) {
                        Image(uiImage: matchToGrade(lineupPrediction.grade).0)
                            .resizable()
                            .frame(width: 44, height: 44)
                        
                        Text(matchToGrade(lineupPrediction.grade).1)
                            .padding(.leading, 4)
                            .pretendardTextStyle(.Title2Style)
                            .foregroundStyle(.white0)
                        
                        Spacer()
                        
                        Text("\(lineupPrediction.point)")
                            .pretendardTextStyle(.Title1Style)
                            .foregroundStyle(.white0)
                            .padding(.trailing, 4)
                        
                        Text("골")
                            .pretendardTextStyle(.Body1Style)
                            .foregroundStyle(.gray200)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 18)
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
                        // 경기 정보 화면으로 이동
                        popToSoccerInfoAction()
                    } label: {
                        DesignHalfButton(label: "닫기", labelColor: .white0, btnBGColor: .gray900Assets)
                    }
                    
                    // MARK: 예측 결과보기 버튼
                    NavigationLink(value: NavigationDestination.resultLineupPrediction(data: ResultPredictionNVData(
                        prediction: prediction,
                        isOneBack: false))) {
                        DesignHalfButton(label: "결과보기", labelColor: .blackAssets, btnBGColor: .green0)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 34)
            }
        }
    }
    
    /// grade code에 따른 이미지와 텍스트 값 반환 함수
    private func matchToGrade(_ code: Int) -> (UIImage, String) {
        switch code {
        case 1: return (.ball0, "루키")
        case 2: return (.ball1, "브론즈")
        case 3: return (.ball2, "실버")
        case 4: return (.ball3, "골드")
        case 5: return (.ball4, "다이아몬드")
        default: return (.ball0, "루키")
        }
    }
}

#Preview {
    FinishStartingLineupPrediction(popToSoccerInfoAction: {}, lineupPrediction: dummyLineupPrediction, prediction: dummyPredictionQuestionModel)
}
