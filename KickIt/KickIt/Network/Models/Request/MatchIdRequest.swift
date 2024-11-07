//
//  MatchIdRequest.swift
//  KickIt
//
//  Created by 이윤지 on 11/6/24.
//

import Foundation

/// matchId가 필요한 Request 모델
struct MatchIdRequest: Encodable {
    let matchId: Int64
}
