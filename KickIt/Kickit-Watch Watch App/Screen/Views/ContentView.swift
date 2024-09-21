//
//  ContentView.swift
//  Kickit-Watch Watch App
//
//  Created by DaeunLee on 9/21/24.
//

import SwiftUI

// MARK: 경기 리스트 화면
struct ContentView: View {
    @StateObject private var viewModel = SoccerMatchViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.matches.isEmpty {
                    Text("경기가 없습니다.")
                } else {
                    List(viewModel.matches) { match in
                        NavigationLink(destination: MatchDetailView(match: match, viewModel: viewModel)) {
                            MatchRow(match: match)
                        }
                    }
                }
            }
            .navigationTitle("오늘의 경기")
            .onAppear(perform: viewModel.loadMatches)
        }
    }
}

// 경기 리스트 UI
struct MatchRow: View {
    let match: SoccerMatch
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(match.matchTime)")
            Text("\(match.homeTeamName) vs \(match.awayTeamName)")
        }
    }
}

#Preview{
    ContentView()
}
