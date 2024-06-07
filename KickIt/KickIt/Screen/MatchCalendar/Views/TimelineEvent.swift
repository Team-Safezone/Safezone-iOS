//
//  TimeLine.swift
//  KickIt
//
//  Created by DaeunLee on 5/17/24.
//

import SwiftUI
/// 경기 객체
var soccerMatch: SoccerMatch = soccerMatches[3]

struct TimelineEvent: View {
    var soccerMatch: SoccerMatch = soccerMatches[3]
    /// 이벤트 객체
    @State var events: [MatchEvent] = matchEvents
    /// 심박수
    let view = ViewController()
    /// 심박수 배열
    @State var arrayHR: [[String: Any]] = []
    /// Timer 객체
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    MatchResultView()
                        .padding(.top, 12)
                    TableLable()
                    ScrollView(.vertical, showsIndicators: false){
                        VStack{
                            if !events.isEmpty {
                                ForEach(events) { event in
                                    // MARK: 이벤트 읽어오기
                                    TimelineEventRow(event: event, arrayHR: self.arrayHR)
                                    if (event.eventTime == 46){
                                        HalfTimeView()
                                    }}}}
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
        }
        
    }
    
}



#Preview {
    TimelineEvent()
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
                            .font(.Title2)
                        Text("내 심장이 뛴 순간을 기록해보세요!")
                            .font(.Body2)
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
                .stroke(Color.lime, lineWidth: 1.00)
                .frame(width: .infinity, height: 88, alignment: .center)
            
            HStack{
                VStack(spacing: 4)
                {
<<<<<<< Updated upstream
                    LoadableImage(image: "\(soccerMatch.homeTeam.teamImgURL)")
                        .scaledToFill()
=======
                    LoadableImage(image: "\(soccerMatch.homeTeam.teamEmblemURL)")
                        .scaledToFit()
>>>>>>> Stashed changes
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
                            .font(.Body3)
                    }
                }
                .frame(width: 100, height: 64, alignment: .center)
                
                HStack(spacing: 14){
                    Text("\(soccerMatch.homeTeamScore?.description ?? "0")")
                        .font(.H1)
                        .foregroundStyle(Color.black0)
                    VStack(spacing: 0){
                        Text("후반전")
                            .font(.SubTitle)
                        Text("27:39")
                            .font(.SubTitle)
                        
                    }
                    .foregroundStyle(Color.black0)
                    Text("\(soccerMatch.awayTeamScore?.description ?? "0")")
                        .font(.H1)
                        .foregroundStyle(Color.black0)
                }
                
                VStack{
<<<<<<< Updated upstream
                    LoadableImage(image: "\(soccerMatch.awayTeam.teamImgURL)")
                        .scaledToFill()
=======
                    LoadableImage(image: "\(soccerMatch.awayTeam.teamEmblemURL)")
                        .scaledToFit()
>>>>>>> Stashed changes
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .clipShape(Circle())
                    Text("\(soccerMatch.awayTeam.teamName)")
                        .foregroundStyle(Color.black0)
                        .font(.Body3)
                }
                .frame(width: 100, height: 64, alignment: .center)
                
            }
            
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.lime)
                    .frame(width: 66, height: 24, alignment: .center)
                if (soccerMatch.matchCode != 2)
                {
                    Text("실시간")
                        .font(.Body3)
                        .foregroundStyle(Color.black)
                }
                else{
                    Text("경기 종료")
                        .font(.Body3)
                        .foregroundStyle(.gray300)
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
            .foregroundStyle(Color.black0.opacity(0.1))
            .frame(width: .infinity, height: 40)
            .overlay{
                HStack{
                    HStack{
                        Text("시간")
                            .font(.Body3)
                        Text("타임라인")
                            .font(.Body3)
                    }
                    Spacer()
                    Text("나의 심박수")
                        .font(.Body3)
                }
                .padding(.horizontal, 10)
                .foregroundStyle(Color.black0)
            }
            .padding(.horizontal, 16)
        
    }
}

struct HalfTimeView: View {
    var body: some View {
        HStack(alignment: .center){
            Path{ path in
                path.move(to: CGPoint(x: 18, y: 8))
                path.addLine(to: CGPoint(x: 126, y: 8))
                path.closeSubpath()
            }
            .stroke(Color.black0, lineWidth: 1)
            HStack(spacing: 4){
                Text("하프타임")
                    .font(.SubTitle)
                Text("\(soccerMatch.homeTeamScore ?? 0) - \(soccerMatch.awayTeamScore ?? 0)")
                    .font(.SubTitle)
                    .backgroundStyle(.black0)
            }
            Path{ path in
                path.move(to: CGPoint(x: 10, y: 8))
                path.addLine(to: CGPoint(x: 126, y: 8))
                path.closeSubpath()
            }
            .stroke(Color.black0, lineWidth: 1)
        }
        .foregroundStyle(Color.black0)
    }
}
