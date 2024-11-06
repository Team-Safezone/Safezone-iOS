//
//  Formation.swift
//  KickIt
//
//  Created by 이윤지 on 9/18/24.
//

import Foundation
import SwiftUI

/// [Entity] 축구 포메이션
struct Formation: Identifiable {
    var id = UUID() // id
    var name: String // 포메이션 이름
    var type: String // 포메이션 유형
    var images: [UIImage] // 이미지 리스트
    var positionsToInt: [Int] // 포지션 int 리스트
    var positions: [SoccerPosition] // 포지션 리스트
}

/// 포메이션 리스트
var formations: [Formation] = [
    Formation(name: "4-3-3 포메이션", type: "공격형", images: [(.soccerball)], positionsToInt: [4, 3, 3], positions: [.GK, .DF1, .DF2, .DF3, .DF4, .MF1, .MF2, .MF3, .FW1, .FW2, .FW3]),
    Formation(name: "4-2-3-1 포메이션", type: "균형형", images: [(.soccerball), (.shield)], positionsToInt: [4, 2, 3, 1], positions: [.GK, .DF1, .DF2, .DF3, .DF4, .MF1, .MF2, .MF3, .MF4, .MF5, .FW1]),
    Formation(name: "4-4-2 포메이션", type: "균형형", images: [(.soccerball), (.shield)], positionsToInt: [4, 4, 2], positions: [.GK, .DF1, .DF2, .DF3, .DF4, .MF1, .MF2, .MF3, .MF4, .FW1, .FW2]),
    Formation(name: "3-4-3 포메이션", type: "공격형", images: [(.soccerball)], positionsToInt: [3, 4, 3], positions: [.GK, .DF1, .DF2, .DF3, .MF1, .MF2, .MF3, .MF4, .FW1, .FW2, .FW3]),
    Formation(name: "4-5-1 포메이션", type: "수비형", images: [(.shield)], positionsToInt: [4, 5, 1], positions: [.GK, .DF1, .DF2, .DF3, .DF4, .MF1, .MF2, .MF3, .MF4, .MF5, .FW1]),
    Formation(name: "3-5-2 포메이션", type: "공격형", images: [(.soccerball)], positionsToInt: [3, 5, 2], positions: [.GK, .DF1, .DF2, .DF3, .MF1, .MF2, .MF3, .MF4, .MF5, .FW1, .FW2])
]
