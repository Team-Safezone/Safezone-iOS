//
//  MySoccerDiaryViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 11/3/24.
//

import Foundation
import Combine

/// 내 축구 일기 뷰모델
final class MySoccerDiaryViewModel: ObservableObject {
    /// 내 축구 일기 리스트
    @Published var soccerDiary: MyDiaryModel
    
    /// 추천 일기의 menu 버튼 클릭 이벤트
    @Published var showDialog: Bool = false
    
    /// 삭제하기 버튼 클릭 이벤트
    @Published var showDeleteDialog: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(diary: MyDiaryModel) {
        self.soccerDiary = diary
    }
    
    /// 축구 일기 좋아요 버튼 클릭 이벤트
    func toggleLike() {
        soccerDiary.isLiked.toggle()
        soccerDiary.likes += soccerDiary.isLiked ? 1 : -1
        patchLikeDiary(request: DiaryLikeRequest(diaryId: soccerDiary.diaryId, isLiked: soccerDiary.isLiked))
        print("아이디: \(soccerDiary.diaryId) | 좋아요 여부: \(soccerDiary.isLiked)")
    }
    
    /// 메뉴 버튼 클릭 이벤트
    func toggleDialog() {
        showDialog.toggle()
    }
    
    /// 삭제하기 메뉴 클릭 이벤트
    func toggleDeleteDialog() {
        showDeleteDialog.toggle()
    }
    
    /// 삭제 버튼 클릭 이벤트
    func deleteDiaryEvent() {
        deleteDiary(request: DiaryDeleteRequest(diaryId: soccerDiary.diaryId))
    }
    
    /// 축구 일기 좋아요 버튼 클릭 이벤트
    func patchLikeDiary(request: DiaryLikeRequest) {
        SoccerDiaryAPI.shared.patchLikeDiary(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            },
            receiveValue: { dto in
                print("축구 일기 좋아요 클릭 이벤트 응답: \(dto)")
            })
            .store(in: &cancellables)
    }
    
    /// 축구 일기 삭제 이벤트
    func deleteDiary(request: DiaryDeleteRequest) {
        SoccerDiaryAPI.shared.deleteDiary(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            },
            receiveValue: { dto in
                print("축구 일기 삭제 이벤트 응답: \(dto)")
            })
            .store(in: &cancellables)
    }
}
