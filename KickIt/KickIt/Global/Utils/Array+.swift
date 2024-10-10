//
//  Array+.swift
//  KickIt
//
//  Created by 이윤지 on 10/9/24.
//

import Foundation

/// 배열 확장 함수
extension Array {
    // 배열의 안전한 인덱스 접근을 위한 확장 함수
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
