//
//  TimeLine.swift
//  KickIt
//
//  Created by DaeunLee on 5/17/24.
//

import SwiftUI
/// 경기 객체
var soccerMatch: SoccerMatch = soccerMatches[1]
/// 경기 시간 상태
var timeStatus: String = "후반전"

struct TimelineEvent: View {
    /// 이벤트 객체
    @State var events: [MatchEvent]
    /// 심박수
    let view = ViewController()
    /// 심박수 배열
    @State private var arrayHR: [[String: Any]] = []
    /// Timer 객체
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect() // 60초마다 업데이트
    var count: Int = 0
    
    var body: some View {
        ZStack{
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    /// 경기 진행 결과
                    MatchResultView()
                    /// 경기 진행 상황
                    VStack(spacing: 38){
                        MatchStatusView()
                        // MARK: 타임라인 업데이트
                        if !events.isEmpty {
                            ForEach(events) { event in
                                // MARK: 경기 전반전, 후반전
                                if event.eventTime < 45 {
//                                    timeStatus = "전반전"
                                } else if event.eventTime < 90 {
//                                    timeStatus = "후반전"
                                } else {
//                                    timeStatus = "추가 시간"
                                }
                                // MARK: 이벤트 읽어오기
                                TimelineEventRow(event: event, arrayHR: self.arrayHR)
                            }.background{
                                /// 선 디자인
                                Path{ path in
                                    path.move(to: CGPoint(x: 10, y: -40))
                                    path.addLine(to: CGPoint(x: 10, y: 25))
                                }
                                .stroke(Color.gray400, style: StrokeStyle(lineWidth: 1, lineCap: .round, dash:[4]))
                            }
                        }
                    }
                    .padding(.leading, 18)
                    .padding(.trailing, 16)
                }
            }
            .onReceive(timer) { _ in
                /// Timer가 발생할 때마다 HeartRate를 다시 로드하고 arrayHR 업데이트
                view.loadHeartRate()
                arrayHR = view.arrayHR.reversed()
                /// 이벤트 업데이트 실험
                if count == 0 {
                    events.insert(MatchEvent(eventTime: 77, eventName: "교체", player1: "마크", player2: "잭슨", realTime: setEventTime(plusMinute: 41)), at: 0)
                }
                let _ = print("array updated.")
            }
            .onAppear {
                /// HeartRate 로드 및 초기화
                view.authorizeHealthKit()
                arrayHR = view.arrayHR.reversed()
                let _ = print("array reset")
            }
            .overlay{
                // MARK: 경기 중
                GeometryReader{ geometry in
                    if soccerMatch.matchCode == 0{
                        /// 가장 최근 심박수
                        if !arrayHR.isEmpty {
                            RoundedRectangle(cornerRadius: 53)
                                .zIndex(2)
                                .frame(width: 145, height: 49, alignment: .center)
                                .foregroundStyle(.white)
                                .shadow(radius: 1)
                                .overlay{
                                    HStack(spacing: 4){
                                        Image("Heartbeat")
                                            .frame(width: 28, height: 28, alignment: .center)
                                        Text("\(arrayHR[0]["HeartRate"] ?? 160)")
                                            .font(.system(size: 24, weight: .bold))
                                        Text("BPM")
                                            .font(.system(size: 16, weight: .medium))
                                    }
                                }
                                .position(x: geometry.size.width / 2, y: 750)
                        }
                    } // MARK: 경기 후
                    else if soccerMatch.matchCode == 2 {
                        LinkToSoccerView()
                            .position(x: geometry.size.width / 2, y: 750)
                    }
                }
                
            }
        }
        .navigationTitle("경기 타임라인")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
}



#Preview {
    TimelineEvent(events: PlayEvents)
}

struct LinkToSoccerView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(.gray400)
            .frame(width: 343, height: 72, alignment: .center)
            .overlay{
                HStack(alignment: .center){
                    VStack(alignment: .leading, spacing: 4){
                        Text("축구 일기 작성하기")
                            .font(.system(size: 16,weight: .semibold))
                        Text("내 심장이 뛴 순간을 기록해보세요!")
                            .font(.system(size: 14,weight: .medium))
                    }
                    Spacer()
                    Image(systemName: "arrow.up.right").resizable()
                        .scaledToFill()
                        .frame(width: 18, height: 18, alignment: .center)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
            }
    }
}

struct MatchResultView: View {
    var body: some View {
        HStack(spacing: 0) {
            LoadableImage(image: "\(soccerMatch.awayTeam.teamImgURL)")
                .frame(width: 24, height: 24)
                .background(.white)
                .clipShape(Circle())
                .padding(.trailing, 6)
            HStack(spacing: 8){
                Text("\(soccerMatch.homeTeamScore?.description ?? "0")")
                Text("\(timeStatus)")
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
    }
}

struct MatchStatusView: View {
    var body: some View {
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
    }
}
