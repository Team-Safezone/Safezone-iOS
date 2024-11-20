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
class HeartRateViewModel: NSObject, ObservableObject {
    // 사용자가 선택한 축구 경기 객체
    var selectedMatch: SoccerMatch
    
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
    
    init(match: SoccerMatch) {
        self.selectedMatch = match
        super.init()
    }
    
    
    // MARK: - API
    
    /// 사용자 심박수 데이터 존재 여부 확인
    private func checkUploadHeartRateData(matchId: Int64, completion: @escaping (Bool) -> Void) {
        MatchEventAPI.shared.checkHeartRateDataExists(matchId: matchId)
            .receive(on: DispatchQueue.main)
            .sink { completionResult in
                switch completionResult {
                case .failure(let error):
                    print("[통계] 사용자 심박수 데이터 존재 여부 확인 실패: \(error)")
                    completion(false)
                case .finished:
                    break
                }
            } receiveValue: { exists in
                print("[통계] 사용자 심박수 데이터 존재 여부: \(exists)")
                completion(exists)
            }
            .store(in: &cancellables)
    }

    /// 심박수 통계 조회
    func getHeartRateStatistics(matchId: Int64) {
        checkUploadHeartRateData(matchId: matchId) { [weak self] exists in
            guard let self = self else { return }
            
            HeartRateAPI.shared.getHeartRateStatistics(matchId: matchId)
                .map {
                    self.heartRateToEntity($0)
                }
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] in
                    self?.statistics = $0
                    if exists {
                        // 존재함 -> healthkit 이용
                        self?.loadUserHeartRates()
                    } else {
                        print("[통계] DB 심박수 없음")
                        self?.loadUserHeartRates()
                    }
                }
                .store(in: &self.cancellables)
        }
    }
    
    /// 심박수 통계 조회 모델 변환 함수(DTO -> Entity)
    /// 설명:  dto에서 entity로 변환해야 하는 데이터가 너무 많아서 따로 함수로 만들었어요!
    ///     참고로 경기 캘린더 뷰모델의 경우, 변환해야 하는 데이터가 많이 없기 때문에 map 부분 내에서 변환 로직을 작성했습니다.
    ///     두 가지 경우 참고하여, 상황에 맞게 클린한 코드를 작성하시면 돼요!
    private func heartRateToEntity(_ dto: HeartRateStatisticsResponse) -> HeartRateStatistics {
        return HeartRateStatistics(
            startDate: dto.startDate,
            endDate: dto.endDate,
            lowHeartRate: dto.lowHeartRate ?? 0,
            highHeartRate: dto.highHeartRate ?? 0,
            minBPM: dto.minBPM ?? 0,
            avgBPM: dto.avgBPM ?? 0,
            maxBPM: dto.maxBPM ?? 0,
            events: dto.event.map { event in
                HeartRateMatchEvent(
                    teamUrl: event.teamUrl ?? "",
                    eventName: event.eventName,
                    player1: event.player1 ?? "",
                    time: event.time
                )
            },
            homeTeamHeartRateRecords: dto.homeTeamHeartRateRecords.map { record in
                HeartRateRecord(
                    heartRate: record.heartRate,
                    date: record.date
                )
            },
            awayTeamHeartRateRecords: dto.awayTeamHeartRateRecords.map { record in
                HeartRateRecord(
                    heartRate: record.heartRate,
                    date: record.date
                )
            },
            homeTeamHeartRate: dto.homeTeamHeartRate.first.map { heartRate in
                HeartRate(
                    min: heartRate.min,
                    avg: heartRate.avg,
                    max: heartRate.max
                )
            } ?? HeartRate(min: 0, avg: 0, max: 0),
            awayTeamHeartRate: dto.awayTeamHeartRate.first.map { heartRate in
                HeartRate(
                    min: heartRate.min,
                    avg: heartRate.avg,
                    max: heartRate.max
                )
            } ?? HeartRate(min: 0, avg: 0, max: 0),
            homeTeamViewerPercentage: dto.homeTeamViewerPercentage
        )
    }
    
    // MARK: - UI
    // 박스이벤트 업데이트
    func updateBoxEventViewModel(at position: CGPoint, in size: CGSize) {
        guard let stats = statistics else { return }
        
        // 시간 계산
        let calculatedTime = Int(round((position.x - 64) * 90 / (size.width - 64))) // 90분 기준으로 수정
        
        // 드래그 시 심박수 데이터 체크, 마지막 유효한 데이터 반환
        if let userHR = userHeartRates.first(where: { $0.date == calculatedTime })?.heartRate {
            lastValidUserHR = Int(userHR)
        }
        
        // 드래그 시 심박수 데이터 체크, 마지막 유효한 데이터 반환
        if let homeHR = stats.homeTeamHeartRateRecords.first(where: { $0.date == calculatedTime })?.heartRate {
            lastValidHomeTeamHR = Int(homeHR)
        }
        
        // 드래그 시 심박수 데이터 체크, 마지막 유효한 데이터 반환
        if let awayHR = stats.awayTeamHeartRateRecords.first(where: { $0.date == calculatedTime })?.heartRate {
            lastValidAwayTeamHR = Int(awayHR)
        }
        
        let event = stats.events.first(where: { $0.time == calculatedTime })
        
        boxEventViewModel = BoxEventViewModel(
            dataPoint: CGFloat(lastValidUserHR ?? 0),
            time: calculatedTime,
            event: event,
            homeTeamEmblemURL: event?.teamUrl,
            homeTeamHR: lastValidHomeTeamHR ?? 0,
            awayTeamHR: lastValidAwayTeamHR ?? 0
        )
    }
    
    // 드래그 유무 체크
    func endDragging() {
        isDragging = false
    }
    
    //MARK: - 사용자 심박수 가져오기
    /// 사용자의 심박수 데이터를 로드하는 함수
    private func loadUserHeartRates() {
        // statistics가 nil이 아닌지 확인
        guard let stats = statistics else { return }
        
        // 심박수 더블 체크
        // lowHeartRate와 highHeartRate가 0인 경우 심박수 수치를 가져오지 않음
        guard stats.lowHeartRate != 0 && stats.highHeartRate != 0 else {
            print("[통계] 사용자가 이 경기를 관람하지 않아 심박수 데이터 가져오지 않음")
            return
        }
        
        // 날짜 형식 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        // 경기 시작 시간과 종료 시간을 파싱
        guard let matchStartTime = dateFormatter.date(from: stats.startDate),
              let matchEndTime = dateFormatter.date(from: stats.endDate) else {
            print("[통계] 시작 - 끝 시간을 계산하는데 실패함")
            return
        }
        
        // 하프타임 설정 (15분)
        let halfTime = 15 * 60
        // 전반전 종료 시간 계산
        let firstHalfEnd = matchStartTime.addingTimeInterval(45 * 60)
        // 후반전 시작 시간 계산
        let secondHalfStart = firstHalfEnd.addingTimeInterval(TimeInterval(halfTime))
        
        // 전반전 심박수 데이터 로드 (경기 시작 5분 후부터)
        heartRateRecordModel.loadHeartRate(startDate: matchStartTime.addingTimeInterval(5 * 60), endDate: firstHalfEnd.addingTimeInterval(5 * 60)) { [weak self] firstHalfRecords in
            // 후반전 심박수 데이터 로드 (후반전 시작 5분 후부터)
            self?.heartRateRecordModel.loadHeartRate(startDate: secondHalfStart.addingTimeInterval(5 * 60), endDate: matchEndTime.addingTimeInterval(5 * 60)) { secondHalfRecords in
                let allRecords = firstHalfRecords + secondHalfRecords
                // 심박수 데이터를 HeartRateRecord 형식으로 변환
                self?.userHeartRates = allRecords.map { HeartRateRecord(heartRate: CGFloat($0.heartRate), date: self?.minutesSinceMatchStart(date: $0.date, matchStartTime: matchStartTime) ?? 0) }
                self?.objectWillChange.send()
            }
        }
    }
    
    // 사용자 심박수 fetch를 위한 경기 시간 계산
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
        let viewModel = HeartRateViewModel(match: dummySoccerMatches[0])
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
