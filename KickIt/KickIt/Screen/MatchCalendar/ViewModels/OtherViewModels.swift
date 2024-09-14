//
//  OtherViewModels.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Foundation

class BoxEventViewModel: ObservableObject {
    @Published var dataPoint: CGFloat
    @Published var time: Int
    @Published var event: MatchEvent?
    @Published var homeTeamEmblemURL: String?

    init(dataPoint: CGFloat, time: Int, event: MatchEvent? = nil, homeTeamEmblemURL: String? = nil) {
        self.dataPoint = dataPoint
        self.time = time
        self.event = event
        self.homeTeamEmblemURL = homeTeamEmblemURL
    }
}
