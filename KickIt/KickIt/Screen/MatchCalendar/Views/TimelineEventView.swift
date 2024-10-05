//
//  TimelineEventView.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import SwiftUI

// 타임라인 화면
struct TimelineEventView: View {
    @StateObject private var viewModel: MatchEventViewModel
    @State private var isShowingSoccerDiary = false // 축구 경기 일기 버튼
    @State private var timer: Timer? // API 호출 타이머
    
    init(match: SoccerMatch) {
        _viewModel = StateObject(wrappedValue: MatchEventViewModel(match: match))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // 배경화면 색 지정
            Color(.background)
                .ignoresSafeArea()
            
            NavigationStack {
                VStack {
                    // 경기 상태 화면
                    MatchResultView(viewModel: viewModel)
                    // UI
                    TableLable()
                    // 타임라인
                    ScrollView(.vertical, showsIndicators: false) {
                        // 경기 이벤트가 없음
                        if viewModel.matchEvents.isEmpty {
                            EmptyStateView()
                        } else {
                            LazyVStack {
                                ForEach(Array(viewModel.matchEvents.enumerated().reversed()), id: \.offset) { index, event in
                                    if event.eventCode == 1 || event.eventCode == 3 || event.eventCode == 5 {
                                        // 타임라인 출력
                                        TimelineEventRowView(
                                            event: event,
                                            viewModel: viewModel
                                        )
                                    } else if event.eventCode == 2 || event.eventCode == 4 {
                                        HalfTimeView(event: event, eventCode: event.eventCode)
                                    }
                                } //:FOREACH
                            } //:LAZYVSTACK
                        } //:IF
                    } //:SCROLLVIEW
                    .overlay {
                        if viewModel.match.matchCode == 3 {
                            LinkToSoccerView(action: {
                                isShowingSoccerDiary = true
                            })
                        }
                    }
                    .onAppear {
                        // 타임라인 API 호출
                        viewModel.fetchMatchEvents()
                        viewModel.fetchUserAverageHeartRate()
                        
                        // 타이머 설정
                        startTimer()
                    }
                    .onDisappear {
                        // 뷰가 사라질 때 타이머 정지
                        stopTimer()
                    }
                    .onChange(of: viewModel.match.matchCode) { oldValue, newValue in
                        if newValue == 3 { // 경기 종료 일때
                            // 사용자 데이터 저장 관련
                            viewModel.handleMatchEnd()
                            // 타이머 종료
                            stopTimer()
                        } //:IF
                    } //:ONCHANGE
                } //:VSTACK
                .navigationTitle("경기 타임라인")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(isPresented: $isShowingSoccerDiary) {
                    SoccerDiary()
                }
            } //:NAVIGATIONSTACK
        } //:ZSTACK
    }
    
    //MARK: - 타이머 함수
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 180, repeats: true) { _ in
            if viewModel.match.matchCode != 3 {
                viewModel.fetchMatchEvents()
                viewModel.fetchUserAverageHeartRate()
            } else {
                stopTimer()
            }
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
            .stroke(Color.gray950, lineWidth: 1)
            
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
    TimelineEventView(match: dummySoccerMatches[0])
}
