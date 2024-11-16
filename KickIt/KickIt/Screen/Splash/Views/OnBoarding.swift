//
//  OnBoarding.swift
//  KickIt
//
//  Created by DaeunLee on 11/10/24.
//

import SwiftUI

struct OnBoarding: View {
    @State private var currentPage = 0
    
    let images = ["Splash1", "Splash2", "Splash3", "Splash4"]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                Color.gray950
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, minHeight: 475)
                    .zIndex(-0.2)
                Color.black0
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: 400)
                    .zIndex(-0.1)
                
            }
            
            VStack(spacing: 0){
                Image("textlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 20, alignment: .center)
                    .padding(.top, 68)
                    .padding(.bottom, 9)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<images.count, id: \.self) { index in
                        VStack {
                            Spacer()
                            LottieView(name: images[index], loopMode: .loop)
                                .tag(index)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Text View
                SplashTextView(currentPage: currentPage)
                    .padding(.vertical, 24)
                
                // Page Indicators
                HStack(spacing: 8) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.lime : Color.gray800)
                            .frame(width: 8, height: 8)
                    }
                }
                Spacer()
            }.onAppear {
                setupAppearance()
                startTimer()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .environment(\.colorScheme, .dark) // 무조건 다크모드
    }
    
    private func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.lime)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 7.0, repeats: true) { timer in
            withAnimation {
                currentPage = (currentPage + 1) % 4
            }
        }
    }
}

struct SplashTextView: View{
    let currentPage: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 2){
            if currentPage == 1{
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
            }
            else if currentPage == 2{
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
            else if currentPage == 3{
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
            } else {
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

#Preview {
    OnBoarding()
}
