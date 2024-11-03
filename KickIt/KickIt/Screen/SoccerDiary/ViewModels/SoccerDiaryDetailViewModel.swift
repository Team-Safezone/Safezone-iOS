//
//  SoccerDiaryDetailViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 11/3/24.
//

import Foundation
import Combine

/// 개별 축구 일기 뷰모델
final class SoccerDiaryDetailViewModel: ObservableObject {
    /// 추천 일기 객체
    @Published var soccerDiary: RecommendDiaryModel
    
    /// 추천 일기의 menu 버튼 클릭 이벤트
    @Published var showDialog: Bool = false
    
    /// 추천 일기의 신고하기 버튼 클릭 이벤트
    @Published var showNotifyDialog: Bool = false
    
    /// 일기 신고하기 리스트
    var reasons: [String] = ["음란성, 선정적 등 부적절한 내용", "개인정보 노출", "스팸, 상업적 광고", "과도한 욕설, 비하 등 불쾌감을 주는 내용", "부적절한 사용자"]
    
    /// 일기 신고 이유 코드
    @Published var reasonCode: Int = 0
    
    /// 일기 신고 이유
    @Published var selectedReason: String
    
    init(diary: RecommendDiaryModel) {
        self.soccerDiary = diary
        self.selectedReason = reasons[0]
    }
    
    /// 축구 일기 좋아요 버튼 클릭 이벤트
    func toggleLike() {
        soccerDiary.isLiked.toggle()
        soccerDiary.likes += soccerDiary.isLiked ? 1 : -1
    }
    
    /// 메뉴 버튼 클릭 이벤트
    func toggleDialog() {
        showDialog.toggle()
    }
    
    /// 신고하기 버튼 클릭 이벤트
    func toggleNotifyDialog() {
        showNotifyDialog.toggle()
    }
    
    /// 신고 이유 선택
    func selectedReason(_ id: Int) {
        reasonCode = id
    }
}
