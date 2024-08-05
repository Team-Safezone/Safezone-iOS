//
//  HeartRateProtocol.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Foundation

/// 심박수 통계 뷰모델 프로토콜
protocol HeartRateViewModelProtocol: ObservableObject {
    /// 홈 팀 시청자 비율 조회
    func fetchViewerPercentage(matchID: Int)
    
    /// 팀 별 심박수 데이터 조회
    func fetchTeamHeartRate(teamName: String)
    
    /// 사용자의 심박수 데이터 업로드
    func uploadUserHeartRate(teamName: String, min: Double, avg: Double, max: Double)
}
