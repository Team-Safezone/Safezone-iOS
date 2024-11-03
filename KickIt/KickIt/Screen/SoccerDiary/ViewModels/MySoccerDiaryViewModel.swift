//
//  MySoccerDiaryViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 11/3/24.
//

import Foundation

/// 내 축구 일기 뷰모델
final class MySoccerDiaryViewModel: ObservableObject {
    /// 내 축구 일기 리스트
    @Published var soccerDiary: MyDiaryModel
    
    /// 추천 일기의 menu 버튼 클릭 이벤트
    @Published var showDialog: Bool = false
    
    init(diary: MyDiaryModel) {
        self.soccerDiary = diary
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
}
