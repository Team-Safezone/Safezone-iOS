//
//  SoccerMatchViewModel.swift
//  Kickit-Watch Watch App
//
//  Created by DaeunLee on 9/21/24.
//

import Foundation
import Combine

// SoccerMatchViewModel
class SoccerMatchViewModel: ObservableObject {
    @Published var matches: [SoccerMatch] = []
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    private let service = SoccerMatchService()
    
    func loadMatches() {
        isLoading = true
        service.getDailySoccerMatches(for: Date())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.isLoading = false
                },
                receiveValue: { [weak self] matches in
                    self?.matches = matches
                }
            )
            .store(in: &cancellables)
    }
    
    func recordHeartRate(for matchId: Int64) {
        service.recordHeartRate(for: matchId)
    }
}
