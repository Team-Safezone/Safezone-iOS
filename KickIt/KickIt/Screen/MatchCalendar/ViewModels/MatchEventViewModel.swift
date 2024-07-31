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
    @Published var currentEventCode: Int = 0
    @Published var currentMatch: SoccerMatch
    private var cancellables = Set<AnyCancellable>()
    
    init(match: SoccerMatch) {
        self.currentMatch = match
        self.currentEventCode = match.matchCode
    }
    
    func fetchMatchEvents() {
        MatchEventAPI.shared.getMatchEvents(matchID: Int(currentMatch.id))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching match events: \(error)")
                }
            } receiveValue: { [weak self] events in
                self?.matchEvents = events
                self?.updateEventCode()
            }
            .store(in: &cancellables)
    }
    
    private func updateEventCode() {
        if matchEvents.isEmpty {
            currentEventCode = 0
        } else if let lastEvent = matchEvents.last {
            currentEventCode = lastEvent.eventCode
        }
    }
}



