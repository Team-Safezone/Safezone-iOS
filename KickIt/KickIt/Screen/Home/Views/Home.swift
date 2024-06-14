//
//  Home.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

/// 홈 화면
struct Home: View {
    var soccerMatch: SoccerMatch
    var soccerMatches: [SoccerMatch] = dummySoccerMatches
    
    /// 홈 화면 뷰모델
    @ObservedObject var viewModel = DefaultHomeViewModel()
    
    /// 프리미어리그 팀 리스트
    @State private var soccerTeams: [SoccerTeam] = []
    
    var body: some View {
        NavigationStack{
            Header()
            ScrollView(.vertical, showsIndicators: false){
                // MARK: 경기 이벤트
                VStack(alignment: .center, spacing: 13){
                    HStack{
                        VStack(alignment: .leading, spacing: 0){
                            Text("진행 중인 경기 이벤트\n바로 참여해볼까요?")
                                .pretendardTextStyle(.H2Style)
                            Text("참여하면 GOAL을 얻을 수 있어요")
                                .pretendardTextStyle(.Body2Style)
                                .foregroundStyle(.gray500)
                        }
                        Spacer()
                    }
                    .padding(.leading, 16)
                    HStack(spacing: 16){
                        /// 카드
                        NavigationLink{
                            SoccerMatchInfo(soccerMatch: soccerMatch)
                                .toolbarRole(.editor) // back 텍스트 숨기기
                                .toolbar(.hidden, for: .tabBar) // 네비게이션 숨기기
                        }label:{
                            btnCard1(matchText: "\(soccerMatch.homeTeam.teamName) VS \(soccerMatch.awayTeam.teamName)")
                        }
                        btnCard2(matchText: "토트넘 VS 아스널")
                    }
                }.frame(width: 375, height: 321, alignment: .center)
                
                // MARK: 경기 일정
                VStack(alignment: .leading, spacing: 12){
                    VStack(alignment: .leading, spacing: 4){
                        HStack(spacing: 7){
                            Text("나를 위한 경기 일정")
                                .pretendardTextStyle(.H2Style)
                            HStack(spacing: -6){
                                ForEach(3..<soccerMatches.count, id: \.self){ i in
                                    LoadableImage(image: dummySoccerMatches[i].homeTeam.teamEmblemURL)
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .frame(width: 24, height: 24)
                                        
                                }
                            }
                        }
                        Text("내가 관심있는 팀의 경기 일정만 모아봐요")
                            .pretendardTextStyle(.Body2Style)
                    }
                    VStack(spacing: 12){
                        ForEach(3..<soccerMatches.count, id: \.self) {i in
                            matchList(soccerMatch: dummySoccerMatches[i])
                        }
                        NavigationLink(destination: MatchCalendar()){
                            DesignHalfButton2(label: "경기 더보기", labelColor: .white, btnBGColor: .background, img: "greaterthan")
                                .frame(width: 343, height: 50, alignment: .center)
                        }
                    }
                }
            }
        }
        .tint(.black0)
        .onAppear {
            // 초기 진입 시, 프리미어리그 팀 조회 API 호출
            requestSoccerTeams(soccerSeason: "2023-24")
        }
    }
    
    /// 프리미어리그 팀 리스트 불러오기
    private func requestSoccerTeams(soccerSeason: String) {
        viewModel.requestSoccerTeams(soccerSeason: soccerSeason)
        
        soccerTeams = viewModel.soccerTeams // 팀 리스트 저장
    }
}

struct btnCard1: View {
    var matchText: String
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 165, height: 196)
                .foregroundStyle(LinearGradient.limeGradient)
            VStack(alignment: .center, spacing: 4){
                VStack(alignment: .leading, spacing: 0){
                    VStack(alignment: .leading, spacing: 0){
                        Text(matchText)
                        Text("경기 예측하기")
                    }
                    .pretendardTextStyle(.Title1Style)
                    Text("내일 4:30 예정 경기")
                        .pretendardTextStyle(.Body3Style)
                }
                .foregroundStyle(Color.black)
                .frame(width: 141, height: 68, alignment: .leading)
                Image("Trophys")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
            }
        }
    }
}

struct btnCard2: View {
    var matchText: String
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 165, height: 196)
                .foregroundStyle(LinearGradient.pinkGradient)
            VStack(alignment: .center, spacing: 4){
                VStack(alignment: .leading, spacing: 0){
                    VStack(alignment: .leading, spacing: 0){
                        Text(matchText)
                        Text("축구 일기쓰기")
                    }
                    .pretendardTextStyle(.Title1Style)
                    Text("내일 4:30 예정 경기")
                        .pretendardTextStyle(.Body3Style)
                }
                .foregroundStyle(Color.white)
                .frame(width: 141, height: 68, alignment: .leading)
                Image(uiImage: .heart)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
            }
        }
    }
}

struct matchList: View {
    var soccerMatch: SoccerMatch
    var body: some View {
        HStack(spacing: 30){
            VStack(spacing: 4) {
                LoadableImage(image: "\(soccerMatch.homeTeam.teamEmblemURL)")
                    .frame(width: 40, height: 40)
                    .background(.white)
                    .clipShape(Circle())
                Text("\(soccerMatch.homeTeam.teamName)")
                    .pretendardTextStyle(.Body3Style)
            }
            .frame(width: 80)
            VStack(alignment: .center, spacing: 5) {
                Text("\(dateToString2(date: soccerMatch.matchDate))")
                    .pretendardTextStyle(.Body1Style)
                Text("\(timeToString(time: soccerMatch.matchTime))")
                    .pretendardTextStyle(.Title1Style)
            }
            VStack(spacing: 4) {
                LoadableImage(image: "\(soccerMatch.awayTeam.teamEmblemURL)")
                    .frame(width: 40, height: 40)
                    .background(.white)
                    .clipShape(Circle())
                Text("\(soccerMatch.awayTeam.teamName)")
                    .pretendardTextStyle(.Body3Style)
                    .frame(width: 80)
            }
            .frame(width: 80)
        }
        .frame(width: 343, height: 88, alignment: .center)
        .foregroundStyle(.black0)
        .background{
            RoundedRectangle(cornerRadius: 8).fill(Color.gray950)
                .stroke(.gray900, style: StrokeStyle(lineWidth: 1))
        }
    }
}

struct Header: View {
    var body: some View {
        HStack{
            Text("LOGO")
                .font(.pretendard(.semibold, size: 20))
                .foregroundStyle(.black0)
            Spacer()
            HStack(spacing: 4){
                Image(uiImage: .soccer)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32, alignment: .center)
                Text("10")
                    .pretendardTextStyle(.Body1Style)
            }
            Spacer().frame(width: 16)
            Image(systemName: "bell")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28, alignment: .center)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    Home(soccerMatch: dummySoccerMatches[0])
}
