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
    @State private var isShowingSoccerDiary = false
    
    init(match: SoccerMatch) {
            let resultViewModel = MatchResultViewModel(match: match)
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
                        EmptyStateView()
                    } else {
                        LazyVStack {
                            ForEach(matchEventViewModel.matchEvents.reversed()) { event in
                                if event.teamName != "null" && event.teamUrl != "null" {
                                    TimelineEventRowView(
                                        event: event,
                                        arrayHR: heartRateViewModel.arrayHR,
                                        matchStartTime: matchEventViewModel.matchStartTime
                                    )
                                } else if event.eventCode == 2 || event.eventCode == 4 {
                                    HalfTimeView(event: event, eventCode: event.eventCode)
                                }
                            }
                        }
                    }
                }
            }
            .overlay {
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
            .navigationTitle("경기 타임라인")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isShowingSoccerDiary) {
                SoccerDiary()
            }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 200)
            Text("아직 경기가 시작되지 않았어요!")
                .pretendardTextStyle(.SubTitleStyle)
                .foregroundStyle(.black0)
        }
    }
}

#Preview {
    TimelineEventView(match: dummySoccerMatches[0])
}


