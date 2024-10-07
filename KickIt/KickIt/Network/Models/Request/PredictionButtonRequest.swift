//
//  PredictionButtonRequest.swift
//  KickIt
//
//  Created by 이윤지 on 10/6/24.
//

import Foundation

/// 경기 예측 버튼 클릭 Request 모델
struct PredictionButtonRequest: Encodable {
    let matchId: Int64 // 경기 id
}
