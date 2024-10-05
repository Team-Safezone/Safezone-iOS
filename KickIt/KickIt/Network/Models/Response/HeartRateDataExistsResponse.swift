//
//  HeartRateDataExistsResponse.swift
//  KickIt
//
//  Created by DaeunLee on 10/4/24.
//

import Foundation

/// [타임라인 화면] 사용자 데이터 여부 확인 Response 모델
struct HeartRateDataExistsResponse: Codable {
    let exists: Bool
}
