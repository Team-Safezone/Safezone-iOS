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
    @Published var event: HeartRateMatchEvent?
    @Published var homeTeamEmblemURL: String?

    init(dataPoint: CGFloat, time: Int, event: HeartRateMatchEvent? = nil, homeTeamEmblemURL: String? = nil) {
        self.dataPoint = dataPoint
        self.time = time
        self.event = event
        self.homeTeamEmblemURL = homeTeamEmblemURL
    }
}
