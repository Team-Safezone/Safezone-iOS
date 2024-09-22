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
    let match: SoccerMatchWatch
    @ObservedObject var viewModel: SoccerMatchViewModel
    
    var body: some View {
        VStack {
            Text("\(match.timeStr)")
                .font(.headline)
            Text("\(match.homeTeam) vs \(match.awayTeam)")
                .font(.subheadline)
            
            Button(action: {
                // TODO: - HeartRate 앱 실행
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
    MatchDetailView(match: SoccerMatchWatch(id: 1, timeStr: "15:00", homeTeam: "Team A", awayTeam: "Team B"), viewModel: SoccerMatchViewModel())
}
