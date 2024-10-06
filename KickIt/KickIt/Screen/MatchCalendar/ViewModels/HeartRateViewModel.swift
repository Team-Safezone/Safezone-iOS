//
//  HeartRateViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 7/28/24.
//

import Foundation
import Combine

/// 심박수 통계 조회 화면의 뷰모델
/// 설명: 뷰모델에서 데이터 변환(DTO -> Entity), 응답에 따른 에러 핸들링을 처리하기
class HeartRateViewModel: ObservableObject {
    // 심박수 통계 API
    @Published var statistics: HeartRateStatistics?
    
    // 사용자 심박수 호출
    @Published var userHeartRates: [HeartRateRecord] = []
    private var heartRateRecordModel = HeartRateRecordModel()
    
    // 그래프 그리기 & 드래그
    @Published var boxEventViewModel: BoxEventViewModel?
    @Published var isDragging = false
    @Published var pathPosition = CGPoint.zero
    
    private var lastValidUserHR: Int?
    private var lastValidHomeTeamHR: Int?
    private var lastValidAwayTeamHR: Int?
    

    private var cancellables = Set<AnyCancellable>()
    
    
    /// 심박수 통계 조회
    func getHeartRateStatistics(request: HeartRateStatisticsRequest) {
        HeartRateAPI.shared.getHeartRateStatistics(request: request)
        // DTO -> Entity로 변경
            .map {
                self.heartRateToEntity($0)
            }
        // 메인 스레드에서 데이터 처리
            .receive(on: DispatchQueue.main)
        // publisher 결과 구독
            .sink { completion in
                switch completion {
                case .failure(let error):
                    // FIXME: 추후, 현진이가 에러 핸들링 디자인해 주면, 전역 함수 만들어서 해당 코드 교체할 예정!
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] in
                self?.statistics = $0
            }
            .store(in: &cancellables)
    }
    
    /// 심박수 통계 조회 모델 변환 함수(DTO -> Entity)
    /// 설명:  dto에서 entity로 변환해야 하는 데이터가 너무 많아서 따로 함수로 만들었어요!
    ///     참고로 경기 캘린더 뷰모델의 경우, 변환해야 하는 데이터가 많이 없기 때문에 map 부분 내에서 변환 로직을 작성했습니다.
    ///     두 가지 경우 참고하여, 상황에 맞게 클린한 코드를 작성하시면 돼요!
    private func heartRateToEntity(_ dto: HeartRateStatisticsResponse) -> HeartRateStatistics {
        return HeartRateStatistics(
            startDate: dto.startDate ?? "",
            endDate: dto.endDate ?? "",
            lowHeartRate: dto.lowHeartRate ?? 0,
            highHeartRate: dto.highHeartRate ?? 0,
            minBPM: dto.minBPM ?? 0,
            avgBPM: dto.avgBPM ?? 0,
            maxBPM: dto.maxBPM ?? 0,
            events: dto.events?.map { event in
                HeartRateMatchEvent(
                    teamURL: event.teamURL,
                    eventName: event.eventName,
                    player1: event.player1,
                    eventMTime: event.eventMTime
                )
            } ?? [],
            homeTeamHeartRateRecords: dto.homeTeamHeartRateRecords?.map { record in
                HeartRateRecord(
                    heartRate: record.heartRate,
                    heartRateRecordTime: record.heartRateRecordTime
                )
            } ?? [],
            awayTeamHeartRateRecords: dto.awayTeamHeartRateRecords?.map { record in
                HeartRateRecord(
                    heartRate: record.heartRate,
                    heartRateRecordTime: record.heartRateRecordTime
                )
            } ?? [],
            homeTeamHeartRate: dto.homeTeamHeartRate.map { heartRate in
                HeartRate(
                    min: heartRate.min,
                    avg: heartRate.avg,
                    max: heartRate.max
                )
            } ?? HeartRate(min: 0, avg: 0, max: 0),
            awayTeamHeartRate: dto.awayTeamHeartRate.map { heartRate in
                HeartRate(
                    min: heartRate.min,
                    avg: heartRate.avg,
                    max: heartRate.max
                )
            } ?? HeartRate(min: 0, avg: 0, max: 0),
            homeTeamViewerPercentage: dto.homeTeamViewerPercantage ?? 0
        )
    }
    
    // 박스이벤트 업데이트
    func updateBoxEventViewModel(at position: CGPoint, in size: CGSize) {
        guard let stats = statistics else { return }
        
        // 시간 계산
        let calculatedTime = Int(round((position.x - 64) * 90 / (size.width - 64))) // 90분 기준으로 수정
        
        // 드래그 시 심박수 데이터 체크, 마지막 유효한 데이터 반환
        if let userHR = userHeartRates.first(where: { $0.heartRateRecordTime == calculatedTime })?.heartRate {
            lastValidUserHR = Int(userHR)
        }
        
        // 드래그 시 심박수 데이터 체크, 마지막 유효한 데이터 반환
        if let homeHR = stats.homeTeamHeartRateRecords.first(where: { $0.heartRateRecordTime == calculatedTime })?.heartRate {
            lastValidHomeTeamHR = Int(homeHR)
        }
        
        // 드래그 시 심박수 데이터 체크, 마지막 유효한 데이터 반환
        if let awayHR = stats.awayTeamHeartRateRecords.first(where: { $0.heartRateRecordTime == calculatedTime })?.heartRate {
            lastValidAwayTeamHR = Int(awayHR)
        }
        
        let event = stats.events.first(where: { $0.eventMTime == calculatedTime })
        
        boxEventViewModel = BoxEventViewModel(
            dataPoint: CGFloat(lastValidUserHR ?? 0),
            time: calculatedTime,
            event: event,
            homeTeamEmblemURL: event?.teamURL,
            homeTeamHR: lastValidHomeTeamHR ?? 0,
            awayTeamHR: lastValidAwayTeamHR ?? 0
        )
    }
    
    // 드래그 유무 체크
    func endDragging() {
        isDragging = false
    }
    
    //MARK: - 사용자 심박수 가져오기
    private func loadUserHeartRates() {
        guard let stats = statistics else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let matchStartTime = dateFormatter.date(from: stats.startDate),
              let matchEndTime = dateFormatter.date(from: stats.endDate) else {
            print("Failed to parse match start or end time")
            return
        }
        
        let halfTime = 15 * 60 // 15 minutes in seconds
        let firstHalfEnd = matchStartTime.addingTimeInterval(45 * 60)
        let secondHalfStart = firstHalfEnd.addingTimeInterval(TimeInterval(halfTime))
        
        heartRateRecordModel.loadHeartRate(startDate: matchStartTime.addingTimeInterval(5 * 60), endDate: firstHalfEnd.addingTimeInterval(5 * 60)) { [weak self] firstHalfRecords in
            self?.heartRateRecordModel.loadHeartRate(startDate: secondHalfStart.addingTimeInterval(5 * 60), endDate: matchEndTime.addingTimeInterval(5 * 60)) { secondHalfRecords in
                let allRecords = firstHalfRecords + secondHalfRecords
                self?.userHeartRates = allRecords.map { HeartRateRecord(heartRate: CGFloat($0.heartRate), heartRateRecordTime: self?.minutesSinceMatchStart(date: $0.date, matchStartTime: matchStartTime) ?? 0) }
                self?.objectWillChange.send()
            }
        }
    }
    
    // 사용자 심박수 fetch를 위한 시간 계산
    private func minutesSinceMatchStart(date: String?, matchStartTime: Date) -> Int {
        guard let dateString = date else { return 0 }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        guard let recordDate = dateFormatter.date(from: dateString) else { return 0 }
        
        let timeInterval = recordDate.timeIntervalSince(matchStartTime)
        return Int(timeInterval / 60)
    }
}

// 프리뷰 시 더미데이터 출력
extension HeartRateViewModel {
    static func withDummyData() -> HeartRateViewModel {
        let viewModel = HeartRateViewModel()
        viewModel.statistics = HeartRateStatistics(
            startDate: "2024/10/05 8:33",
            endDate: "2024/10/05 10:06",
            lowHeartRate: 60,
            highHeartRate: 120,
            minBPM: 55,
            avgBPM: 80,
            maxBPM: 110,
            events: DummyData.heartRateMatchEvents,
            homeTeamHeartRateRecords: DummyData.homeTeamHeartRateRecords,
            awayTeamHeartRateRecords: DummyData.awayTeamHeartRateRecords,
            homeTeamHeartRate: HeartRate(min: 60, avg: 75, max: 90),
            awayTeamHeartRate: HeartRate(min: 65, avg: 80, max: 95),
            homeTeamViewerPercentage: 55
        )
        return viewModel
    }
}
