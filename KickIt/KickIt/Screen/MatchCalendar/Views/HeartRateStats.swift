//
//  HeartRateStats.swift
//  KickIt
//
//  Created by DaeunLee on 5/31/24.
//

import SwiftUI

var dataPoints: [CGFloat] = []
var dataTime: [Int] = []

struct HeartRateStats: View {
    @Binding var maxHeartRateElement: [String: Any]
    
    /// Timer 객체
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack{
            // 타임라인 심박수 vs 측정 심박수..
        }
    }
}

struct BoxEvent: View{
    var dataPoint: CGFloat
    var event: MatchEvent
    
    var body: some View{
        VStack(spacing: 10){
            HStack{
                HStack(spacing: 4){
                    LoadableImage(image: "\(soccerMatch.homeTeam.teamEmblemURL)")
                        .frame(width: 24, height: 24)
                        .background(.white)
                        .clipShape(Circle())
                    Text("\(event.player1) \(event.eventName)")
                        .pretendardTextStyle(.SubTitleStyle)
                        .foregroundStyle(.black0)
                }
                Spacer()
                Text("\(event.eventTime)분")
                    .pretendardTextStyle(.SubTitleStyle)
                    .foregroundStyle(.black0)
            }
            .padding(.horizontal, 20)
            HStack(spacing: 16){
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(Int(dataPoint))")
                        .pretendardTextStyle(.H2Style)
                        .foregroundStyle(.lime)
                    Text("BPM")
                        .pretendardTextStyle(.Caption1Style)
                        .foregroundStyle(.gray500)
                }
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(80)")
                        .pretendardTextStyle(.H2Style)
                        .foregroundStyle(.green0)
                    Text("BPM")
                        .pretendardTextStyle(.Caption1Style)
                        .foregroundStyle(.gray500)
                }
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(75)")
                        .pretendardTextStyle(.H2Style)
                        .foregroundStyle(.violet)
                    Text("BPM")
                        .pretendardTextStyle(.Caption1Style)
                        .foregroundStyle(.gray500)
                }
            }
        }
        .padding(.vertical, 10)
        .frame(width: 234, height: 80, alignment: .center)
        .background(){
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.gray900)
        }
    }
}

struct BoxEvent2: View{
    var dataPoint: CGFloat
    var time: Int
    
    var body: some View{
        VStack(spacing: 10){
            HStack{
                HStack(spacing: 4){
                    Text("이벤트 없음")
                        .pretendardTextStyle(.Body2Style)
                }
                Spacer()
                Text("\(time)분")
                    .pretendardTextStyle(.Body2Style)
                    
            }
            .foregroundStyle(.black0)
            .padding(.horizontal, 20)
            HStack(spacing: 16){
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(Int(dataPoint))")
                        .pretendardTextStyle(.H2Style)
                        .foregroundStyle(.lime)
                    Text("BPM")
                        .pretendardTextStyle(.Caption1Style)
                        .foregroundStyle(.gray500)
                }
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(80)")
                        .pretendardTextStyle(.H2Style)
                        .foregroundStyle(.green0)
                    Text("BPM")
                        .pretendardTextStyle(.Caption1Style)
                        .foregroundStyle(.gray500)
                }
                HStack(alignment: .bottom, spacing: 2) {
                    Text("\(75)")
                        .pretendardTextStyle(.H2Style)
                        .foregroundStyle(.violet)
                    Text("BPM")
                        .pretendardTextStyle(.Caption1Style)
                        .foregroundStyle(.gray500)
                }
            }
        }
        .padding(.vertical, 10)
        .frame(width: 234, height: 80, alignment: .center)
        .background(){
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.gray900)
        }
    }
}

struct FanList: View {
    var body: some View {
        HStack(spacing: 44){
            HStack(spacing: 8){
                Circle()
                    .frame(width: 4, height: 4, alignment: .center)
                Text("나")
                    .pretendardTextStyle(.Body2Style)
            }
            .foregroundStyle(.lime)
            
            HStack(spacing: 8){
                Circle()
                    .frame(width: 4, height: 4, alignment: .center)
                Text("\(soccerMatch.homeTeam.teamName) 팬")
                    .pretendardTextStyle(.Body2Style)
            }
            .foregroundStyle(.green0)
            
            HStack(spacing: 8){
                Circle()
                    .frame(width: 4, height: 4, alignment: .center)
                Text("\(soccerMatch.awayTeam.teamName) 팬")
                    .pretendardTextStyle(.Body2Style)
            }
            .foregroundStyle(.violet)
        }
        .padding(.top, 20)
    }
}

struct ViewerStats: View {
    var body: some View {
        HStack{
            Text("전체 시청자 분석")
                .font(.pretendard(.bold, size: 18))
                .padding(.top, 50)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 23)
        
        HStack{
            HStack(spacing: 8){
                LoadableImage(image: "\(soccerMatch.homeTeam.teamEmblemURL)")
                    .frame(width: 40, height: 40)
                    .background(.white)
                    .clipShape(Circle())
                Text("\(soccerMatch.homeTeam.teamName)")
                    .pretendardTextStyle(.Body3Style)
            }
            Spacer()
            HStack(spacing: 8){
                LoadableImage(image: "\(soccerMatch.awayTeam.teamEmblemURL)")
                    .frame(width: 40, height: 40)
                    .background(.white)
                    .clipShape(Circle())
                Text("\(soccerMatch.awayTeam.teamName)")
                    .pretendardTextStyle(.Body3Style)
            }
        }
        .padding(.horizontal, 20)
        let data = 55.0
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 8)
                .fill(.green0)
                .frame(maxWidth: .infinity, maxHeight: 10)
            RoundedRectangle(cornerRadius: 8)
                .fill(.violet)
                .frame(width: data * 375 / 100, height: 10)
        }
        .padding(.horizontal, 20)
        HStack{
            Text("\(Int(100-data))%")
                .font(.pretendard(.medium, size: 16))
                .foregroundStyle(.green0)
            Spacer()
            Text("\(Int(data))%")
                .font(.pretendard(.medium, size: 16))
                .foregroundStyle(.violet)
        }
        .padding(.horizontal, 20)
        
    }
}

struct ViewerHRStats: View {
    var body: some View {
        let items = [["\(75)", "최저", "\(76)"], ["\(98)",  "평균", "\(89)"],["\(110)", "최고", "\(120)"]]
        VStack{
            HStack{
                Text("\(soccerMatch.homeTeam.teamName) 팬")
                    .font(.pretendard(.bold, size: 16))
                    .frame(width: 80)
                Text("  ")
                    .frame(width: 100)
                Text("\(soccerMatch.awayTeam.teamName) 팬")
                    .font(.pretendard(.bold, size: 16))
                    .frame(width: 80)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 40)
            .background(){
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.gray900)
                    .frame(width: 355, height: 55)
            }
            
            ForEach(items.indices) { i in
                HStack{
                    HStack(spacing: 2){
                        Text(items[i][0])
                            .font(.pretendard(.bold, size: 16))
                            .foregroundStyle(.black0)
                        Text(" BPM")
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(.gray500)
                    }
                    .frame(width: 80)
                    Text(items[i][1])
                        .font(.pretendard(.medium, size: 14))
                        .frame(width: 100)
                        .foregroundStyle(.black0)
                    HStack(spacing: 2){
                        Text(items[i][2])
                            .font(.pretendard(.bold, size: 16))
                            .foregroundStyle(.black0)
                        Text(" BPM")
                            .pretendardTextStyle(.Caption1Style)
                            .foregroundStyle(.gray500)
                    }
                    .frame(width: 80)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 40)
            }
        }
        .overlay(){
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray900, lineWidth: 1)
            Path { path in
                path.move(to: CGPoint(x: 0, y: 115))
                path.addLine(to: CGPoint(x: 355, y: 115))
            }
            .stroke(.gray900, style: StrokeStyle(lineWidth: 1))
            Path { path in
                path.move(to: CGPoint(x: 0, y: 115 + 115 / 2))
                path.addLine(to: CGPoint(x: 355, y: 115 + 115 / 2))
            }
            .stroke(.gray900, style: StrokeStyle(lineWidth: 1))
            
        }
    }
}

#Preview {
    HeartRateStats(maxHeartRateElement: .constant(["Date": "2024/05/23 12:31", "HeartRate": 120]))
}
