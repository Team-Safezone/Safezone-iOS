//
//  TimeLine.swift
//  KickIt
//
//  Created by DaeunLee on 5/17/24.
//

import SwiftUI

struct TimelineEvent: View {
    /// 경기 객체
    @State var soccerMatch: SoccerMatch
    /// 이벤트 객체
    @State var events: [PlayEvent]

    
    var body: some View {
        Text("경기 타임라인")
            .font(.system(size: 16, weight: .semibold))
            .padding(.top, 12)
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                HStack(spacing: 0) {
                    LoadableImage(image: "\(soccerMatch.awayTeam.teamImgURL)")
                        .frame(width: 24, height: 24)
                        .background(.white)
                        .clipShape(Circle())
                        .padding(.trailing, 6)
                    HStack(spacing: 8){
                        Text("\(soccerMatch.homeTeamScore?.description ?? "0")")
                        Text("후반전")
                        Text("\(soccerMatch.awayTeamScore?.description ?? "0")")
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.black)
                    LoadableImage(image: "\(soccerMatch.homeTeam.teamImgURL)")
                        .frame(width: 24, height: 24)
                        .background(.white)
                        .clipShape(Circle())
                        .padding(.trailing, 6)
                }
                .padding(.bottom, 28)
                
                VStack(spacing: 38){
                    HStack{
                        Circle()
                            .frame(width: 18, height: 18, alignment: .center)
                            .foregroundStyle(.gray400)
                            .overlay{
                                Circle()
                                    .frame(width: 8, height: 8, alignment: .center)
                                    .foregroundStyle(.gray600)
                            }
                        Text("실시간 업데이트 중")
                            .font(.system(size: 13, weight: .medium))
                        Spacer()
                        Text("나의 심박수")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    ForEach(events){ event in
                        // MARK: 이벤트 읽어오기
                        TimelineEventRow(event: event)
                    }.background{
                        /// 선 디자인
                        Path{ path in
                            path.move(to: CGPoint(x: 10, y: -40))
                            path.addLine(to: CGPoint(x: 10, y: 25))
                            
                        }
                        .stroke(Color.gray400, style: StrokeStyle(lineWidth: 1, lineCap: .round, dash:[4]))
                    }
                }
                .padding(.leading, 18)
                .padding(.trailing, 16)
                
                
            }
        }.overlay{
            /// 가장 최근 심박수
            RoundedRectangle(cornerRadius: 53)
                .frame(width: 145, height: 49, alignment: .center)
                .foregroundStyle(.white)
                .shadow(radius: 1)
                .overlay{
                    HStack(spacing: 4){
                        Image("Heartbeat")
                            .frame(width: 28, height: 28, alignment: .center)
                        Text("160")
                            .font(.system(size: 24, weight: .bold))
                        Text("BPM")
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                .position(x: 190, y: 695)
        }
        
        
    }
}
#Preview {
    TimelineEvent(soccerMatch: soccerMatches[0], events: PlayEvents)
}
