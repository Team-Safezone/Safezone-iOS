//
//  SoccerPosition.swift
//  KickIt
//
//  Created by 이윤지 on 9/18/24.
//

import Foundation

/// [ENUM] 축구 포지션 열거형
enum SoccerPosition: String, CaseIterable {
    case GK
    case DF1, DF2, DF3, DF4
    case MF1, MF2, MF3, MF4, MF5
    case FW1, FW2, FW3
}
