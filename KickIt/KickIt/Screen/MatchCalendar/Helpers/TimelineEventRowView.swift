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
    
    @Environment(\.colorScheme) var colorScheme
    
    var eventIcons: [String: String] {
        let prefix = colorScheme == .dark ? "" : "b_"
        return [
            "골!": "\(prefix)Goal",
            "교체": "\(prefix)LeftRight",
            "자책골": "\(prefix)SelfGoal",
            "경고": "\(prefix)Card1",
            "두 번째 경고": "\(prefix)Card2",
            "퇴장": "\(prefix)RedCard",
            "VAR 판독": "\(prefix)VideoCamera"
        ]
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Text("\(event.time ?? 0)분")
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
                            .foregroundStyle(.gray800Assets)
                    }
                }
                
                Spacer()
                
                // 사용자가 보는 경기임
                if viewModel.currentMatchId == viewModel.match.id {
                    HeartView(
                        eventHeartRate: getHeartRate(),
                        avgHeartRate: event.avgHeartRate
                    )
                }
            }
        }
        .padding(.vertical, 8)
        .background{
            if event.eventName == "골!" {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.limeTransparent)
            } else if event.eventName == "자책골" {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.redTransparent)
            }
        }
        .padding(.horizontal, 18)
    }
    
    // 심박수 수치 가져오기
    private func getHeartRate() -> Int? {
        // 이미 심박수 데이터가 존재할 때(경기 종료 후 POST 완)
        if let eventHeartRate = event.eventHeartRate {
            return eventHeartRate
            // 심박수 데이터 미존재(경기 중/종료, POST 전)
        } else if viewModel.currentMatchId == viewModel.match.id {
            return viewModel.getHeartRate(for: event.eventTime)
        }
        return nil
    }
}

// MARK: - 사용자 심박수 출력 UI
struct HeartView: View {
    let eventHeartRate: Int?
    let avgHeartRate: Int?
    
    var body: some View {
        HStack(spacing: 4) {
            // avgHeartRate가 존재하면 비교하여 화살표 표시
            if let avgRate = avgHeartRate, let rate = eventHeartRate {
                Image(rate > avgRate ? "ArrowUp" : "ArrowDown")
                    .frame(width: 24, height: 24)
            } else {
                Image("ArrowUp")
                    .frame(width: 24, height: 24)
            }
            
            HStack(spacing: 2) {
                // 심박수가 있으면 해당 값 표시
                Text("\(eventHeartRate ?? 0)")
                    .pretendardTextStyle(.SubTitleStyle)
                    .foregroundStyle(.white0)
                    .frame(width: 25, alignment: .trailing)
                Text("BPM")
                    .pretendardTextStyle(.Caption1Style)
                    .foregroundStyle(.gray800Assets)
            }
        }.padding(.trailing, 6)
    }
}

#Preview("골"){
    TimelineEventRowView(event: MatchEventsData(
        matchId: 0,
        eventCode: 1,
        time: 4, eventTime: "2023/09/11 20:40:00",
        eventName: "골!",
        player1: "손흥민",
        player2: "베인", eventHeartRate: 106, avgHeartRate: 78,
        teamName: "토트넘",
        teamUrl: "https://example.com/team-logo.png"
    ), viewModel: MatchEventViewModel(match: dummySoccerMatches[0]))
}

#Preview("자책골"){
    TimelineEventRowView(event: MatchEventsData(
        matchId: 0,
        eventCode: 1,
        time: 17, eventTime: "2023/09/11 20:40:00",
        eventName: "자책골",
        player1: "손흥민",
        player2: "베인", eventHeartRate: 68, avgHeartRate: 78,
        teamName: "토트넘",
        teamUrl: "https://example.com/team-logo.png"
    ), viewModel: MatchEventViewModel(match: dummySoccerMatches[0]))
}
