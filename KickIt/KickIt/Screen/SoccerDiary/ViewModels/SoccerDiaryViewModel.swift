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
    @Published var recommendDiarys: [SoccerDiaryDetailViewModel] = [] // 추천 축구 일기 리스트
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 추천 축구 일기 조회
        getRecommendDiarys()
        
        recommendDiarys = [
            SoccerDiaryDetailViewModel(diary: RecommendDiaryModel(diaryId: 1, grade: .ball0, teamUrl: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F33_300300.png", teamName: "토트넘", nickname: "닉네임", diaryDate: "1시간", matchDate: stringToDateString("2024.11.03"), homeTeamName: "토트넘", homeTeamScore: 1, awayTeamName: "아스톤빌라", awayTeamScore: 2, emotion: .miniAngry, diaryContent: "항상 그렇지 뭐... 토트넘은 항상 똑같다. 대체 전술이 언제 바뀔까? 풀백이 공격수하는 이 이상한 전술은 언제까지 갖고 갈 것인지 의문이다. 아니 상대팀에 맞게 전술도 바꾸고 윙어랑 스트라이커 활용도 잘 해야지.. 무슨 풀백 의존도가 이런게 높은 축구를 대체 언제까지 봐야하나 싶다.", isLiked: false, likes: 1000)),
            SoccerDiaryDetailViewModel(diary: RecommendDiaryModel(diaryId: 2, grade: .ball0, teamUrl: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F17_300300.png", teamName: "맨시티", nickname: "닉네임", diaryDate: "3시간", matchDate: stringToDateString("2024.11.02"), homeTeamName: "본머스", homeTeamScore: 2, awayTeamName: "맨시티", awayTeamScore: 1, emotion: .miniBoring, highHeartRate: 100, diaryContent: "오늘 맨시티와 본머스의 경기는 충격이었다. 본머스가 디펜딩 챔피언인 맨시티를 누르고 2-1로 이겼다. 심지어 본머스가 선제골을 넣고 계속 이기고 있는 흐름이었기에 더욱 충격이었다. 맨시티 선수들 부상이 많은 것이 이렇게 악수가 된 것 같다. 다음에는 맨시티가 꼭 이겼으면 좋겠다.", diaryPhotos: ["https://www.news1.kr/_next/image?url=https%3A%2F%2Fi3n.news1.kr%2Fsystem%2Fphotos%2F2024%2F10%2F20%2F6937996%2Fhigh.jpg&w=1920&q=75"], mom: "손흥민", isLiked: false, likes: 100)),
            SoccerDiaryDetailViewModel(diary: RecommendDiaryModel(diaryId: 3, grade: .ball0, teamUrl: "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F3_300300.png", teamName: "울버햄튼", nickname: "닉네임", diaryDate: "3시간", matchDate: stringToDateString( "2024.11.01"), homeTeamName: "울버햄튼", homeTeamScore: 1, awayTeamName: "뉴캐슬", awayTeamScore: 1, emotion: .miniSad, highHeartRate: 100, diaryContent: "오늘 울버햄튼과 뉴캐슬의 경기는 정말 손에 땀을 쥐게 하는 경기였다. 울버햄튼의 수비가 초반부터 뉴캐슬의 공격을 꽤 잘 막아냈지만, 결국 뉴캐슬의 빠른 역습에 무너지고 말았다. \n\n특히 뉴캐슬의 윌슨이 보여준 마무리 능력은 인상적이었다. 하지만 울버햄튼도 쉽게 물러나지 않았다. 후반전에 공격적인 전술로 전환하면서 트라오레의 돌파가 활기를 불어넣었고, 마침내 동점골을 만들어냈다. \n\n경기가 끝나기 직전, 양 팀 모두 결승골을 노리며 치열한 공방을 펼쳤지만, 결국 1-1로 마무리되었다.", diaryPhotos: ["https://dimg.donga.com/wps/NEWS/IMAGE/2024/10/21/130256053.1.jpg", "https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202304/09/990e5d5f-8fe7-4662-82f3-ea7a157f51f9.jpg", "https://flexible.img.hani.co.kr/flexible/normal/970/646/imgdb/original/2024/0211/20240211500449.jpg"], mom: "손흥민", isLiked: false, likes: 189))
        ]
    }
    
    /// 추천 축구 일기 조회
    private func getRecommendDiarys() {
        SoccerDiaryAPI.shared.getRecommendDiary()
            .map { dto in
                let diarys = dto.map { data in
                    SoccerDiaryDetailViewModel(diary: RecommendDiaryModel(
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
                self?.recommendDiarys = diarys
            })
            .store(in: &cancellables)
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
