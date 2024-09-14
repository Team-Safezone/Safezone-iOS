//
//  TimelineEventView.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import SwiftUI

struct TimelineEventView: View {
    @StateObject private var matchEventViewModel: MatchEventViewModel
    @StateObject private var heartRateViewModel = HeartRateViewModel()
    @StateObject private var matchResultViewModel: MatchResultViewModel
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var halfTimeTimer: Timer?
    @State private var isShowingSoccerDiary = false
    
    init(match: SoccerMatch) {
        let resultViewModel = MatchResultViewModel()
        _matchResultViewModel = StateObject(wrappedValue: resultViewModel)
        _matchEventViewModel = StateObject(wrappedValue: MatchEventViewModel(match: match, matchResultViewModel: resultViewModel))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                MatchResultView(viewModel: matchResultViewModel)
                TableLable()
                ScrollView(.vertical, showsIndicators: false) {
                    if matchEventViewModel.matchEvents.isEmpty {
                        Spacer().frame(height: 200)
                        Text("아직 경기가 시작되지 않았어요!")
                            .pretendardTextStyle(.SubTitleStyle)
                            .foregroundStyle(.black0)
                    } else {
                        LazyVStack {
//                            ForEach(matchEventViewModel.matchEvents.reversed()) { event in
//                                if event.teamName != "null" && event.teamUrl != "null" {
//                                    TimelineEventRowView(event: event, arrayHR: heartRateViewModel.arrayHR)
//                                } else if event.eventCode == 2 || event.eventCode == 4 {
//                                    HalfTimeView(event: event, eventCode: event.eventCode)
//                                }
//                            }
                        }
                    }
                } //:SCROLLVIEW
            }//:VSTACK
            .overlay{
                if matchEventViewModel.currentEventCode == 6 {
                    LinkToSoccerView(action: {
                        isShowingSoccerDiary = true
                    })
                }
            }
            .onAppear {
                matchEventViewModel.fetchMatchEvents()
                heartRateViewModel.updateHeartRateData()
            }
            .onChange(of: matchEventViewModel.currentEventCode) { _, newCode in
                updateTimer(for: newCode)
                matchResultViewModel.updateEventCode(newCode)
            }
            .navigationTitle("경기 타임라인")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isShowingSoccerDiary) {
                SoccerDiary()
            }
        }
    }
    
    private func updateTimer(for eventCode: Int) {
        timer?.invalidate()
        halfTimeTimer?.invalidate()
        
        switch eventCode {
        case 0:
            elapsedTime = 0
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                elapsedTime += 1
            }
        case 1, 3, 5:
            if timer == nil {
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    elapsedTime += 1
                }
            }
        case 2:
            timer?.invalidate()
            timer = nil
            halfTimeTimer = Timer.scheduledTimer(withTimeInterval: 15 * 60, repeats: false) { _ in
                matchEventViewModel.currentEventCode = 3
                updateTimer(for: 3)
            }
        case 4:
            break
        case 6:
            timer?.invalidate()
            timer = nil
        default:
            break
        }
    }
}

#Preview {
    TimelineEventView(match: dummySoccerMatches[0])
}


