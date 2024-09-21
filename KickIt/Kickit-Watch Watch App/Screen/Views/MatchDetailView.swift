//
//  MatchDetailView.swift
//  Kickit-Watch Watch App
//
//  Created by DaeunLee on 9/21/24.
//

import SwiftUI
import WatchKit

// MARK: 세부화면
struct MatchDetailView: View {
    let match: SoccerMatch
    @ObservedObject var viewModel: SoccerMatchViewModel
    
    var body: some View {
        VStack {
            Text("\(match.matchTime)")
                .font(.headline)
            Text("\(match.homeTeamName) vs \(match.awayTeamName)")
                .font(.subheadline)
            
            Button(action: {
                // HeartRate 앱 실행
                if let url = URL(string: "heartrate://") {
                    WKExtension.shared().openSystemURL(url)
                }
            }) {
                Text("심박수 측정")
            }
        }
        .navigationTitle("경기 상세")
    }
}


#Preview{
    MatchDetailView(match: SoccerMatch(id: 1, matchTime: "15:00", homeTeamName: "Team A", awayTeamName: "Team B"), viewModel: SoccerMatchViewModel())
}
