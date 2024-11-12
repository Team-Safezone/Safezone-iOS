//
//  TimelineEventView.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import SwiftUI

struct TimelineEventView: View {
    @StateObject private var viewModel: MatchEventViewModel
    @State private var isShowingSoccerDiary = false
    @State private var timer: Timer?
    
    init(match: SoccerMatch) {
        _viewModel = StateObject(wrappedValue: MatchEventViewModel(match: match))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.background)
                .ignoresSafeArea()
            VStack {
                MatchResultView(viewModel: viewModel)
                TableLable()
                ScrollView(.vertical, showsIndicators: false) {
                    if viewModel.matchEvents.isEmpty {
                        EmptyStateView()
                    } else {
                        LazyVStack {
                            ForEach(Array(viewModel.matchEvents.enumerated().reversed()), id: \.offset) { index, event in
                                if event.eventCode == 1 || event.eventCode == 3 || event.eventCode == 5 {
                                    TimelineEventRowView(
                                        event: event,
                                        viewModel: viewModel
                                    )
                                } else if event.eventCode == 2 || event.eventCode == 4 {
                                    HalfTimeView(event: event, eventCode: event.eventCode)
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchMatchEvents()
                    startTimer()
                }
                .onDisappear {
                    stopTimer()
                }
                .onChange(of: viewModel.match.matchCode) { oldValue, newValue in
                    // 경기 종료
                    if newValue == 3 {
                        viewModel.handleMatchEnd()
                        stopTimer()
                    }
                }
                
                // 경기 종료
                if viewModel.match.matchCode == 3 {
                    NavigationLink(destination: SoccerDiary().toolbarRole(.editor)) {
                        LinkToSoccerView()
                    }
                    .padding(.bottom, 16)
                }
            }
            .navigationTitle("경기 타임라인")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            viewModel.fetchMatchEvents()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - UI
// 경기 예정
struct EmptyStateView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 200)
            Text("경기 이벤트를 가져오는 중이에요!")
                .pretendardTextStyle(.SubTitleStyle)
                .foregroundStyle(.gray500Text)
        }
    }
}

// 안내 화면
struct TableLable: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(Color.gray900Assets)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .overlay {
                HStack (spacing: 29){
                    HStack(spacing: 15){
                        Text("시간     ")
                            .pretendardTextStyle(.Body3Style)
                        Text("팀")
                            .pretendardTextStyle(.Body3Style)
                            .frame(width: 12)
                    }
                    Text("하이라이트")
                        .pretendardTextStyle(.Body3Style)
                        .frame(width: 57)
                    Spacer()
                    Text("나의 심박수")
                        .font(.pretendard(.bold, size: 13))
                }
                .padding(.horizontal, 10)
                .foregroundStyle(Color.white0)
            }
            .padding(.horizontal, 16)
    }
}

// 하프타임일 때의 타임라인 처리
struct HalfTimeView: View {
    var event: MatchEventsData
    var eventCode: Int
    
    var body: some View {
        HStack(alignment: .center) {
            Path { path in
                path.move(to: CGPoint(x: 18, y: 8))
                path.addLine(to: CGPoint(x: 126, y: 8))
                path.closeSubpath()
            }
            .stroke(Color.gray900, lineWidth: 1)
            
            HStack(spacing: 4) {
                switch eventCode {
                case 2:
                    Text("하프타임")
                        .pretendardTextStyle(.SubTitleStyle)
                    Text("\(event.player1 ?? "") - \(event.player2 ?? "")")
                        .pretendardTextStyle(.SubTitleStyle)
                        .foregroundStyle(.white0)
                case 4:
                    Text("추가시간")
                        .pretendardTextStyle(.SubTitleStyle)
                    Text("\(event.player1 ?? "0")분")
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
            .stroke(Color.gray900, lineWidth: 1)
        }
        .foregroundStyle(Color.white0)
    }
}

// 일기쓰기 버튼
struct LinkToSoccerView: View {
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
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
        .foregroundStyle(.whiteAssets)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(width: 342, height: 72)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(LinearGradient.pinkGradient)
        )
        
    }
}

#Preview {
    TimelineEventView(match: dummySoccerMatches[0])
}
