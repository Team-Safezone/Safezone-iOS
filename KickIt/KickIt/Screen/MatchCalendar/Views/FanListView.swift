//
//  FanListView.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import SwiftUI

struct FanListView: View {
    @ObservedObject var viewModel: FanListViewModel
        
        var body: some View {
            HStack(spacing: 44) {
                HStack(spacing: 8) {
                    Circle()
                        .frame(width: 4, height: 4, alignment: .center)
                    Text("나")
                        .pretendardTextStyle(.Body2Style)
                }
                .foregroundStyle(.lime)
                
                HStack(spacing: 8) {
                    Circle()
                        .frame(width: 4, height: 4, alignment: .center)
                    Text("\(viewModel.homeTeamName) 팬")
                        .pretendardTextStyle(.Body2Style)
                }
                .foregroundStyle(.green0)
                
                HStack(spacing: 8) {
                    Circle()
                        .frame(width: 4, height: 4, alignment: .center)
                    Text("\(viewModel.awayTeamName) 팬")
                        .pretendardTextStyle(.Body2Style)
                }
                .foregroundStyle(.violet)
            }
            .padding(.top, 20)
        }
    }

#Preview {
    FanListView(viewModel: FanListViewModel(homeTeam: dummySoccerTeams[0], awayTeam: dummySoccerTeams[1]))
}
