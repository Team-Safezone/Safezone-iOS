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
    
    /// 이벤트 날짜+ 시간
    @State private var date: String = ""
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
            Text("\(event.eventTime)")
                .font(.system(size: 13, weight: .medium))
                .frame(width: 20, alignment: .center)
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
                        ForEach(arrayHR.indices, id: \.self){ index in
                            if (arrayHR[index]["Date"] as! String == event.realTime){
                                HStack(spacing: 4){
                                    Text("높음")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(.gray400)
                                    HStack(spacing: 2){
                                        Text("\(arrayHR[index]["HeartRate"]!)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .frame(width: 25, alignment: .trailing)
                                        Text("BPM")
                                            .font(.system(size: 12, weight: .medium))
                                    }
                                }
                            }
                        }
                    } else{
                        let _ = print("arrayHR Empty")
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    TimelineEventRow(event: PlayEvents[0], arrayHR: [["HeartRate": 120, "Date": "2024/05/18 06:41"]])
}
