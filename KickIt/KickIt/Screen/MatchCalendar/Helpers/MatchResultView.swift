//
//  MatchResultView.swift
//  KickIt
//
//  Created by DaeunLee on 7/30/24.
//

import SwiftUI

// 타임라인 화면의 경기 정보 출력
struct MatchResultView: View {
    @ObservedObject var viewModel: MatchEventViewModel
    
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20).fill(viewModel.getStatusColor())
                    .frame(width: 66, height: 28, alignment: .center)
                
                Text(viewModel.getStatusText())
                    .pretendardTextStyle(.Body3Style)
                    .foregroundStyle(viewModel.getStatusTextColor())
            }
            .zIndex(1)
            .padding(.bottom, 88)
            RoundedRectangle(cornerRadius: 8).fill(.gray950)
                .stroke(viewModel.getStatusBorderColor(), lineWidth: 1.00)
                .frame(maxWidth: .infinity, maxHeight: 96, alignment: .center)
            HStack {
                VStack(spacing: 4) {
                    LoadableImage(image: viewModel.match.homeTeam.teamEmblemURL)
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .clipShape(Circle())
                    HStack(spacing: 4) {
                        Image(systemName: "house.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.gray500Assets)
                            .frame(width: 16, height: 16)
                        Text(viewModel.match.homeTeam.teamName)
                            .foregroundStyle(Color.white0)
                            .pretendardTextStyle(.Body3Style)
                    }
                }
                .frame(width: 100, height: 64, alignment: .center)
                
                HStack(spacing: 18) {
                    Text(viewModel.match.homeTeamScore?.description ?? "0")
                        .pretendardTextStyle(.H1Style)
                        .foregroundStyle(Color.gray200)

                    VStack(spacing: 5) {
                        if viewModel.match.matchCode == 0 || viewModel.match.matchCode == 3 {
                            Text(dateToString3(date: viewModel.match.matchDate))
                                .pretendardTextStyle(.SubTitleStyle)
                                .frame(height: 20)
                            Text(timeToString(time: viewModel.match.matchTime))
                                .font(.pretendard(.bold, size: 18))
                                .frame(height: 24)
                        } else {
                            Text("VS")
                                .font(.pretendard(.bold, size: 16))
                        }
                    }
                    .padding(.top, 6)
                    .foregroundStyle(Color.white0)
                    
                    Text(viewModel.match.awayTeamScore?.description ?? "0")
                        .pretendardTextStyle(.H1Style)
                        .foregroundStyle(Color.gray200)
                }
                
                VStack {
                    LoadableImage(image: viewModel.match.awayTeam.teamEmblemURL)
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .clipShape(Circle())
                    Text(viewModel.match.awayTeam.teamName)
                        .foregroundStyle(Color.white0)
                        .pretendardTextStyle(.Body3Style)
                }
                .frame(width: 100, height: 64, alignment: .center)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}

#Preview("경기예정") {
    MatchResultView(viewModel: MatchEventViewModel(match: dummySoccerMatches[1]))
}

#Preview("경기중") {
    MatchResultView(viewModel: MatchEventViewModel(match: dummySoccerMatches[0]))
}

#Preview("경기종료") {
    MatchResultView(viewModel: MatchEventViewModel(match: dummySoccerMatches[2]))
}
