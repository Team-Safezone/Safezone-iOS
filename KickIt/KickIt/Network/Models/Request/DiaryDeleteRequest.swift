//
//  DiaryDeleteRequest.swift
//  KickIt
//
//  Created by 이윤지 on 11/4/24.
//

import Foundation

/// 축구 일기 삭제 Request 모델
struct DiaryDeleteRequest: Encodable {
    let diaryId: Int64
}
