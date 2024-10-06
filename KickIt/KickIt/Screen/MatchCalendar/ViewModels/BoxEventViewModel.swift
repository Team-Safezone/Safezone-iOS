//
//  BoxEventViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Foundation

// LineChartView의 BoxEventViewModel
class BoxEventViewModel: ObservableObject {
    @Published var dataPoint: CGFloat
    @Published var time: Int
    @Published var event: HeartRateMatchEvent?
    @Published var homeTeamEmblemURL: String?
    @Published var homeTeamHR: Int
    @Published var awayTeamHR: Int

    init(dataPoint: CGFloat, time: Int, event: HeartRateMatchEvent? = nil, homeTeamEmblemURL: String? = nil, homeTeamHR: Int, awayTeamHR: Int) {
        self.dataPoint = dataPoint
        self.time = time
        self.event = event
        self.homeTeamEmblemURL = homeTeamEmblemURL
        self.homeTeamHR = homeTeamHR
        self.awayTeamHR = awayTeamHR
    }
}
