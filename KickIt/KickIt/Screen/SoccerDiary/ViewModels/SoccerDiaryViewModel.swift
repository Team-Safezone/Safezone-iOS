//
//  SoccerDiaryViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 10/24/24.
//

import Foundation
import SwiftUI
import Combine

/// 축구 일기 뷰모델
final class SoccerDiaryViewModel: ObservableObject {
    /// 추천 일기 화면 새로고침 요청 횟수
    @Published var requestNum: Int = 0
    
    /// 내 축구 일기 새로고침 요청 횟수
    @Published var myDairyRequestNum: Int = 0
    
    /// 추천 축구 일기 리스트
    @Published var recommendDiarys: [RecommendSoccerDiaryViewModel] = []
    
    /// 내 축구 일기 리스트
    @Published var myDiarys: [MySoccerDiaryViewModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 추천 축구 일기 조회 API 호출
        getRecommendDiarys()
    }
    
    /// 추천 축구 일기 요청 횟수 업데이트
    func updateRequestNum(num: Int) {
        self.requestNum = num
    }
    
    /// 내 축구 일기 요청 횟수 업데이트
    func updateMyDiaryRequestNum(num: Int) {
        self.myDairyRequestNum = num
    }
    
    /// 추천 축구 일기 조회
    func getRecommendDiarys() {
        SoccerDiaryAPI.shared.getRecommendDiary(requestNum: requestNum)
            .map { dto in
                let diarys = dto.map { data in
                    RecommendSoccerDiaryViewModel(diary: RecommendDiaryModel(
                        diaryId: data.diaryId,
                        grade: self.matchGradeImage(data.grade),
                        teamUrl: data.teamUrl,
                        teamName: data.teamName,
                        nickname: data.nickname,
                        diaryDate: data.diaryDate,
                        matchDate: stringToDateString(data.matchDate),
                        homeTeamName: data.homeTeamName,
                        homeTeamScore: data.homeTeamScore,
                        awayTeamName: data.awayTeamName,
                        awayTeamScore: data.awayTeamScore,
                        emotion: self.matchEmotionImage(data.emotion),
                        highHeartRate: data.highHeartRate,
                        diaryContent: data.diaryContent,
                        diaryPhotos: data.diaryPhotos,
                        mom: data.mom,
                        isLiked: data.isLiked,
                        likes: data.likes,
                        isMine: data.isMine
                    ))
                }
                return diarys
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] diarys in
                self?.recommendDiarys += diarys
            })
            .store(in: &cancellables)
    }
    
    /// 내 축구 일기 조회
    func getMyDiarys() {
        SoccerDiaryAPI.shared.getMyDiary(requestNum: myDairyRequestNum)
            .map { dto in
                let diarys = dto.map { data in
                    MySoccerDiaryViewModel(diary: MyDiaryModel(
                        diaryId: data.diaryId,
                        teamUrl: data.teamUrl,
                        teamName: data.teamName,
                        isPublic: data.isPublic,
                        diaryDate: data.diaryDate,
                        matchDate: stringToDateString(data.matchDate),
                        homeTeamName: data.homeTeamName,
                        homeTeamScore: data.homeTeamScore,
                        awayTeamName: data.awayTeamName,
                        awayTeamScore: data.awayTeamScore,
                        emotion: self.matchEmotionImage(data.emotion),
                        highHeartRate: data.highHeartRate,
                        diaryContent: data.diaryContent,
                        diaryPhotos: data.diaryPhotos,
                        mom: data.mom,
                        isLiked: data.isLiked,
                        likes: data.likes
                    ))
                }
                return diarys
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] diarys in
                self?.myDiarys += diarys
            })
            .store(in: &cancellables)
    }
    
    /// 신고한 축구 일기 숨기기
    func hideNotifyDiary(_ diary: RecommendSoccerDiaryViewModel) {
        if let index = recommendDiarys.firstIndex(where: { model in
            model.soccerDiary.diaryId == diary.soccerDiary.diaryId}) {
            recommendDiarys.remove(at: index)
        }
    }
    
    /// 삭제한 축구 일기 숨기기
    func hideDeleteDiary(_ diary: MySoccerDiaryViewModel) {
        if let index = myDiarys.firstIndex(where: { model in
            model.soccerDiary.diaryId == diary.soccerDiary.diaryId}) {
            myDiarys.remove(at: index)
        }
    }
    
    /// 등급 이미지 변환
    private func matchGradeImage(_ grade: Int) -> UIImage {
        switch grade {
        case 1: return .ball0 // 탱탱볼
        case 2: return .ball1 // 브론즈
        case 3: return .ball0 // 실버
        case 4: return .ball1 // 골드
        case 5: return .ball0 // 다이아
        default: return .ball0
        }
    }
    
    /// 이모지 이미지 변환
    private func matchEmotionImage(_ emotionCode: Int) -> UIImage {
        switch emotionCode {
        case 0: return .miniGood
        case 1: return .miniSurprise
        case 2: return .miniHeart
        case 3: return .miniSad
        case 4: return .miniBoring
        case 5: return .miniAngry
        default: return .miniGood
        }
    }
}
