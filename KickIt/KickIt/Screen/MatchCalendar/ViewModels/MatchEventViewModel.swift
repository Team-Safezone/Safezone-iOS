//
//  MatchEventViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Combine
import Foundation

/// 경기 이벤트 뷰 모델
class MatchEventViewModel: ObservableObject {
    @Published var matchEvents: [MatchEvent] = []
    @Published var currentEventCode: Int = -1
    @Published var matchStartTime: Date?
    let match: SoccerMatch

    private var cancellables = Set<AnyCancellable>()
    var matchResultViewModel: MatchResultViewModel

    init(match: SoccerMatch, matchResultViewModel: MatchResultViewModel) {
        self.match = match
        self.matchResultViewModel = matchResultViewModel
        fetchMatchEvents()
    }
    
    func fetchMatchEvents() {
        // API 호출 시뮬레이션
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.matchEvents = DummyData.matchEvents
            self.updateEventCode()
            self.setMatchStartTime()
        }
    }
    
    private func updateEventCode() {
        if matchEvents.isEmpty {
            currentEventCode = -1
        } else if let lastEvent = matchEvents.last {
            currentEventCode = lastEvent.eventCode
        }
        matchResultViewModel.updateEventCode(currentEventCode)
    }
    
    private func setMatchStartTime() {
        if let startEvent = matchEvents.first(where: { $0.eventCode == 0 }) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            matchStartTime = dateFormatter.date(from: startEvent.eventTime)
        }
    }
}


