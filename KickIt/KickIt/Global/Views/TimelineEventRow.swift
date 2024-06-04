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
    var body: some View {
        HStack(alignment: .center, spacing: 16){
            Text("\(event.eventTime)분")
                .font(.system(size: 13, weight: .regular))
                .frame(width: 30, alignment: .center)
                .multilineTextAlignment(.center)
                .background(.white)
            HStack(alignment: .center, spacing: 10){
                LoadableImage(image: "https://search.pstatic.net/common?type=o&size=152x114&expire=1&refresh=true&quality=95&direct=true&src=http%3A%2F%2Fsstatic.naver.net%2Fkeypage%2Fimage%2Fdss%2F146%2F30%2F33%2F05%2F146_100303305_team_image_url_1435202894494.jpg")
                    .frame(width: 30, height: 30)
                    .background(.white)
                    .clipShape(Circle())
                
                // MARK: 경기 이벤트
                HStack(alignment: .center, spacing: 8){
                    Image(eventIcons[event.eventName] ?? "교체")
                        .frame(width:18, height:18)
                    if event.player2 != "none"{
                        VStack(alignment: .leading, spacing: 4){
                            if event.eventName == "골!"{
                                Text("\(event.player1) 골!")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.gray600)
                            }
                            else{
                                Text("\(event.player1)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.gray600)
                            }
                            Text(event.player2)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.gray400)
                        }
                    }
                    else{
                        VStack(alignment: .leading, spacing: 4){
                            Text("\(event.player1) \(event.eventName)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.gray600)
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
                                    Image(systemName: "arrow.up.right")
                                        .frame(width: 24, height: 24)
                                }
                                else{
                                    Image("ArrowDown")
                                        .frame(width: 24, height: 24)
                                }
                                HStack(spacing: 2){
                                    Text("\(maxHeartRateElement["HeartRate"]!)")
                                        .font(.system(size: 14, weight: .semibold))
                                        .frame(width: 25, alignment: .trailing)
                                    Text("BPM")
                                        .font(.system(size: 12, weight: .medium))
                                }}}
                    }else{
                        let _ = print("심박수 기록 없음")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
#Preview {
    TimelineEventRow(event: matchEvents[0], arrayHR: [["Date": "2024/05/23 22:31", "HeartRate": 120]])
}
