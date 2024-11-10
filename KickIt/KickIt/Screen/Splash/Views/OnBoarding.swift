//
//  OnBoarding.swift
//  KickIt
//
//  Created by DaeunLee on 11/10/24.
//

import SwiftUI

struct OnBoarding: View {
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color.gray950
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                splash1().tag(0)
                splash2().tag(1)
                splash3().tag(2)
                splash4().tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .onAppear {
                setupAppearance()
                startTimer()
            }
        }
        .environment(\.colorScheme, .dark) // 무조건 다크모드
    }
    
    private func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.lime)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            withAnimation {
                currentPage = (currentPage + 1) % 4
            }
        }
    }
}

struct splash1: View{
    var body: some View {
        VStack(alignment: .center){
            Image("textlogo")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 20, alignment: .center)
                .padding(.top, 24)
                .padding(.bottom, 9)
            
            LottieView(name: "Splash1", loopMode: .loop)
                .frame(width: 375, height: 375)
                .padding(.bottom, 24)
            
            // 텍스트
            Rectangle().foregroundStyle(.black0)
                .overlay{
                    VStack(alignment: .center, spacing: 2){
                        HStack(spacing: 2){
                            Text("경기 이벤트")
                                .pretendardTextStyle(.H2Style)
                                .foregroundStyle(.limeText)
                            Text("에 참여하고")
                                .pretendardTextStyle(.H2Style)
                                .foregroundStyle(.white0)
                        }
                        Text("골을 얻고 등급 올려보세요!")
                            .pretendardTextStyle(.H2Style)
                            .foregroundStyle(.white0)
                    }.padding(.bottom, 24)
                }.ignoresSafeArea(edges: .bottom)
        }
    }
}

struct splash2: View{
    var body: some View {
        VStack(alignment: .center){
            Image("textlogo")
                .frame(width: 80, height: 20, alignment: .center)
                .padding(.top, 24)
                .padding(.bottom, 9)
            
            LottieView(name: "Splash2", loopMode: .loop)
                .frame(width: 375, height: 375)
            
            // 텍스트
            Rectangle().foregroundStyle(.black0)
                .overlay{
                    VStack(alignment: .center, spacing: 2){
                        Text("내가 감독이라면?")
                            .pretendardTextStyle(.H2Style)
                            .foregroundStyle(.white0)
                        HStack(spacing: 2){
                            Text("경기 전, ")
                                .pretendardTextStyle(.H2Style)
                                .foregroundStyle(.white0)
                            Text("결과 예측하기")
                                .pretendardTextStyle(.H2Style)
                                .foregroundStyle(.limeText)
                        }
                    }
                }
        }
    }
}

struct splash3: View{
    var body: some View {
        VStack(alignment: .center){
            Image("textlogo")
                .frame(width: 80, height: 20, alignment: .center)
                .padding(.top, 24)
                .padding(.bottom, 9)
            
            LottieView(name: "Splash3", loopMode: .loop)
                .frame(width: 375, height: 375)
            
            // 텍스트
            Rectangle().foregroundStyle(.black0)
                .overlay{
                    VStack(alignment: .center, spacing: 2){
                        HStack(spacing: 2){
                            Text("실시간으로 심박수 측정")
                                .pretendardTextStyle(.H2Style)
                                .foregroundStyle(.limeText)
                            Text("하고")
                                .pretendardTextStyle(.H2Style)
                                .foregroundStyle(.white0)
                        }
                        
                        Text("두근거리는 순간 포착")
                            .pretendardTextStyle(.H2Style)
                            .foregroundStyle(.white0)
                    }
                }
        }
    }
}

struct splash4: View{
    var body: some View {
        VStack(alignment: .center){
            Image("textlogo")
                .frame(width: 80, height: 20, alignment: .center)
                .padding(.top, 24)
                .padding(.bottom, 9)
            
            LottieView(name: "Splash4", loopMode: .loop)
                .frame(width: 375, height: 375)
            
            // 텍스트
            Rectangle().foregroundStyle(.black0)
                .overlay{
                    VStack(alignment: .center, spacing: 2){
                        Text("오늘의 특별한 경기 순간을")
                            .pretendardTextStyle(.H2Style)
                            .foregroundStyle(.white0)
                        HStack(spacing: 2){
                            Text("축구 일기로")
                                .pretendardTextStyle(.H2Style)
                                .foregroundStyle(.white0)
                            Text("기록해보세요")
                                .pretendardTextStyle(.H2Style)
                                .foregroundStyle(.limeText)
                        }
                    }
                }
        }
    }
}

#Preview {
    OnBoarding()
}
