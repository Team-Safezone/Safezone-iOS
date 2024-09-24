//
//  MatchDetailView.swift
//  Kickit-Watch Watch App
//
//  Created by DaeunLee on 9/21/24.
//

import SwiftUI
import WatchKit
import WatchConnectivity

// MARK: 세부화면
struct MatchDetailView: View {
    let match: SoccerMatchWatch
    @ObservedObject var viewModel: SoccerMatchViewModel
    
    var body: some View {
        VStack {
            if match.status != 3{
                // 경기 전, 경기 중인 경우
                PlayingView(match: match)
                    .padding(.bottom, 42)
                Button(action: {
                    // iOS로 match ID 전송
                    viewModel.sendMatchIdToiOS(matchId: match.id)
                }) {
                    Text("심박수 측정")
                }
            } else {
                // 경기 후인 경우
                PlayingView(match: match)
                    .padding(.bottom, 16)
                ScoreView(match: match)
            }
            
            
        }
    }
}

struct PlayingView: View {
    let match: SoccerMatchWatch
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            VStack{
                LoadableImage(image: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F84%2F59%2F15%2F146_2845915_team_image_url_1586327694696.jpg")
                    .frame(width: 44, height: 44, alignment: .center)
                Text("\(match.homeTeam)")
                    .font(.pretendard(.medium, size: 10))
            }
            Spacer()
            VStack{
                Text("\(match.timeStr)")
                    .font(.pretendard(.medium, size: 14))
                Text("VS")
                    .font(.pretendard(.bold, size: 24))
                    .frame(width: 36, height: 29, alignment: .center)
            }.frame(width: 36, height: 46, alignment: .center)
            Spacer()
            VStack{
                LoadableImage(image: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F84%2F59%2F15%2F146_2845915_team_image_url_1586327694696.jpg")
                    .frame(width: 44, height: 44, alignment: .center)
                Text("\(match.awayTeam)")
                    .font(.pretendard(.medium, size: 10))
            }
            Spacer()
        }
        
    }
}

struct ScoreView: View {
    let match: SoccerMatchWatch
    
    var body: some View {
        HStack{
            Text("\(match.homeTeamScore ?? 0)")
                .font(.pretendard(.bold, size: 24))
                .frame(width: 36, height: 29, alignment: .center)
            Spacer()
            Text("\(match.homeTeamScore ?? 0)")
                .font(.pretendard(.bold, size: 24))
                .frame(width: 36, height: 29, alignment: .center)
        }.frame(width: 150, height: 29, alignment: .center)
    }
}

#Preview{
    MatchDetailView(match: SoccerMatchWatch(id: 0, timeStr: "20:30", homeTeam: "울버햄튼", homeTeamScore: 0, awayTeam: "맨시티", awayTeamScore: 0, status: 0), viewModel: SoccerMatchViewModel())
}

#Preview{
    MatchDetailView(match: SoccerMatchWatch(id: 0, timeStr: "20:30", homeTeam: "울버햄튼", homeTeamScore: 0, awayTeam: "맨시티", awayTeamScore: 0, status: 3), viewModel: SoccerMatchViewModel())
}
