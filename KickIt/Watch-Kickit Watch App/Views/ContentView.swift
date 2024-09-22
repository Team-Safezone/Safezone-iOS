//
//  ContentView.swift
//  Kickit-Watch Watch App
//
//  Created by DaeunLee on 9/21/24.
//

import SwiftUI

// MARK: 경기 리스트 화면
import SwiftUI

// MARK: 경기 리스트 화면
struct ContentView: View {
    @StateObject private var viewModel = SoccerMatchViewModel()
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("오늘의 경기")
                .onAppear {
                    viewModel.loadMatches()
                }
        }
    }
    
    @ViewBuilder
    var content: some View {
        if viewModel.isLoading {
            Text("경기 정보를 불러오는 중")
        } else if let errorMessage = viewModel.errorMessage {
            Text("오류: \(errorMessage)")
        } else if viewModel.matches.isEmpty {
            Text("오늘은 경기가 없습니다.")
        } else {
            List(viewModel.matches) { match in
                NavigationLink(destination: MatchDetailView(match: match, viewModel: viewModel)) {
                    MatchRow(match: match)
                }
            }
        }
    }
}

// 경기 리스트 UI
struct MatchRow: View {
    let match: SoccerMatchWatch
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(match.homeTeam) vs \(match.awayTeam)")
                .font(.headline)
            Text("\(match.timeStr)")
                .font(.subheadline)
        }
    }
}

#Preview {
    ContentView()
}
