//
//  Emotion.swift
//  KickIt
//
//  Created by 이윤지 on 11/19/24.
//

import Foundation
import SwiftUI

/// 축구 일기 감정
struct Emotion {
    let id: Int
    let name: String
    let selectedImg: UIImage
    let defaultImg: UIImage
}

let emotions = [
    Emotion(id: 0, name: "좋음", selectedImg: .good, defaultImg: .goodDefault),
    Emotion(id: 1, name: "놀람", selectedImg: .surprise, defaultImg: .surpriseDefault),
    Emotion(id: 2, name: "사랑", selectedImg: .heart, defaultImg: .heartDefault),
    Emotion(id: 3, name: "지루", selectedImg: .boring, defaultImg: .boringDefault),
    Emotion(id: 4, name: "슬픔", selectedImg: .sad, defaultImg: .sadDefault),
    Emotion(id: 5, name: "분노", selectedImg: .angry, defaultImg: .angryDefault)
]
