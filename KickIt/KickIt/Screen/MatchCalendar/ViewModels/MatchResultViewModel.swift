//
//  MatchResultViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 7/30/24.
//

import Foundation

class MatchResultViewModel: ObservableObject {
    @Published var match: SoccerMatch?
    @Published var eventCode: Int = -1
    
    init(match: SoccerMatch? = nil) {
        self.match = match
    }
    
    func updateMatch(_ match: SoccerMatch?) {
        self.match = match
    }
    
    func updateEventCode(_ code: Int) {
        self.eventCode = code
    }
}
