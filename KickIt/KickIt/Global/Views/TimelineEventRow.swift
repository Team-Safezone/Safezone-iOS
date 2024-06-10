//
//  TimelineEventRow.swift
//  KickIt
//
//  Created by DaeunLee on 5/18/24.
//

import SwiftUI

struct TimelineEventRow: View {
    /// 경기 객체
    var event: MatchEvent
    
    /// 심박수
    var arrayHR: [[String: Any]] = []
    
    /// 아이콘 연결
    var eventIcons: [String: String] = ["골!": "SoccerBall",
                                        "교체" : "ArrowsLeftRight",
                                        "자책골" : "SoccerBall",
                                        "경고" : "card",
                                        "두 번째 경고" : "doublecard",
                                        "퇴장" : "card",
                                        "VAR 판독" : "VideoCamera"]
    
    var heart: [Int] = [122, 114, 87, 100, 85, 75, 76, 94]
    var body: some View {
        HStack(alignment: .center, spacing: 16){
            if (event.eventCode == 5){
                Text("+\(event.eventTime)분")
                    .pretendardTextStyle(.Body3Style)
                    .frame(width: 40, alignment: .center)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.black0)
            } else {
                Text("\(event.eventTime)분")
                    .pretendardTextStyle(.Body3Style)
                    .frame(width: 40, alignment: .center)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.black0)
            }
            HStack(alignment: .center, spacing: 10){
                LoadableImage(image: event.team.teamEmblemURL)
                    .frame(width: 30, height: 30)
                    .background(.white)
                    .clipShape(Circle())
                
                // MARK: 경기 이벤트
                HStack(alignment: .center, spacing: 8){
                    Image(eventIcons[event.eventName] ?? "교체")
                        .frame(width:18, height:18)
                    if event.player2 != "null"{
                        if event.eventName != "VAR 판독"{
                            VStack(alignment: .leading, spacing: 4){
                                Text("\(event.player1) \(event.eventName)")
                                    .pretendardTextStyle(.SubTitleStyle)
                                    .foregroundStyle(Color.black0)
                                Text(event.player2)
                                    .pretendardTextStyle(.Caption1Style)
                                    .foregroundStyle(Color.gray300)
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 4){
                                Text("\(event.eventName)")
                                    .pretendardTextStyle(.SubTitleStyle)
                                    .foregroundStyle(Color.black0)
                                Text(event.player2)
                                    .pretendardTextStyle(.Caption1Style)
                                    .foregroundStyle(Color.gray300)
                            }
                        }
                        
                    }
                    else{
                        VStack(alignment: .leading, spacing: 4){
                            Text("\(event.player1) \(event.eventName)")
                                .pretendardTextStyle(.SubTitleStyle)
                                .foregroundStyle(Color.black0)
                        }
                    }
                    Spacer()
                    // MARK: 심박수와 이벤트 시간 연결
                    if !arrayHR.isEmpty {
                        let temp: [[String: Any]] = {
                            let start = max(0, event.eventTime - 3)
                            /// 시간을 문자열로 변환
                            let startDateString = setEventTime(plusMinute: start)
                            let endDateString = setEventTime(plusMinute: event.eventTime)
                            /// start부터 event.eventTime까지의 Date를 가진 arrayHR의 요소들을 필터링
                            return arrayHR.filter { element in
                                if let date = element["Date"] as? String {
                                    return date >= startDateString && date <= endDateString
                                }
                                return false
                            }}()
                        if let maxHeartRateIndex = temp.enumerated().max(by: { a, b in
                            let heartRateA = a.element["HeartRate"] as? Int ?? 0
                            let heartRateB = b.element["HeartRate"] as? Int ?? 0
                            return heartRateA < heartRateB
                        })?.offset {
                            @State var maxHeartRateElement = temp[maxHeartRateIndex]
                            HStack(spacing: 4){
                                if (maxHeartRateElement["HeartRate"]! as! Int > 80) {
                                    Image("ArrowUp")
                                        .frame(width: 24, height: 24)
                                }
                                else{
                                    Image("ArrowDown")
                                        .frame(width: 24, height: 24)
                                }
                                HStack(spacing: 2){
                                    Text("\(maxHeartRateElement["HeartRate"]!)")
                                        .pretendardTextStyle(.SubTitleStyle)
                                        .frame(width: 25, alignment: .trailing)
                                    Text("BPM")
                                        .pretendardTextStyle(.Caption1Style)
                                }}.padding(.trailing, 6)
                        }
                    }else{
                        let _ = print("더미데이터 출력")
                        HStack(spacing: 4){
                            let dummy = heart.randomElement()
                            if (dummy ?? 110 > 88) {
                                Image("ArrowUp")
                                    .frame(width: 24, height: 24)
                            }
                            else{
                                Image("ArrowDown")
                                    .frame(width: 24, height: 24)
                            }
                            HStack(spacing: 2){
                                Text("\(dummy ?? 120)")
                                    .pretendardTextStyle(.SubTitleStyle)
                                    .frame(width: 25, alignment: .trailing)
                                Text("BPM")
                                    .pretendardTextStyle(.Caption1Style)
                            }}.padding(.trailing, 6)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 13)
        .background{
            if event.eventName == "골!"{
                Color.lime.opacity(0.1)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
            } else if event.eventName == "자책골"{
                Color.red0.opacity(0.2)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
            }
        }
        .padding(.horizontal, 18)
    }
}
#Preview {
    TimelineEventRow(event: matchEvents[0], arrayHR: [])
}
