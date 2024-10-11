//
//  GradeInfo.swift
//  KickIt
//
//  Created by DaeunLee on 10/10/24.
//

import SwiftUI

// 등급 안내 화면
struct GradeInfo: View {
    var body: some View {
        NavigationStack{
            ZStack(alignment: .leading){
                Color.background
                    .ignoresSafeArea()
                VStack(alignment: .leading){
                    // 골
                    VStack(spacing: 10){
                        GradeView1(titleText: "매일 출석하고", subText: "1골 받기")
                            .padding(.top, 12)
                        Divider()
                        GradeView2(titleText: "경기 예측 참여만 해도", capText: "결과 예측 & 선발 라인업 예측", subText: "각 1골 받기")
                        Divider()
                        GradeView2(titleText: "경기 예측 성공하면", capText: "결과 예측 & 선발 라인업 예측", subText: "각 2골 받기")
                        Divider()
                        GradeView1(titleText: "축구 일기 작성하고", subText: "2골 받기")
                            .padding(.bottom, 12)
                    }
                    .padding(.leading, 14)
                    .padding(.trailing, 12)
                    .background{
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.gray950)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    
                    // 등급 기준
                    VStack(alignment: .leading, spacing: 8){
                        Text("등급 기준")
                            .pretendardTextStyle(.Title2Style)
                        BallView(name: "탱탱볼", num1: 0, num2: 20)
                        BallView(name: "브론즈 축구공", num1: 21, num2: 50)
                        BallView(name: "실버 축구공", num1: 51, num2: 90)
                        BallView(name: "골드 축구공", num1: 91, num2: 140)
                        BallView(name: "다이아 축구공", num1: 141, num2: 0)

                    }//:VSTACK
                    .padding(.horizontal, 16)
                    
                }//:VSTACK
            }//ZSTACK
            
        }//:NAVIGATIONSTACK
        .navigationTitle("등급 안내")
    }
}

#Preview {
    GradeInfo()
}

// MARK: - 골 받을 수 있는 방법
struct GradeView1: View {
    var titleText: String
    var subText: String
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 2){
                Text(titleText)
                    .pretendardTextStyle(.Title2Style)
                    .foregroundStyle(.white0)
                Text(subText)
                    .pretendardTextStyle(.SubTitleStyle)
                    .foregroundStyle(.limeText)
            }//VSTACK
            Spacer()
            if subText == "1골 받기" {
                CoinView()
            }else{
                CoinsView()
            }
        }//HSTACK
        .padding(.vertical, 4)
    }
}

struct GradeView2: View {
    var titleText: String
    var capText: String
    var subText: String
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 2){
                Text(titleText)
                    .pretendardTextStyle(.Title2Style)
                    .foregroundStyle(.white0)
                HStack(spacing: 4){
                    Text(capText)
                        .pretendardTextStyle(.Body2Style)
                        .foregroundStyle(.gray500Text)
                    Text(subText)
                        .pretendardTextStyle(.SubTitleStyle)
                        .foregroundStyle(.limeText)
                }
            }//VSTACK
            Spacer()
            CoinsView()
        }//HSTACK
        .padding(.vertical, 4)
    }
}

// MARK: - 동전들
struct CoinView: View {
    var body: some View {
        Image("Coin")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40, alignment: .center)
            .padding(.leading, -30)
    }
}

struct CoinsView: View {
    var body: some View {
        HStack{
            ZStack{
                Image("Coin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: .center)
                    .padding(.leading, -38)
                Image("Coin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: .center)
                    .zIndex(-1)
            }
            
        }
    }
}

struct BallView: View {
    var name: String
    var num1: Int
    var num2: Int
    
    var body: some View {
        HStack{
            Image("Trophys")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            Text(name)
                .font(.pretendard(.semibold, size: 14))
                .foregroundStyle(.white0)
            Spacer()
            if num1 == 141{
                Text("\(num1)골 이상")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.gray500Text)
            } else {
                Text("\(num1)~\(num2) 골")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.gray500Text)
            }
            
        }//:HSTACK
    }
}
