//
//  AlertView.swift
//  KickIt
//
//  Created by DaeunLee on 11/16/24.
//

import SwiftUI

// 알람 뷰
struct AlertView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AlertViewModel
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewModel.alerts) { alert in
                    if alert.type == "gameStart" {
                        alertMatchStart(homeTeam: "토트넘", awayTeam: "첼시", alertDate: "24.11.16")
                            .onTapGesture {
                                viewModel.markAlertAsRead(alert)
                            }
                    } else if alert.type == "lineup" {
                        alertLineup(homeTeam: "토트넘", awayTeam: "첼시", alertDate: "24.11.16")
                            .onTapGesture {
                                viewModel.markAlertAsRead(alert)
                            }
                    }
                }
                alertMatchStart(homeTeam: "토트넘", awayTeam: "첼시", alertDate: "24.11.16")
                alertLineup(homeTeam: "토트넘", awayTeam: "첼시", alertDate: "24.11.16")
                alertPrediction(homeTeam: "토트넘", awayTeam: "첼시", alertDate: "24.11.16")
                alertDiary(alertDate: "24.11.13")
                alertNotice(alertDate: "24.11.12")
            }
            .navigationTitle("알림")
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white0)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SetupAlerts()) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.white0)
                    }
                }
            }
        }
    }
}

// MARK: - 상세 뷰
struct alertno: View {
    var body: some View {
        VStack(spacing: 16) {
            Image("alertno")
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)
            Text("아직 알림이 없어요")
                .pretendardTextStyle(.Body2Style)
                .foregroundStyle(.gray500Text)
        }
    }
}

struct alertMatchStart: View {
    var homeTeam: String
    var awayTeam: String
    var alertDate: String
    
    var body: some View{
        HStack(alignment: .top, spacing: 8){
            Image("alert_matchStart")
                .resizable()
                .scaledToFill()
                .frame(width: 22, height: 22)
            VStack(alignment: .leading, spacing: 6){
                Text("\(homeTeam) VS \(awayTeam)")
                    .pretendardTextStyle(.Title2Style)
                    .foregroundStyle(.gray200)
                Text("경기 시작 5분 전입니다")
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.white0)
            }.padding(.leading, 16)
            Spacer()
            Text(alertDate)
                .pretendardTextStyle(.Body3Style)
                .foregroundStyle(.gray500Text)
        }.padding(20)
            .background{
                unreadRectangle()
            }
            .padding(.vertical, -4)
    }
}

struct alertLineup: View {
    var homeTeam: String
    var awayTeam: String
    var alertDate: String
    
    var body: some View{
        HStack(alignment: .top, spacing: 8){
            Image("alert_lineup")
                .resizable()
                .scaledToFill()
                .frame(width: 22, height: 22)
            VStack(alignment: .leading, spacing: 6){
                HStack(alignment: .top){
                    Text("선발라인업 공개")
                        .pretendardTextStyle(.Title2Style)
                        .foregroundStyle(.gray200)
                    Spacer()
                    Text(alertDate)
                        .pretendardTextStyle(.Body3Style)
                        .foregroundStyle(.gray500Text)
                }
                Text("\(homeTeam) VS \(awayTeam) 경기의 선발 라인업을 확인해보세요")
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.white0)
            }.padding(.leading, 16)
        }.padding(20)
            .background{
                readRectangle()
            }
            .padding(.vertical, -4)
        
    }
}


struct alertPrediction: View {
    var homeTeam: String
    var awayTeam: String
    var alertDate: String
    
    var body: some View{
        HStack(alignment: .top, spacing: 8){
            Image("alert_prediction")
                .resizable()
                .scaledToFill()
                .frame(width: 22, height: 22)
            VStack(alignment: .leading, spacing: 6){
                HStack(alignment: .top){
                    Text("경기예측 결과 확인하기")
                        .pretendardTextStyle(.Title2Style)
                        .foregroundStyle(.gray200)
                    Spacer()
                    Text(alertDate)
                        .pretendardTextStyle(.Body3Style)
                        .foregroundStyle(.gray500Text)
                }
                Text("내가 참여한 \(homeTeam) VS \(awayTeam) 경기의 예측 결과를 확인해보세요!")
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.white0)
            }.padding(.leading, 16)
        }.padding(20)
            .background{
                readRectangle()
            }
            .padding(.vertical, -4)
    }
}

struct alertDiary: View {
    var alertDate: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8){
            Image("alert_diary")
                .resizable()
                .scaledToFill()
                .frame(width: 22, height: 22)
            VStack(alignment: .leading, spacing: 6){
                Text("축구일기")
                    .pretendardTextStyle(.Title2Style)
                    .foregroundStyle(.gray200)
                Text("누군가 나의 축구 일기를 좋아합니다")
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.white0)
            }.padding(.leading, 16)
            Spacer()
            Text(alertDate)
                .pretendardTextStyle(.Body3Style)
                .foregroundStyle(.gray500Text)
            
        }.padding(20)
            .background{
                readRectangle()
            }
            .padding(.vertical, -4)
    }
}

struct alertNotice: View {
    var alertDate: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8){
            Image("alert_notice")
                .resizable()
                .scaledToFill()
                .frame(width: 22, height: 22)
            VStack(alignment: .leading, spacing: 6){
                Text("공지")
                    .pretendardTextStyle(.Title2Style)
                    .foregroundStyle(.gray200)
                Text("공지 내용입니다")
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.white0)
            }.padding(.leading, 16)
            Spacer()
            Text(alertDate)
                .pretendardTextStyle(.Body3Style)
                .foregroundStyle(.gray500Text)
        }.padding(20)
            .background{
                unreadRectangle()
            }
            .padding(.vertical, -4)
    }
}

struct unreadRectangle: View {
    var body: some View {
        Rectangle().fill(Color.gray900Assets)
    }
}

struct readRectangle: View {
    var body: some View {
        Rectangle()
            .stroke(.gray900Assets, style: StrokeStyle(lineWidth: 1.0))
    }
}
#Preview{
    AlertView(viewModel: AlertViewModel())
}
