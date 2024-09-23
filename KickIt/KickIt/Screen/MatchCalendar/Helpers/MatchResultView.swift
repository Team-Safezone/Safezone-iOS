//
//  MatchResultView.swift
//  KickIt
//
//  Created by DaeunLee on 7/30/24.
//

import SwiftUI

struct MatchResultView: View {
    @ObservedObject var viewModel: MatchResultViewModel
    
    var color: [(Color, String)] = [(Color.white0, "경기 시작"), (Color.lime, "전반전"), (Color.lime, "하프타임"), (Color.lime, "후반전"), (Color.lime, "추가시간"), (Color.lime, "추가시간"), (Color.gray800, "경기 종료")]
    
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20).fill(getStatusColor())
                    .frame(width: 66, height: 28, alignment: .center)
                
                Text(getStatusText())
                    .pretendardTextStyle(.Body3Style)
                    .foregroundStyle(getStatusTextColor())
            }
            .zIndex(1)
            .padding(.bottom, 88)
            RoundedRectangle(cornerRadius: 8)
                .stroke(getStatusColor(), lineWidth: 1.00)
                .frame(maxWidth: .infinity, maxHeight: 88, alignment: .center)
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
                            .foregroundStyle(Color.white0)
                            .pretendardTextStyle(.Body3Style)
                    }
                }
                .frame(width: 100, height: 64, alignment: .center)
                
                HStack(spacing: 14) {
                    Text(viewModel.match?.homeTeamScore?.description ?? "0")
                        .pretendardTextStyle(.H1Style)
                        .foregroundStyle(Color.white0)
                    
                    VStack(spacing: 0) {
                        if viewModel.eventCode == -1 || viewModel.eventCode == 6 {
                            Text(dateToString3(date: viewModel.match?.matchDate))
                                .pretendardTextStyle(.SubTitleStyle)
                            Text(timeToString(time: viewModel.match?.matchTime))
                                .font(.pretendard(.bold, size: 18))
                        } else {
                            Text("VS")
                                .font(.pretendard(.bold, size: 16))
                        }
                    }
                    .foregroundStyle(Color.white0)
                    
                    Text(viewModel.match?.awayTeamScore?.description ?? "0")
                        .pretendardTextStyle(.H1Style)
                        .foregroundStyle(Color.white0)
                }
                
                VStack {
                    LoadableImage(image: viewModel.match?.awayTeam.teamEmblemURL ?? "")
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .clipShape(Circle())
                    Text(viewModel.match?.awayTeam.teamName ?? "")
                        .foregroundStyle(Color.white0)
                        .pretendardTextStyle(.Body3Style)
                }
                .frame(width: 100, height: 64, alignment: .center)
            }
        }
        .padding(.horizontal, 16)
    }
    private func getStatusColor() -> Color {
            switch viewModel.eventCode {
            case -1:
                return Color.white0
            case 6:
                return Color.gray800
            default:
                return Color.lime
            }
        }
        
        private func getStatusText() -> String {
            switch viewModel.eventCode {
            case -1:
                return "경기예정"
            case 0, 1, 2, 3, 4, 5:
                return "실시간"
            case 6:
                return "경기종료"
            default:
                return ""
            }
        }
        
        private func getStatusTextColor() -> Color {
            switch viewModel.eventCode {
            case -1:
                return Color.background
            case 6:
                return Color.gray300
            default:
                return Color.black
            }
        }
    }


struct TableLable: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(Color.white0.opacity(0.1))
            .frame(maxWidth: .infinity, maxHeight: 40)
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
                .foregroundStyle(Color.white0)
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
                        .foregroundStyle(.white0)
                case 4:
                    Text("추가시간")
                        .pretendardTextStyle(.SubTitleStyle)
                    Text("\(event.player1)분")
                        .pretendardTextStyle(.SubTitleStyle)
                        .foregroundStyle(.white0)
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
        .foregroundStyle(Color.white0)
    }
}

struct LinkToSoccerView: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 8)
                .fill(LinearGradient.pinkGradient)
                .frame(maxWidth: .infinity, maxHeight: 72, alignment: .center)
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
}

#Preview {
    let dummyMatch = dummySoccerMatches[2]
    
    let matchResultViewModel = MatchResultViewModel()
    matchResultViewModel.updateMatch(dummyMatch)
    matchResultViewModel.updateEventCode(6)
    
    return MatchResultView(viewModel: matchResultViewModel)
        .previewLayout(.sizeThatFits)
        .padding()
}
