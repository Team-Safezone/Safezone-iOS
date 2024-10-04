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
            RoundedRectangle(cornerRadius: 8)
                .stroke(viewModel.getStatusColor(), lineWidth: 1.00)
                .frame(maxWidth: .infinity, maxHeight: 88, alignment: .center)
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
                            .foregroundStyle(.gray400)
                            .frame(width: 16, height: 16)
                        Text(viewModel.match.homeTeam.teamName)
                            .foregroundStyle(Color.white0)
                            .pretendardTextStyle(.Body3Style)
                    }
                }
                .frame(width: 100, height: 64, alignment: .center)
                
                HStack(spacing: 14) {
                    Text(viewModel.match.homeTeamScore?.description ?? "0")
                        .pretendardTextStyle(.H1Style)
                        .foregroundStyle(Color.white0)
                    
                    VStack(spacing: 0) {
                        if viewModel.match.matchCode == 0 || viewModel.match.matchCode == 3 {
                            Text(dateToString3(date: viewModel.match.matchDate))
                                .pretendardTextStyle(.SubTitleStyle)
                            Text(timeToString(time: viewModel.match.matchTime))
                                .font(.pretendard(.bold, size: 18))
                        } else {
                            Text("VS")
                                .font(.pretendard(.bold, size: 16))
                        }
                    }
                    .foregroundStyle(Color.white0)
                    
                    Text(viewModel.match.awayTeamScore?.description ?? "0")
                        .pretendardTextStyle(.H1Style)
                        .foregroundStyle(Color.white0)
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
    }
}

#Preview {
    MatchResultView(viewModel: MatchEventViewModel(match: dummySoccerMatches[0]))
}
