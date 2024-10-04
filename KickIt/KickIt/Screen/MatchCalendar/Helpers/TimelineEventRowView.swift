//
//  TimelineEventRowView.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import SwiftUI

// 타임라인 한 줄 뷰
struct TimelineEventRowView: View {
    var event: MatchEventsData
    @ObservedObject var viewModel: MatchEventViewModel
    
    let eventIcons: [String: String] = [
        "골!": "SoccerBall",
        "교체": "ArrowsLeftRight",
        "자책골": "SoccerBall",
        "경고": "card",
        "두 번째 경고": "doublecard",
        "퇴장": "card",
        "VAR 판독": "VideoCamera"
    ]
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // "yyyy/MM/dd HH:mm:ss" -> nn분
            Text("\(calculateEventTime(from: viewModel.matchStartTime, eventTime: event.eventTime))분")
                .pretendardTextStyle(.Body3Style)
                .frame(width: 40, alignment: .center)
                .foregroundColor(.white0)
            
            LoadableImage(image: event.teamUrl ?? "")
                .frame(width: 30, height: 30)
                .background(.white)
                .clipShape(Circle())
            
            HStack(alignment: .center, spacing: 8) {
                Image(eventIcons[event.eventName] ?? "교체")
                    .frame(width: 18, height: 18)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(event.player1 ?? "") \(event.eventName)")
                        .pretendardTextStyle(.SubTitleStyle)
                        .foregroundStyle(.white0)
                    if let player2 = event.player2 {
                        Text(player2)
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(.gray300)
                    }
                }
                
                Spacer()
                
                // 사용자가 워치에서 선택한 경기가 맞는지 확인
                if viewModel.currentMatchId == viewModel.match.id {
                    // 심박수 데이터와 사용자 평균 심박수를 가져와 전달
                    HeartView(
                        heartRate: viewModel.getHeartRate(for: event.eventTime),
                        userAvgHeartRate: viewModel.userAverageHeartRate ?? User.currentUser.avgHeartRate
                    )
                }//:IF
            }//:HSTACK
        }
        .padding(.vertical, 13)
        .padding(.horizontal, 18)
    }
}

// MARK: - 사용자 심박수 출력 UI
struct HeartView: View {
    let heartRate: Int?
    let userAvgHeartRate: Int
    
    var body: some View {
        HStack(spacing: 4) {
            // 심박수가 있고 평균과 다를 경우 화살표 표시, 없거나 평균과 같으면 "-" 표시
            if let rate = heartRate, rate != userAvgHeartRate {
                Image(rate > userAvgHeartRate ? "ArrowUp" : "ArrowDown")
                    .frame(width: 24, height: 24)
            } else {
                Text("-")
                    .frame(width: 24, height: 24)
                    .pretendardTextStyle(.SubTitleStyle)
            }
            
            HStack(spacing: 2) {
                // 심박수가 있으면 해당 값 표시, 없으면 평균 심박수 표시
                Text("\(heartRate ?? userAvgHeartRate)")
                    .pretendardTextStyle(.SubTitleStyle)
                    .frame(width: 25, alignment: .trailing)
                Text("BPM")
                    .pretendardTextStyle(.Caption1Style)
            }
        }.padding(.trailing, 6)
    }
}

#Preview{
    TimelineEventRowView(event: MatchEventsData(
        eventTime: "2023/09/11 20:40:00",
        eventCode: 1,
        player2: "베인",
        player1: "손흥민",
        matchId: 175,
        eventName: "골!",
        teamName: "토트넘",
        teamUrl: "https://example.com/team-logo.png"
    ), viewModel: MatchEventViewModel(match: dummySoccerMatches[0]))
}
