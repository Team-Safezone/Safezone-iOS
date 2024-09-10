//
//  HeartRateMatchEvent.swift
//  KickIt
//
//  Created by 이윤지 on 9/4/24.
//

import Foundation

/// [Entity] 심박수 통계 화면에서 말풍선에 들어갈 경기 이벤트 정보
struct HeartRateMatchEvent {
    var teamURL: String // 이벤트가 발생한 팀의 엠블럼 url
    var eventName: String // 이벤트명
    var eventTime: Int // 이벤트 발생 시각
}
