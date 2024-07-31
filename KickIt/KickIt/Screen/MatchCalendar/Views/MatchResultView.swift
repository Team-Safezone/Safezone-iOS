//
//  MatchResultView.swift
//  KickIt
//
//  Created by DaeunLee on 7/30/24.
//

import SwiftUI

struct MatchResultView: View {
    
    let eventCode: Int
    let match: SoccerMatch?
    let elapsedTime: TimeInterval
    @ObservedObject var viewModel: MatchResultViewModel
    
    var color: [(Color, String)] = [(Color.black0, "경기 예정"), (Color.lime, "전반전"), (Color.lime, "하프타임"), (Color.lime, "후반전"), (Color.lime, "추가시간"), (Color.lime, "추가시간"), (Color.gray800, "경기 종료")]
    
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20).fill(color[viewModel.eventCode].0)
                    .frame(width: 66, height: 28, alignment: .center)
                if viewModel.eventCode == 0 {
                    Text("경기예정")
                        .pretendardTextStyle(.Body3Style)
                        .foregroundStyle(Color.background)
                } else if viewModel.eventCode == 6 {
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
                .stroke(color[viewModel.eventCode].0, lineWidth: 1.00)
                .frame(width: .infinity, height: 88, alignment: .center)
            HStack {
                VStack(spacing: 4) {
                    LoadableImage(image: viewModel.match?.homeTeam.teamEmblemURL ?? "")
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .clipShape(Circle())
                    HStack(spacing: 4) {
                        Image(systemName: "house.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.gray400)
                            .frame(width: 16, height: 16)
                        Text(viewModel.match?.homeTeam.teamName ?? "")
                            .foregroundStyle(Color.black0)
                            .pretendardTextStyle(.Body3Style)
                    }
                }
                .frame(width: 100, height: 64, alignment: .center)
                
                HStack(spacing: 14) {
                    Text(viewModel.match?.homeTeamScore?.description ?? "0")
                        .pretendardTextStyle(.H1Style)
                        .foregroundStyle(Color.black0)
                    VStack(spacing: 0) {
                        if (eventCode == 0 || eventCode == 6) {
                            Text(dateToString3(date: viewModel.match?.matchDate))
                                .pretendardTextStyle(.SubTitleStyle)
                            Text(viewModel.match?.matchTime.formatted(date: .omitted, time: .shortened) ?? "")
                                .font(.pretendard(.bold, size: 18))
                        } else if eventCode >= 1 && eventCode <= 5 {
                            Text(color[eventCode].1)
                                .pretendardTextStyle(.SubTitleStyle)
                            Text(formatElapsedTime(elapsedTime))
                                .font(.pretendard(.bold, size: 18))
                        }
                    } //:VSTACK
                    .foregroundStyle(Color.black0)
                    Text(viewModel.match?.awayTeamScore?.description ?? "0")
                        .pretendardTextStyle(.H1Style)
                        .foregroundStyle(Color.black0)
                }
                
                VStack {
                    LoadableImage(image: viewModel.match?.awayTeam.teamEmblemURL ?? "")
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .clipShape(Circle())
                    Text(viewModel.match?.awayTeam.teamName ?? "")
                        .foregroundStyle(Color.black0)
                        .pretendardTextStyle(.Body3Style)
                }
                .frame(width: 100, height: 64, alignment: .center)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func formatElapsedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


struct TableLable: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(Color.black0.opacity(0.1))
            .frame(width: .infinity, height: 40)
            .overlay {
                HStack {
                    HStack {
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
    var eventCode: Int
    
    var body: some View {
        HStack(alignment: .center) {
            Path { path in
                path.move(to: CGPoint(x: 18, y: 8))
                path.addLine(to: CGPoint(x: 126, y: 8))
                path.closeSubpath()
            }
            .stroke(Color.gray950, lineWidth: 1)
            
            HStack(spacing: 4) {
                switch eventCode {
                case 2:
                    Text("하프타임")
                        .pretendardTextStyle(.SubTitleStyle)
                    Text("\(event.player1) - \(event.player2)")
                        .pretendardTextStyle(.SubTitleStyle)
                        .foregroundStyle(.black0)
                case 4:
                    Text("추가시간")
                        .pretendardTextStyle(.SubTitleStyle)
                    Text("\(event.player1)분")
                        .pretendardTextStyle(.SubTitleStyle)
                        .foregroundStyle(.black0)
                default:
                    EmptyView()
                }
            }
            
            Path { path in
                path.move(to: CGPoint(x: 10, y: 8))
                path.addLine(to: CGPoint(x: 126, y: 8))
                path.closeSubpath()
            }
            .stroke(Color.gray950, lineWidth: 1)
        }
        .foregroundStyle(Color.black0)
    }
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

#Preview {
    let match = dummySoccerMatches[1]
    
    let viewModel = MatchResultViewModel()
    viewModel.updateMatch(match)
    viewModel.updateEventCode(1)
    
    return MatchResultView(
        eventCode: 1,
        match: match,
        elapsedTime: 1234,
        viewModel: viewModel
    )
}

#Preview {
    LinkToSoccerView()
}

