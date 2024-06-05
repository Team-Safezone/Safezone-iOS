//
//  TimeLine.swift
//  KickIt
//
//  Created by DaeunLee on 5/17/24.
//

import SwiftUI
/// 경기 객체
var soccerMatch: SoccerMatch = dummySoccerMatches[0]

struct TimelineEvent: View {
    /// 이벤트 객체
    @State var events: [MatchEvent]
    /// 심박수
    let view = ViewController()
    /// 심박수 배열
    @State private var arrayHR: [[String: Any]] = []
    /// Timer 객체
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect() // 60초마다 업데이트
    
    var body: some View {
        NavigationStack{
            ZStack{VStack{
                MatchResultView()
                    .padding(.top, 12)
                TableLable()
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 38){
                        if !events.isEmpty {
                            ForEach(events) { event in
                                // MARK: 이벤트 읽어오기
                                TimelineEventRow(event: event, arrayHR: self.arrayHR)
                                if (event.eventTime == 46){
                                    HalfTimeView()
                                }}}}
                    .padding(.horizontal, 16)
                    }.onReceive(timer) { _ in
                        /// Timer가 발생할 때마다 HeartRate를 다시 로드하고 arrayHR 업데이트
                        view.loadHeartRate()
                        arrayHR = view.arrayHR.reversed()
                        /// 이벤트 업데이트 실험
                        
                        events.insert(MatchEvent(eventTime: 62, eventName: "교체", player1: "캘러거", player2: "잭슨"), at: 0)
                        
                        let _ = print("array updated.")
                    }.onAppear {
                        /// HeartRate 로드 및 초기화
                        view.authorizeHealthKit()
                        arrayHR = view.arrayHR.reversed()
                        let _ = print("array reset")
                    }}
                NavigationLink{
                    SoccerDiary()
                } label: {
                    if (soccerMatch.matchCode == 2){
                        LinkToSoccerView()
                            .padding(.horizontal, 16)
                            .offset(y: 310)
                    }
                }
                .navigationTitle("경기 타임라인")
                .navigationBarTitleDisplayMode(.inline)
                
            }
            
            
            // MARK: 경기 중 가장 최근 심박수
            //            GeometryReader{ geometry in
            //                if soccerMatch.matchCode == 0{
            //                    if !arrayHR.isEmpty {
            //                        RoundedRectangle(cornerRadius: 53)
            //                            .zIndex(2)
            //                            .frame(width: 140, height: 49, alignment: .center)
            //                            .foregroundStyle(.white)
            //                            .shadow(radius: 1)
            //                            .overlay{
            //                                HStack(spacing: 4){
            //                                    Image("Heartbeat")
            //                                        .frame(width: 28, height: 28, alignment: .center)
            //                                    Text("\(arrayHR[0]["HeartRate"] ?? 160)")
            //                                        .font(.system(size: 24, weight: .bold))
            //                                    Text("BPM")
            //                                        .font(.system(size: 16, weight: .medium))
            //                                }
            //                            }
            //                            .position(x: geometry.size.width / 2, y: 750)
            //                    }
            //                } else if soccerMatch.matchCode == 2 {
            //                    LinkToSoccerView()
            //                        .padding(10)
            //                        .position(x: geometry.size.width / 2, y: 700)
            //                }
            //            }
            
        }
        
    }
    
}



#Preview {
    TimelineEvent(events: PlayEvents)
}

struct LinkToSoccerView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(.gray400)
            .frame(width: .infinity, height: 72, alignment: .center)
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
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray100, lineWidth: 1.00)
                .foregroundStyle(.white)
                .frame(width: .infinity, height: 88, alignment: .center)
            
            HStack{
                VStack(spacing: 4)
                {
                    LoadableImage(image: "\(soccerMatch.homeTeam.teamEmblemURL)")
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .clipShape(Circle())
                    HStack(spacing: 4){
                        Image(systemName: "house.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.gray400)
                            .frame(width: 16, height: 16)
                        Text("\(soccerMatch.homeTeam.teamName)")
                            .foregroundStyle(.gray600)
                            .font(.system(size: 13, weight: .bold))
                    }
                }
                .frame(width: 100, height: 64, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                HStack(spacing: 14){
                    Text("\(soccerMatch.homeTeamScore?.description ?? "0")")
                        .font(.system(size: 24, weight: .bold))
                    VStack(spacing: 0){
                        Text("전반전")
                            .font(.system(size: 14, weight: .semibold))
                        Text("27:39")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.gray400)
                    }
                    Text("\(soccerMatch.awayTeamScore?.description ?? "0")")
                        .font(.system(size: 24, weight: .bold))
                }
                
                VStack{
                    LoadableImage(image: "\(soccerMatch.awayTeam.teamEmblemURL)")
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .clipShape(Circle())
                    Text("\(soccerMatch.awayTeam.teamName)")
                        .foregroundStyle(.gray600)
                        .font(.system(size: 13, weight: .bold))
                }
                .frame(width: 100, height: 64, alignment: .center)
                
            }
            
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.gray600)
                    .frame(width: 66, height: 24, alignment: .center)
                if (soccerMatch.matchCode != 2)
                {
                    Text("실시간")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                }
                else{
                    Text("경기 종료")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                }
                
            }
            .padding(.bottom, 88)
            
        }
        .padding(.horizontal, 16)
    }
}

struct TableLable: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(.gray50)
            .frame(width: .infinity, height: 40)
            .overlay{
                HStack{
                    HStack{
                        Text("시간")
                            .font(.system(size: 13, weight: .medium))
                        Text("타임라인")
                            .font(.system(size: 13, weight: .medium))
                    }
                    Spacer()
                    Text("나의 심박수")
                        .font(.system(size: 13, weight: .bold))
                }
                .padding(.horizontal, 10)
            }
            .padding(.horizontal, 16)
        
    }
}

struct HalfTimeView: View {
    var body: some View {
        HStack(alignment: .center){
            Path{ path in
                path.move(to: CGPoint(x: 0, y: 8))
                path.addLine(to: CGPoint(x: 126, y: 8))
                path.closeSubpath()
            }
            .stroke(.gray400, lineWidth: 1)
            HStack(spacing: 4){
                Text("하프타임")
                    .font(.system(size: 14, weight: .semibold))
                    .backgroundStyle(.white)
                Text("\(soccerMatch.homeTeamScore ?? 0) - \(soccerMatch.awayTeamScore ?? 0)")
                    .font(.system(size: 14, weight: .semibold))
                    .backgroundStyle(.white)
            }
            Path{ path in
                path.move(to: CGPoint(x: 10, y: 8))
                path.addLine(to: CGPoint(x: 126, y: 8))
                path.closeSubpath()
            }
            .stroke(.gray400, lineWidth: 1)
        }
    }
}
