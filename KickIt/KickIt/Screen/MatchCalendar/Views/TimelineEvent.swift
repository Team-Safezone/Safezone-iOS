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
    @State var events: [MatchEvent] = matchEvents
    /// 심박수
    let view = ViewController()
    /// 심박수 배열
    @State var arrayHR: [[String: Any]] = []
    /// Timer 객체
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    @State var count = 0
    var newEvent: [MatchEvent] = [MatchEvent(eventCode: 1, eventTime: 5, eventName: "자책골", player1: "잭슨", player2: "null", team: dummySoccerMatches[0].homeTeam), MatchEvent(eventCode: 1, eventTime: 22, eventName: "두 번째 경고", player1: "로 셀소", player2: "null", team: dummySoccerMatches[0].awayTeam), MatchEvent(eventCode: 4, eventTime: 3, eventName: "추가시간", player1: "null", player2: "null", team: dummySoccerMatches[0].homeTeam), MatchEvent(eventCode: 5, eventTime: 2, eventName: "경고", player1: "판 더 펜", player2: "null", team: dummySoccerMatches[0].homeTeam), MatchEvent(eventCode: 2, eventTime: 45, eventName: "하프타임", player1: "1", player2: "0", team: dummySoccerMatches[0].homeTeam), MatchEvent(eventCode: 3, eventTime: 46, eventName: "교체", player1: "호이비에르", player2: "비수마", team: dummySoccerMatches[0].awayTeam), MatchEvent(eventCode: 4, eventTime: 3, eventName: "추가시간", player1: "null", player2: "null", team: dummySoccerMatches[0].homeTeam), MatchEvent(eventCode: 5, eventTime: 1, eventName: "골!", player1: "잭슨", player2: "null", team: dummySoccerMatches[0].homeTeam), MatchEvent(eventCode: 6, eventTime: 0, eventName: "경기종료", player1: "null", player2: "null", team: dummySoccerMatches[0].homeTeam)]
    
    var body: some View {
        NavigationStack{
            ZStack{
                    NavigationLink(destination: SoccerDiary()){
                        if (events.first?.eventCode == 6){
                        LinkToSoccerView()
                    }
                    }
                    .navigationTitle("경기 타임라인")
                    .navigationBarTitleDisplayMode(.inline)
                    .zIndex(1)
                
                VStack{
                    if (events.isEmpty || events.first?.eventCode == 0){
                        MatchResultView(eventCode: 0)
                            .padding(.top, 12)
                        TableLable()
                        Spacer()
                        Text("아직 경기가 시작되지 않았어요!")
                            .pretendardTextStyle(.SubTitleStyle)
                            .foregroundStyle(.black0)
                        Spacer()
                    }else {
                        MatchResultView(eventCode: events.first?.eventCode ?? 0)
                            .padding(.top, 12)
                        TableLable()
                        if events.first?.eventCode == 6 {
                            ScrollView(.vertical, showsIndicators: false){
                                ForEach(events) { event in
                                    VStack{
                                        if (event.eventCode == 1 || event.eventCode == 3 || event.eventCode == 5){
                                            TimelineEventRow(event: event, arrayHR: self.arrayHR)
                                        }
                                        if (event.eventCode == 2 || event.eventCode == 4){
                                            HalfTimeView(event: event, eventCode: event.eventCode)
                                        }
                                    }}}
                        } else {
                            ScrollView(.vertical, showsIndicators: false){
                                ForEach(events) { event in
                                    VStack{
                                        if (event.eventCode == 1 || event.eventCode == 3 || event.eventCode == 5){
                                            TimelineEventRow(event: event, arrayHR: self.arrayHR)
                                        }
                                        if (event.eventCode == 2 || event.eventCode == 4){
                                            HalfTimeView(event: event, eventCode: event.eventCode)
                                        }
                                    }}
                            }
//                            .onReceive(timer) { _ in
//                                view.loadHeartRate()
//                                arrayHR = view.arrayHR.reversed()
//                                let _ = print("array updated.")
//                            }.onAppear {
//                                view.authorizeHealthKit()
//                                arrayHR = view.arrayHR.reversed()
//                            }
                        }
                    }}.onReceive(timer) { _ in
                        /// Updated Event
                        if count < newEvent.endIndex {
                            events.insert(newEvent[count], at: 0)
                            count = count + 1
                        }
                    }
            }}
    }
}




#Preview {
    TimelineEvent()
}

struct LinkToSoccerView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(LinearGradient.pinkGradient)
            .frame(width: .infinity, height: 72, alignment: .center)
            .overlay{
                HStack(alignment: .center){
                    VStack(alignment: .leading, spacing: 4){
                        Text("축구 일기쓰기")
                            .font(.pretendard(.bold, size: 16))
                        Text("내 심장이 뛴 순간을 기록해보세요!")
                            .pretendardTextStyle(.Body2Style)
                    }
                    Spacer()
                    Image(systemName: "arrow.up.right").resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18, alignment: .center)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
            }.padding(.horizontal, 16)
            .offset(y: 310)
    }
    
}

struct MatchResultView: View {
    var eventCode: Int
    var color: [(Color, String)] = [(Color.black0, "경기 예정"), (Color.lime, "전반전"), (Color.lime, "하프타임"), (Color.lime, "후반전"), (Color.lime, "추가시간"), (Color.lime, "추가시간"), (Color.gray800, "경기 종료")]
    var body: some View {
        
        ZStack{
            ZStack{
                RoundedRectangle(cornerRadius: 20).fill(color[eventCode].0)
                    .frame(width: 66, height: 28, alignment: .center)
                if (eventCode == 0){
                    Text("경기예정")
                        .pretendardTextStyle(.Body3Style)
                        .foregroundStyle(Color.background)
                } else if (eventCode == 6){
                    Text("경기종료")
                        .pretendardTextStyle(.Body3Style)
                        .foregroundStyle(Color.gray300)
                } else {
                    Text("실시간")
                        .pretendardTextStyle(.Body3Style)
                        .foregroundStyle(Color.black)
                }
                
            }
            .zIndex(1)
            .padding(.bottom, 88)
            RoundedRectangle(cornerRadius: 8)
                .stroke(color[eventCode].0, lineWidth: 1.00)
                .frame(width: .infinity, height: 88, alignment: .center)
            HStack{
                VStack(spacing: 4)
                {
                    LoadableImage(image: "\(soccerMatch.homeTeam.teamEmblemURL)")
                        .scaledToFit()
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
                            .foregroundStyle(Color.black0)
                            .pretendardTextStyle(.Body3Style)
                    }
                }
                .frame(width: 100, height: 64, alignment: .center)
                
                HStack(spacing: 14){
                    Text("\(soccerMatch.homeTeamScore?.description ?? "0")")
                        .pretendardTextStyle(.H1Style)
                        .foregroundStyle(Color.black0)
                    VStack(spacing: 0){
                        if (eventCode == 0 || eventCode == 6)
                        {
                            Text(dateToString3(date: soccerMatch.matchDate))
                                .pretendardTextStyle(.SubTitleStyle)
                            Text(timeToString(time: soccerMatch.matchTime))
                                .font(.pretendard(.bold, size: 18))
                        } else {
                            Text(color[eventCode].1)
                                .pretendardTextStyle(.SubTitleStyle)
                            Text("26:32")
                                .font(.pretendard(.bold, size: 18))
                            
                        }
                        
                    }
                    .foregroundStyle(Color.black0)
                    Text("\(soccerMatch.awayTeamScore?.description ?? "0")")
                        .pretendardTextStyle(.H1Style)
                        .foregroundStyle(Color.black0)
                }
                
                VStack{
                    LoadableImage(image: "\(soccerMatch.awayTeam.teamEmblemURL)")
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .clipShape(Circle())
                    Text("\(soccerMatch.awayTeam.teamName)")
                        .foregroundStyle(Color.black0)
                        .pretendardTextStyle(.Body3Style)
                }
                .frame(width: 100, height: 64, alignment: .center)
                
            }
        }
        .padding(.horizontal, 16)
    }
}

struct TableLable: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(Color.black0.opacity(0.1))
            .frame(width: .infinity, height: 40)
            .overlay{
                HStack{
                    HStack{
                        Text("시간")
                            .pretendardTextStyle(.Body3Style)
                        Text("타임라인")
                            .pretendardTextStyle(.Body3Style)
                    }
                    Spacer()
                    Text("나의 심박수")
                        .pretendardTextStyle(.Body3Style)
                }
                .padding(.horizontal, 10)
                .foregroundStyle(Color.black0)
            }
            .padding(.horizontal, 16)
        
    }
}

struct HalfTimeView: View {
    var event: MatchEvent
    var eventCode: Int // 0: 예정, 1: 전반, 2: 휴식, 3: 후반, 4: 추가, 5: 종료
    var body: some View {
        HStack(alignment: .center){
            Path{ path in
                path.move(to: CGPoint(x: 18, y: 8))
                path.addLine(to: CGPoint(x: 126, y: 8))
                path.closeSubpath()
            }
            .stroke(Color.gray950, lineWidth: 1)
            HStack(spacing: 4){
                if eventCode == 2{
                    Text(event.eventName)
                        .pretendardTextStyle(.SubTitleStyle)
                    Text("\(event.player1) - \(event.player2)")
                        .pretendardTextStyle(.SubTitleStyle)
                        .backgroundStyle(.black0)
                }
                if eventCode == 4{
                    Text("추가시간")
                        .pretendardTextStyle(.SubTitleStyle)
                    Text("\(event.eventTime)분")
                        .pretendardTextStyle(.SubTitleStyle)
                        .backgroundStyle(.black0)
                }
                
            }
            Path{ path in
                path.move(to: CGPoint(x: 10, y: 8))
                path.addLine(to: CGPoint(x: 126, y: 8))
                path.closeSubpath()
            }
            .stroke(Color.gray950, lineWidth: 1)
        }
        .foregroundStyle(Color.black0)
    }
}
