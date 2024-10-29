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
    @State private var isRecordingHeartRate: Bool = false // 현재 심박수 기록 중인지
    @State private var timer: Timer? // 심박수 주기적 업데이트
    
    var body: some View {
        if isRecordingHeartRate {
            TabView {
                RecordingView(match: match, heartrate: Int(viewModel.currentHeartRate))
                    .tabItem {
                        Image(systemName: "moonphase.full.moon")
                    }
                
                EndView(isRecordingHeartRate: $isRecordingHeartRate, viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "moonphase.full.moon")
                    }
            }
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
                viewModel.stopHeartRateQuery()
            }
        } else {
            VStack(spacing: 5) {
                if match.status != 3 {
                    PlayingView(match: match)
                        .safeAreaInset(edge: .bottom){
                            Button(action: {
                                viewModel.sendMatchIdToiOS(matchId: match.id)
                                isRecordingHeartRate = true
                            }) {
                                Text("심박수 기록")
                                    .font(.pretendard(.medium, size: 15))
                                    .foregroundColor(.white)
                            }.frame(maxHeight: 44)
                        }
                    
                } else {
                    PlayingView(match: match)
                    ScoreView(match: match)
                }
            }
        }
    }
    // 타이머 함수
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            // UI 자동 업데이트 됨
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}

// MARK: - 경기 예정 상세 화면 UI
struct PlayingView: View {
    let match: SoccerMatchWatch
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            teamView(teamName: match.homeTeam, image: "리버풀")
                .frame(maxWidth: .infinity)
            VStack(spacing: 2) {
                Text(match.timeStr)
                    .font(.pretendard(.medium, size: 14))
                Text("VS")
                    .font(.pretendard(.bold, size: 24))
            }.frame(minWidth: 36, minHeight: 46)
            
            teamView(teamName: match.awayTeam, image: "뉴캐슬")
                .frame(maxWidth: .infinity)
        }.padding(.bottom, 40)
    }
    
    private func teamView(teamName: String, image: String) -> some View {
        VStack(spacing: 4) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
            Text(teamName)
                .font(.pretendard(.medium, size: 12))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}

// MARK: - 경기 종료 상세 화면 UI
struct ScoreView: View {
    let match: SoccerMatchWatch
    
    var body: some View {
        HStack(spacing: 20) {
            Text("\(match.homeTeamScore ?? 0)")
                .font(.pretendard(.bold, size: 32))
                .frame(width: 36)
            Spacer().frame(width: 40)
            Text("\(match.awayTeamScore ?? 0)")
                .font(.pretendard(.bold, size: 32))
                .frame(width: 36)
        }
    }
}

// MARK: - 심박수 기록 중 UI
struct RecordingView: View {
    let match: SoccerMatchWatch
    let heartrate: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            Text("\(match.homeTeam) VS \(match.awayTeam)")
                .font(.pretendard(.medium, size: 14))
            GIFImageView(gifName: "heart")
                .frame(width: 80, height: 80)
            HStack(alignment: .bottom, spacing: 4){
                Text("\(heartrate)")
                    .font(.pretendard(.bold, size: 40))
                    .frame(maxHeight: 34)
                Text("BPM")
                    .foregroundStyle(.gray500)
            }
            
        }
    }
}

// MARK: - 심박수 기록 종료 화면 UI
struct EndView: View {
    @Binding var isRecordingHeartRate: Bool
    var viewModel: SoccerMatchViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("심박수 기록을\n종료하시겠습니까?")
                .multilineTextAlignment(.center)
                .font(.pretendard(.medium, size: 14))
                .lineSpacing(2)
            Spacer().frame(maxHeight: 10)
            VStack{
                Button(action: {
                    isRecordingHeartRate = false
                    viewModel.sendMatchIdToiOS(matchId: -1)
                }) {
                    Image(systemName: "xmark")
                        .frame(width: 64, height: 34)
                        .foregroundColor(Color.red0)
                }
                .frame(width: 64, height: 34)
                .background(Color.red.opacity(0.2))
                .cornerRadius(25)
                Text("기록 종료")
                    .font(.pretendard(.medium, size: 12))
                    .padding(.top, 2)
            }//:VSTACK
            
            
        }
    }
}

#Preview("경기 상세"){
    @State var isRecordingHeartRate = false
    return MatchDetailView(
        match: SoccerMatchWatch(id: 0, timeStr: "20:30", homeTeam: "울버햄튼", homeTeamScore: 0, awayTeam: "맨시티", awayTeamScore: 0, status: 0),
        viewModel: SoccerMatchViewModel()
    )
}

#Preview("경기종료") {
    @State var isRecordingHeartRate = false
    return MatchDetailView(
        match: SoccerMatchWatch(id: 0, timeStr: "20:30", homeTeam: "울버햄튼", homeTeamScore: 0, awayTeam: "맨시티", awayTeamScore: 0, status: 3),
        viewModel: SoccerMatchViewModel()
    )
}

#Preview("기록 중"){
    RecordingView(match: SoccerMatchWatch(id: 0, timeStr: "20:30", homeTeam: "울버햄튼", homeTeamScore: 0, awayTeam: "맨시티", awayTeamScore: 0, status: 0), heartrate: 84)
}

#Preview("기록 취소"){
    @State var isRecordingHeartRate = true
    return EndView(isRecordingHeartRate: $isRecordingHeartRate, viewModel: SoccerMatchViewModel())
}
