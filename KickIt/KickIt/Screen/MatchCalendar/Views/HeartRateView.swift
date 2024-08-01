//
//  HeartRateView.swift
//  KickIt
//
//  Created by DaeunLee on 7/28/24.
//

import SwiftUI

struct HeartRateView: View {
    @StateObject private var viewModel = HeartRateViewModel()
    @StateObject private var fanListViewModel: FanListViewModel
    @StateObject private var viewerStatsViewModel: ViewerStatsViewModel
    @StateObject private var viewerHRStatsViewModel: ViewerHRStatsViewModel
    @StateObject private var matchEventViewModel: MatchEventViewModel
    @StateObject private var matchResultViewModel: MatchResultViewModel
    
    @State private var selectedMatch: SoccerMatch?
    
    init(selectedMatch: SoccerMatch?) {
        let homeTeam = selectedMatch?.homeTeam ?? SoccerTeam(ranking: 1, teamEmblemURL: "", teamName: "Home")
        let awayTeam = selectedMatch?.awayTeam ?? SoccerTeam(ranking: 2, teamEmblemURL: "", teamName: "Away")
        
        let resultViewModel = MatchResultViewModel()
        
        _fanListViewModel = StateObject(wrappedValue: FanListViewModel(homeTeam: homeTeam, awayTeam: awayTeam))
        _viewerStatsViewModel = StateObject(wrappedValue: ViewerStatsViewModel(homeTeam: homeTeam, awayTeam: awayTeam, homeTeamPercentage: 30))
        _viewerHRStatsViewModel = StateObject(wrappedValue: ViewerHRStatsViewModel(homeTeam: homeTeam, awayTeam: awayTeam))
        _matchResultViewModel = StateObject(wrappedValue: resultViewModel)
        _matchEventViewModel = StateObject(wrappedValue: MatchEventViewModel(match: selectedMatch ?? SoccerMatch(id: 0, soccerSeason: "", matchDate: Date(), matchTime: Date(), stadium: "", matchRound: 0, homeTeam: homeTeam, awayTeam: awayTeam, matchCode: 0, homeTeamScore: nil, awayTeamScore: nil), matchResultViewModel: resultViewModel))
        
        _selectedMatch = State(initialValue: selectedMatch)
    }
    
    //    // Timer 객체 선언
    //    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    Text("심박수 그래프")
                        .font(.Title1)
                    Spacer()
                    HStack(spacing: 6) {
                        Text("\(Int(viewModel.dataPoints.min() ?? 0.0)) ~ \(Int(viewModel.dataPoints.max() ?? 0.0))")
                            .font(.system(size: 18, weight: .bold))
                        Text("BPM")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 30)
                
                LineChartView(dataPointsChart: $viewModel.dataPoints, dataTimeChart: $viewModel.dataTime, matchEvents: matchEventViewModel.matchEvents)
                    .padding(.leading, 16)
                
                FanListView(viewModel: fanListViewModel)
                ViewerHRStatsView(viewModel: viewerHRStatsViewModel)
                ViewerStatsView(viewModel: viewerStatsViewModel)
                
            }
//            .onReceive(timer) { _ in
//                viewModel.updateHeartRateData()
//            }
            .navigationTitle("심박수 통계")
            .navigationBarTitleDisplayMode(.inline)
        } //: NAVIGATION STACK
    }
}

#Preview {
    HeartRateView(selectedMatch: dummySoccerMatches[1])
}
