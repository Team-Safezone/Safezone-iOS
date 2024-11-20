//
//  DiaryNotifyRequest.swift
//  KickIt
//
//  Created by 이윤지 on 11/4/24.
//

import Foundation

/// 축구 일기 신고하기 Request 모델
struct DiaryNotifyRequest: Encodable {
    let reasonCode: Int
}
