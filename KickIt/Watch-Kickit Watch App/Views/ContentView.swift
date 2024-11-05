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
            VStack(alignment: .leading, spacing: 10){
                content
                    .navigationTitle("오늘의 경기")
                    .onAppear {
                        viewModel.fetchTodayMatches()
                    }
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
        if viewModel.isLoading {
            loadingView
        } else if let errorMessage = viewModel.errorMessage {
            errorView(errorMessage: errorMessage)
        } else if viewModel.matches.isEmpty {
            emptyView
        } else {
            matchListView
        }
    }
    
    // API 전송 중
    var loadingView: some View {
        VStack(alignment: .leading, spacing: 12){
            dateText
                .padding(.leading, -40)
            Spacer()
            Text("경기 정보를 불러오는 중")
                .font(.pretendard(.medium, size: 12))
                .foregroundStyle(.gray500)
            Spacer()
        }
    }
    
    // 경기가 없어서 에러 발생함
    func errorView(errorMessage: String) -> some View {
        VStack(alignment: .leading, spacing: 12){
            dateText
                .padding(.leading, -40)
            Spacer()
            Text("오늘은 경기가 없습니다.")
                .font(.pretendard(.medium, size: 12))
                .foregroundStyle(.gray500)
            Spacer()
            let _ = print("오류: \(errorMessage)")
        }
    }
    
    // 가져오는 배열이 없음
    var emptyView: some View {
        VStack(alignment: .leading, spacing: 12){
            dateText
                .padding(.leading, -40)
            Spacer()
            Text("오늘은 경기가 없습니다")
                .font(.pretendard(.medium, size: 12))
                .foregroundStyle(.gray500)
            Spacer()
        }
    }
    
    // 경기 리스트
    var matchListView: some View {
        VStack(alignment: .leading, spacing: 12){
            dateText
            List(viewModel.matches) { match in
                NavigationLink(destination: MatchDetailView(match: match, viewModel: viewModel)) {
                    MatchRow(match: match)
                }
            }
        }
    }
    
    var dateText: some View {
        Text(dateToString2(date: Date()))
            .font(.pretendard(.medium, size: 10))
            .foregroundStyle(Color.gray500)
            .padding(.leading, 10)
    }
}

// MARK: - 경기 리스트 UI
struct MatchRow: View {
    let match: SoccerMatchWatch
    
    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            teamView(teamName: match.homeTeam.teamName, image: match.homeTeam.teamEmblemURL)
                .frame(maxWidth: .infinity)
            
            Text(dateToString3(date: match.matchTime))
                .font(.pretendard(.bold, size: 14))
                .frame(maxWidth: .infinity)
            
            teamView(teamName: match.awayTeam.teamName, image: match.awayTeam.teamEmblemURL)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 5)
    }
    
    private func teamView(teamName: String, image: String) -> some View {
        VStack(spacing: 2) {
            LoadableImage(image: image)
                .scaledToFit()
                .frame(width: 20, height: 20)
            Spacer().frame(height: 2)
            Text(teamName)
                .font(.pretendard(.medium, size: 12))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}


#Preview {
    ContentView()
}
