//
//  ViewerHRStatsView.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import SwiftUI

struct ViewerHRStatsView: View {
    @ObservedObject var viewModel: ViewerHRStatsViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            Text("심박수 비교")
                .font(.pretendard(.semibold, size: 14))
        VStack{
            HStack {
                HStack{
                    Text(viewModel.homeTeamName+" 팬")
                        .font(.pretendard(.bold, size: 16))
                        .frame(width: 80)
                }
                Spacer().frame(width: 100)
                Text(viewModel.awayTeamName+" 팬")
                    .font(.pretendard(.bold, size: 16))
                    .frame(width: 80)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 40)
            .background {
                SpecificRoundedRectangle(radius: 8, corners: [.topRight, .topLeft])
                    .foregroundStyle(Color.gray900)
                    .frame(width: 355, height: 55)
            }
            ForEach(0..<viewModel.homeTeamStats.count, id: \.self) { i in
                HStack {
                    HStack(spacing: 2) {
                        Text(viewModel.homeTeamStats[i])
                            .font(.pretendard(.bold, size: 16))
                            .foregroundStyle(.black0)
                        Text(" BPM")
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(.gray500)
                    }
                    .frame(width: 80)
                    
                    Text(i == 0 ? "최저" : i == 1 ? "평균" : "최고")
                        .font(.pretendard(.medium, size: 14))
                        .frame(width: 100)
                        .foregroundStyle(.black0)
                    
                    HStack(spacing: 2) {
                        Text(viewModel.awayTeamStats[i])
                            .font(.pretendard(.bold, size: 16))
                            .foregroundStyle(.black0)
                        Text(" BPM")
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(.gray500)
                    }
                    .frame(width: 80)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 40)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray900, lineWidth: 1)
            Path { path in
                path.move(to: CGPoint(x: 0, y: 115))
                path.addLine(to: CGPoint(x: 355, y: 115))
            }
            .stroke(.gray900, style: StrokeStyle(lineWidth: 1))
            Path { path in
                path.move(to: CGPoint(x: 0, y: 115 + 115 / 2))
                path.addLine(to: CGPoint(x: 355, y: 115 + 115 / 2))
            }
            .stroke(.gray900, style: StrokeStyle(lineWidth: 1))
        }
    }
    }
}

#Preview {
    ViewerHRStatsView(viewModel: ViewerHRStatsViewModel(homeTeam: dummySoccerTeams[0], awayTeam: dummySoccerTeams[1]))
}
