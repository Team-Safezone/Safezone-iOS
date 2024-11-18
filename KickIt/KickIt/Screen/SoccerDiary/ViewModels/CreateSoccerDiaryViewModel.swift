//
//  CreateSoccerDiaryViewModel.swift
//  KickIt
//
//  Created by 이윤지 on 11/19/24.
//

import Foundation
import Combine

/// 축구 일기 작성 뷰모델
final class CreateSoccerDiaryViewModel: ObservableObject {
    /// 선택한 경기에 대한 최고 심박수
    @Published var highHeartRate: Int?
    
    var cancellables = Set<AnyCancellable>()
    
    init(matchId: Int64) {
        getSoccerDiaryMaxHeartRate(matchId: matchId)
    }
    
    /// 축구 일기 작성 때 보여줄 최고 BPM 조회
    func getSoccerDiaryMaxHeartRate(matchId: Int64) {
        SoccerDiaryAPI.shared.getSoccerDiaryMaxHeartRate(matchId: matchId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            },
            receiveValue: { [weak self] rate in
                self?.highHeartRate = rate
            })
            .store(in: &cancellables)
    }
    
    /// 축구 일기 작성
    func createSoccerDiary(request: CreateSoccerDiaryRequest, files: [MultipartFormFile]?, complete: @escaping (Bool) -> (Void)) {
        SoccerDiaryAPI.shared.createSoccerDiary(request: request, files: files)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    complete(false)
                case .finished:
                    break
                }
            },
            receiveValue: { dto in
                print("축구 일기 작성 응답: \(dto)")
                complete(true)
            })
            .store(in: &cancellables)
    }
}
