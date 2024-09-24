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
//                        viewModel.loadMatches()
                    }
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
        if viewModel.isLoading {
            Text(dateToString2(date: Date()))
                .font(.pretendard(.medium, size: 10))
                .foregroundStyle(Color.gray500)
                .padding(.leading, -28)
            Spacer()
            Text("경기 정보를 불러오는 중")
                .font(.pretendard(.medium, size: 12))
                .foregroundStyle(.gray500)
            Spacer()
        } else if let errorMessage = viewModel.errorMessage {
            Text(dateToString2(date: Date()))
                .font(.pretendard(.medium, size: 10))
                .foregroundStyle(Color.gray500)
                .padding(.leading, -28)
            Spacer()
            Text("오늘은 경기가 없습니다.")
                .font(.pretendard(.medium, size: 12))
                .foregroundStyle(.gray500)
            Spacer()
            let _ = print("오류: \(errorMessage)")
        } else if viewModel.dummySoccerMatches.isEmpty { // matches
            Text(dateToString2(date: Date()))
                .font(.pretendard(.medium, size: 10))
                .foregroundStyle(Color.gray500)
                .padding(.leading, -28)
            Spacer()
            Text("오늘은 경기가 없습니다")
            Spacer()
        } else {
            Text(dateToString2(date: Date()))
                .font(.pretendard(.medium, size: 10))
                .foregroundStyle(Color.gray500)
                .padding(.leading, 10)
            List(viewModel.dummySoccerMatches) { match in
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
        HStack(alignment: .center) {
            Spacer()
            VStack{
                LoadableImage(image: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F84%2F59%2F15%2F146_2845915_team_image_url_1586327694696.jpg")
                    .frame(width: 24, height: 24, alignment: .center)
                Text("\(match.homeTeam)")
                    .font(.pretendard(.medium, size: 12))
            }.frame(width: 62, height: 17, alignment: .center)
            Spacer()
            Text("\(match.timeStr)")
                .font(.pretendard(.bold, size: 14))
                .frame(width: 38, height: 17, alignment: .center)
            Spacer()
            VStack{
                LoadableImage(image: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F84%2F59%2F15%2F146_2845915_team_image_url_1586327694696.jpg")
                    .frame(width: 24, height: 24, alignment: .center)
                Text("\(match.awayTeam)")
                    .font(.pretendard(.medium, size: 12))
            }.frame(width: 62, height: 17, alignment: .center)
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
