//
//  TimelineEventRowView.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import SwiftUI

struct TimelineEventRowView: View {
    var event: MatchEvent
    var arrayHR: [HeartRateRecord]
    var matchStartTime: Date?
    
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
            // 경기 시작 시간으로부터 이벤트 시간 계산
            let elapsedTime = calculateEventTime(from: matchStartTime, eventTime: event.eventTime)
            Text("\(elapsedTime)분")
                .pretendardTextStyle(.Body3Style)
                .frame(width: 40, alignment: .center)
                .multilineTextAlignment(.center)
                .foregroundColor(.white0)
            
            // 이벤트 정보 출력 (팀, 이벤트명, 이벤트 선수)
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
                        .foregroundStyle(.white0)
                    if event.player2 != "null" {
                        Text(event.player2)
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(.gray300)
                    }
                }
                
                Spacer()
                
                // 심박수 정보 출력
                if let heartRate = getHeartRate(for: event.eventTime) {
                    HeartView(heartRate: heartRate)
                } else {
                    AverageHeartRateView()
                }
            }
        }
        .padding(.vertical, 13)
        .padding(.horizontal, 18)
    }
    
    // 경기 시작 시각부터 이벤트 발생 시각까지의 심박수 가져옴
    private func getHeartRate(for eventTime: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        guard let eventDate = dateFormatter.date(from: eventTime),
              let startTime = matchStartTime else {
//            print("Failed to parse dates")
            return nil
        }
        
//        print("Event time: \(eventTime), Start time: \(startTime)")
        
        let filteredRecords = arrayHR.filter { record in
            guard let recordDate = dateFormatter.date(from: record.date ?? "") else {
//                print("Failed to parse record date: \(record.date ?? "")")
                return false
            }
            let isValid = recordDate <= eventDate && recordDate >= startTime
//            print("Record: \(record.date ?? ""), HR: \(Int(record.heartRate)), Valid: \(isValid)")
            return isValid
        }
        
//        print("Filtered records count: \(filteredRecords.count)")
        
        let result = filteredRecords.max(by: {
            guard let date1 = dateFormatter.date(from: $0.date ?? ""),
                  let date2 = dateFormatter.date(from: $1.date ?? "") else {
                return false
            }
            return date1 < date2
        })?.heartRate
        
//        print("Selected heart rate: \(Int(result ?? -1))")
        return Int(result ?? -1)
    }
}

// 심박수 높/낮 그래픽 출력
struct HeartView: View {
    let heartRate: Int
    
    var body: some View {
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
    }
}

// 평균 심박수 일때 그래픽 출력
struct AverageHeartRateView: View {
    var body: some View {
        let avgHeartRate = User.currentUser.avgHeartRate
        return HStack(spacing: 4) {
            Text("-")  // 평균 심박수일 때???
                .frame(width: 24, height: 24)
                .pretendardTextStyle(.SubTitleStyle)
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
