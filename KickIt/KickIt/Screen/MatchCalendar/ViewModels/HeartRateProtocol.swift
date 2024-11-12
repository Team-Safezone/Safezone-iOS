//
//  HeartRateProtocol.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Foundation

/// 심박수 통계 뷰모델 프로토콜
protocol HeartRateViewModelProtocol: ObservableObject {
    /// 심박수 통계 조회 결과
    var statistics: HeartRateStatistics? { get }
    
    /// 심박수 통계 조회
    func getHeartRateStatistics(matchId: Int64)
}
