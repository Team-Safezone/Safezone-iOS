//
//  HomeViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 6/14/24.
//

import Foundation

/// 홈 화면의 뷰모델 프로토콜
protocol HomeViewModel: ObservableObject {
    /// 프리미어리그 팀 리스트
    var soccerTeams: [SoccerTeam] { get }
    
    /// 시즌별 프리미어리그 팀 리스트 조회
    func requestSoccerTeams(soccerSeason: String)
}
