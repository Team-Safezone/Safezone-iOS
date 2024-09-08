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
            /// 타임라인 시간 계산 "yyyy/MM/dd HH:mm:ss" -> "n분"
            let elapsedTime = calculateEventTime(from: matchStartTime, eventTime: event.eventTime)
            Text("\(elapsedTime)분")
                .pretendardTextStyle(.Body3Style)
                .frame(width: 40, alignment: .center)
                .multilineTextAlignment(.center)
                .foregroundColor(.black0)
            
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
                        .foregroundStyle(.black0)
                    if event.player2 != "null" {
                        Text(event.player2)
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(.gray300)
                    }
                }
                
                Spacer()
                
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
    
    /// 심박수 가져오기
    private func getHeartRate(for eventTime: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        guard let eventDate = dateFormatter.date(from: eventTime),
              let startTime = matchStartTime else {
            print("Failed to parse dates")
            return nil
        }
        
        print("Event time: \(eventTime), Start time: \(startTime)")
        
        // 이벤트 시간 이전의 모든 심박수 기록을 필터링
        let filteredRecords = arrayHR.filter { record in
            guard let recordDate = dateFormatter.date(from: record.date) else {
                print("Failed to parse record date: \(record.date)")
                return false
            }
            let isValid = recordDate <= eventDate && recordDate >= startTime
            print("Record: \(record.date), HR: \(record.heartRate), Valid: \(isValid)")
            return isValid
        }
        
        print("Filtered records count: \(filteredRecords.count)")
        
        // 필터링된 기록 중 가장 최근의 심박수 반환
        let result = filteredRecords.max(by: {
            guard let date1 = dateFormatter.date(from: $0.date),
                  let date2 = dateFormatter.date(from: $1.date) else {
                return false
            }
            return date1 < date2
        })?.heartRate
        
        print("Selected heart rate: \(result ?? -1)")
        return result
    }
}

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

struct AverageHeartRateView: View {
    var body: some View {
        let avgHeartRate = User.currentUser.avgHeartRate
        return HStack(spacing: 4) {
            Image("Dash")  // 평균 심박수일 때???
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
