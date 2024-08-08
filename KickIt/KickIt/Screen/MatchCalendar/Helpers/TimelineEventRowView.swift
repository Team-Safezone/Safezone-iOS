//
//  TimelineEventRowView.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import SwiftUI

struct TimelineEventRowView: View {
    var event: MatchEvent
    var arrayHR: [HeartRateRecord] = []
    
    var eventIcons: [String: String] = [
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
            Text("\(event.eventTime)분")
                .pretendardTextStyle(.Body3Style)
                .frame(width: 40, alignment: .center)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.black0)
            
            LoadableImage(image: event.teamUrl)
                .frame(width: 30, height: 30)
                .background(.white)
                .clipShape(Circle())
            
            HStack(alignment: .center, spacing: 8) {
                Image(eventIcons[event.eventName] ?? "교체")
                    .frame(width: 18, height: 18)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(event.player1) \(event.eventName)")
                        .pretendardTextStyle(.SubTitleStyle)
                        .foregroundStyle(Color.black0)
                    if event.player2 != "null" {
                        Text(event.player2)
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(Color.gray300)
                    }
                }
                
                Spacer()
                
                if let heartRate = getHeartRate(for: event.eventTime) {
                    HStack(spacing: 4) {
                        Image(heartRate > User.currentUser.avgHeartRate ? "ArrowUp" : "ArrowDown")
                            .frame(width: 24, height: 24)
                        HStack(spacing: 2) {
                            Text("\(heartRate)")
                                .pretendardTextStyle(.SubTitleStyle)
                                .frame(width: 25, alignment: .trailing)
                            Text("BPM")
                                .pretendardTextStyle(.Caption1Style)
                        }
                    }.padding(.trailing, 6)
                } else {
                    HeartRateView
                }
            }
        }
        .padding(.vertical, 13)
        .background {
            if event.eventName == "골!" {
                Color.lime.opacity(0.1)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
            } else if event.eventName == "자책골" {
                Color.red0.opacity(0.2)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
            }
        }
        .padding(.horizontal, 18)
    }
    
    private func getHeartRate(for eventTime: Int) -> Int? {
        let filteredRecords = arrayHR.filter { record in
            let recordTime = Int(record.date.split(separator: ":")[0]) ?? 0
            return recordTime <= eventTime
        }
        return filteredRecords.max(by: { $0.date < $1.date })?.heartRate
    }
    
    private var HeartRateView: some View {
        let avgHeartRate = User.currentUser.avgHeartRate
        return HStack(spacing: 4) {
            Image(avgHeartRate > User.currentUser.avgHeartRate ? "ArrowUp" : "ArrowDown")
                .frame(width: 24, height: 24)
            HStack(spacing: 2) {
                Text("\(avgHeartRate)")
                    .pretendardTextStyle(.SubTitleStyle)
                    .frame(width: 25, alignment: .trailing)
                Text("BPM")
                    .pretendardTextStyle(.Caption1Style)
            }
        }.padding(.trailing, 6)
    }
}

#Preview {
    let sampleEvent = MatchEvent(id: UUID(), eventCode: 1, eventTime: 30, eventName: "골!", player1: "홍길동", player2: "null", teamName: "맨시티", teamUrl: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg")
    let sampleHeartRateRecords = [HeartRateRecord(heartRate: 80, date: dateTimeToString(date3: Date()))]
    
    return TimelineEventRowView(event: sampleEvent, arrayHR: sampleHeartRateRecords)
}
