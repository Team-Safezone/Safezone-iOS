//
//  HeartRateView.swift
//  KickIt
//
//  Created by DaeunLee on 7/28/24.
//

import SwiftUI

struct HeartRateView: View {
    @State var matchEvents: [MatchEvent] = dummymatchEvents
    @StateObject private var viewModel = HeartRateViewModel()
    @StateObject private var fanListViewModel: FanListViewModel
    @StateObject private var viewerStatsViewModel: ViewerStatsViewModel
    @StateObject private var viewerHRStatsViewModel: ViewerHRStatsViewModel
    @State private var selectedMatch: SoccerMatch? {
        didSet {
            if let match = selectedMatch {
                fanListViewModel.updateTeams(homeTeam: match.homeTeam, awayTeam: match.awayTeam)
                viewerStatsViewModel.fetchViewerPercentage(matchID: Int(match.id))
                viewerHRStatsViewModel.updateTeams(homeTeam: match.homeTeam, awayTeam: match.awayTeam)
            }
        }
    }
    
    // Timer 객체 선언
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    init(selectedMatch: SoccerMatch?) {
        let homeTeam = selectedMatch?.homeTeam ?? SoccerTeam(ranking: 1, teamEmblemURL: "", teamName: "Home")
        let awayTeam = selectedMatch?.awayTeam ?? SoccerTeam(ranking: 2, teamEmblemURL: "", teamName: "Away")
        
        _fanListViewModel = StateObject(wrappedValue: FanListViewModel(homeTeam: homeTeam, awayTeam: awayTeam))
        _viewerStatsViewModel = StateObject(wrappedValue: ViewerStatsViewModel(homeTeam: homeTeam, awayTeam: awayTeam, homeTeamPercentage: 30))
        _viewerHRStatsViewModel = StateObject(wrappedValue: ViewerHRStatsViewModel(homeTeam: homeTeam, awayTeam: awayTeam))
    }
    
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
                
                LineChartView(dataPointsChart: $viewModel.dataPoints, dataTimeChart: $viewModel.dataTime, matchEvents: matchEvents)
                    .padding(.leading, 16)
                
                FanListView(viewModel: fanListViewModel)
                ViewerStatsView(viewModel: viewerStatsViewModel)
                ViewerHRStatsView(viewModel: viewerHRStatsViewModel)
            }
            .onReceive(timer) { _ in
                viewModel.updateHeartRateData()
            }
            .navigationTitle("심박수 통계")
            .navigationBarTitleDisplayMode(.inline)
        } //: NAVIGATION STACK
    }
}

#Preview {
    HeartRateView(selectedMatch: dummySoccerMatches[1])
}
