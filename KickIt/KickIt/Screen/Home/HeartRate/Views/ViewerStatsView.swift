//
//  ViewerStats.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import SwiftUI

struct ViewerStatsView: View {
    
    @ObservedObject var viewModel: ViewerStatsViewModel
        
        var body: some View {
            VStack {
                HStack {
                    Text("전체 시청자 분석")
                        .font(.pretendard(.bold, size: 18))
                        .padding(.top, 50)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 23)
                
                HStack {
                    HStack(spacing: 8) {
                        LoadableImage(image: viewModel.homeTeam.teamEmblemURL)
                            .frame(width: 40, height: 40)
                            .background(.white)
                            .clipShape(Circle())
                        Text(viewModel.homeTeam.teamName)
                            .pretendardTextStyle(.Body3Style)
                    }
                    Spacer()
                    HStack(spacing: 8) {
                        LoadableImage(image: viewModel.awayTeam.teamEmblemURL)
                            .frame(width: 40, height: 40)
                            .background(.white)
                            .clipShape(Circle())
                        Text(viewModel.awayTeam.teamName)
                            .pretendardTextStyle(.Body3Style)
                    }
                }
                .padding(.horizontal, 20)
                
                ZStack(alignment: .trailing) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.green0)
                        .frame(maxWidth: .infinity, maxHeight: 10)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.violet)
                        .frame(width: CGFloat(100 - viewModel.homeTeamPercentage) * 375 / 100, height: 10)
                }
                .padding(.horizontal, 20)
                
                HStack {
                    Text("\(Int(viewModel.homeTeamPercentage))%")
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(.green0)
                    Spacer()
                    Text("\(Int(100 - viewModel.homeTeamPercentage))%")
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(.violet)
                }
                .padding(.horizontal, 20)
            }
        }
    }

#Preview {
    ViewerStatsView(viewModel: ViewerStatsViewModel(homeTeam: dummySoccerTeams[0], awayTeam: dummySoccerTeams[1], homeTeamPercentage: 70))
}
