//
//  WinningTeamPrediction.swift
//  KickIt
//
//  Created by 이윤지 on 5/26/24.
//

import Charts
import SwiftUI

/// 우승팀 예측 화면
struct WinningTeamPrediction: View {
    /// 축구 경기 객체
    var soccerMatch: SoccerMatch
    
    /// 뒤로가기 버튼을 위한 변수
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        
    /// 클릭 이벤트 변수
    @State private var clickHomeTeam = false
    
    /// 무승부 클릭 변수
    @State private var clickDraw = false
    
    /// 원정팀 클릭 변수
    @State private var clickAwayTeam = false
    
    var body: some View {
        ZStack {
            Color(.gray50)
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 8) {
                    Spacer()
                    
                    Image(systemName: "soccerball")
                        .font(.system(size: 24))
                        .foregroundStyle(.gray600)
                    
                    Image(systemName: "soccerball")
                        .font(.system(size: 24))
                        .foregroundStyle(.gray400)
                    
                    Image(systemName: "soccerball")
                        .font(.system(size: 24))
                        .foregroundStyle(.gray400)
                    
                    Spacer()
                }
                .padding(.top, 60)
                
                // 예측을 한 경우
                if clickHomeTeam || clickAwayTeam || clickDraw {
                    Text("승리 팀 예측 완료!")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.gray600)
                        .padding(.top, 56)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                // 예측을 안 한 경우
                else {
                    Text("우승 팀 예측하기")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.black)
                        .padding(.top, 56)
                        .padding(.leading, 30)
                    
                    Text("이번 경기에서 어느 팀이 승리할까요?")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.black)
                        .padding(.top, 10)
                        .padding(.leading, 30)
                }
                
                // 예측한 우승 팀 정보
                VStack(alignment: .center, spacing: 8) {
                    Text("나의 선택")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.gray600)
                    
                    // 홈 팀을 선택한 경우
                    if clickHomeTeam {
                        LoadableImage(image: soccerMatch.homeTeam.teamImgURL)
                            .frame(width: 120, height: 120)
                            .background(.white)
                            .clipShape(Circle())
                        
                        Text(soccerMatch.homeTeam.teamName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.gray600)
                    }
                    // 원정팀을 선택한 경우
                    else if clickAwayTeam {
                        LoadableImage(image: soccerMatch.awayTeam.teamImgURL)
                            .frame(width: 120, height: 120)
                            .background(.white)
                            .clipShape(Circle())
                        
                        Text(soccerMatch.awayTeam.teamName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.gray600)
                    }
                    // 무승부를 선택한 경우
                    else if clickDraw {
                        Circle()
                            .frame(width: 120, height: 120)
                            .foregroundStyle(.gray100)
                        
                        Text("무승부")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.gray600)
                    }
                    // 미선택한 경우
                    else {
                        Circle()
                            .frame(width: 120, height: 120)
                            .foregroundStyle(.gray100)
                        
                        Text("선택해주세요")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.gray600)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 67)
                
                // 예측을 한 경우
                if clickHomeTeam || clickAwayTeam || clickDraw {
                    // 예측 결과 띄우기
                    VStack(alignment: .leading, spacing: 0) {
                        Text("예측 결과")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.gray600)
                        
                        // MARK: - 예측 결과 가로 막대 그래프
                        VerticalBarChart(data: [
                            (soccerMatch.homeTeam.teamName, 30.0),
                            (soccerMatch.awayTeam.teamName, 65.0),
                            ("무승부", 5.0)
                        ])
                        .padding(.top, 20)
                    }
                    .padding([.top, .bottom], 32)
                    .padding([.leading, .trailing], 20)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                    )
                    .padding([.leading, .trailing], 16)
                    .padding(.top, 34)
                }
                // 예측을 안 한 경우
                else {
                    // 선택지 보여주기
                    HStack(alignment: .center, spacing: 10) {
                        // MARK: 홈 팀
                        Button {
                            clickHomeTeam.toggle()
                            clickAwayTeam = false
                            clickDraw = false
                        } label: {
                            VStack(alignment: .center, spacing: 20) {
                                LoadableImage(image: soccerMatch.homeTeam.teamImgURL)
                                    .frame(width: 60, height: 60)
                                    .background(.white)
                                    .clipShape(Circle())
                                
                                Text(soccerMatch.homeTeam.teamName)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.gray600)
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.white)
                                    .stroke(.gray100, style: StrokeStyle(lineWidth: 1))
                            )
                        }
                        
                        // MARK: 무승부
                        Button {
                            clickHomeTeam = false
                            clickAwayTeam = false
                            clickDraw.toggle()
                        } label: {
                            VStack(alignment: .center, spacing: 20) {
                                Circle()
                                    .fill(.clear)
                                    .frame(width: 60, height: 60)
                                
                                Text("무승부")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.gray600)
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.white)
                                    .stroke(.gray100, style: StrokeStyle(lineWidth: 1))
                            )
                        }
                        
                        // MARK: 원정 팀
                        Button {
                            clickHomeTeam = false
                            clickAwayTeam.toggle()
                            clickDraw = false
                        } label: {
                            VStack(alignment: .center, spacing: 20) {
                                LoadableImage(image: soccerMatch.awayTeam.teamImgURL)
                                    .frame(width: 60, height: 60)
                                    .background(.white)
                                    .clipShape(Circle())
                                
                                Text(soccerMatch.awayTeam.teamName)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.gray600)
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.white)
                                    .stroke(.gray100, style: StrokeStyle(lineWidth: 1))
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 46)
                }
                
                Spacer()
                
                // 예측을 한 경우
                if clickHomeTeam || clickAwayTeam || clickDraw {
                    HStack(spacing: 8) {
                        // 왼쪽 여백을 위한 네모
                        Rectangle()
                            .opacity(0)
                        
                        // MARK: - 다음 예측하기 버튼
                        DesignHalfButton(label: "다음 예측하기", labelColor: Color.white, btnBGColor: Color.gray600, img: "arrow.right")
                    }
                    .padding([.leading, .trailing], 16)
                }
                // 예측을 안 한 경우
                else {
                    // MARK: - 예측하기 버튼
                    DesignWideButton(label: "예측하기", labelColor: Color.gray400, btnBGColor: Color.gray100)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    // 뒤로가기
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    // MARK: - 우승팀 예측 화면 닫기
                    Image(systemName: "xmark")
                        .foregroundStyle(.gray400)
                        .padding(.leading, 16)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar) // 네비게이션 숨기기
    }
}

#Preview {
    WinningTeamPrediction(soccerMatch: soccerMatches[0])
}
