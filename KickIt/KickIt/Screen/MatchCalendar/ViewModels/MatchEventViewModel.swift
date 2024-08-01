//
//  MatchEventViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Combine

/// 경기 이벤트 뷰 모델
class MatchEventViewModel: ObservableObject {
    @Published var matchEvents: [MatchEvent] = []
    @Published var currentEventCode: Int = -1  // 경기 예정
    @Published var currentMatch: SoccerMatch
    
    private var cancellables = Set<AnyCancellable>()
    var matchResultViewModel: MatchResultViewModel
    
    init(match: SoccerMatch, matchResultViewModel: MatchResultViewModel) {
        self.currentMatch = match
        self.matchResultViewModel = matchResultViewModel
        fetchMatchEvents()
    }
    
    func updateMatch(_ match: SoccerMatch) {
        self.currentMatch = match
        matchResultViewModel.updateMatch(match)
    }
    
    func fetchMatchEvents() {
        MatchEventAPI.shared.getMatchEvents(matchID: Int(currentMatch.id))
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching match events: \(error.localizedDescription)")
                    self.matchEvents = []
                    self.updateEventCode()
                }
            }, receiveValue: { [weak self] events in
                self?.matchEvents = events
                self?.updateEventCode()
            })
            .store(in: &cancellables)
    }
    
    private func updateEventCode() {
        if matchEvents.isEmpty {
            currentEventCode = -1
        } else if let lastEvent = matchEvents.last {
            currentEventCode = lastEvent.eventCode
        }
        matchResultViewModel.updateEventCode(currentEventCode)
        matchResultViewModel.updateMatch(currentMatch)
    }
}


