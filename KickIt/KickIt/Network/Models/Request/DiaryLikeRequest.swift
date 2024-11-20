//
//  DiaryLikeRequest.swift
//  KickIt
//
//  Created by 이윤지 on 11/4/24.
//

import Foundation

/// 축구 일기 좋아요 버튼 이벤트 Request 모델
struct DiaryLikeRequest: Encodable {
    let isLiked: Bool
}
