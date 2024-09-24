//
//  HeartRateViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 7/28/24.
//

import Foundation
import Combine
import WatchConnectivity

/// 심박수 통계 조회 화면의 뷰모델
/// 설명: 뷰모델에서 데이터 변환(DTO -> Entity), 응답에 따른 에러 핸들링을 처리하기
final class HeartRateViewModel: NSObject, HeartRateViewModelProtocol, WCSessionDelegate {
    
    @Published var statistics: HeartRateStatistics? /// 심박수 통계 조회 결과 모델
    @Published var currentMatchId: Int64? {  // 사용자가 관람한 경기 id
        didSet {
            if let matchId = currentMatchId {
                UserDefaults.standard.set(matchId, forKey: "currentMatchId")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentMatchId")
            }
        }
    }
    
    @Published var errorMessage: String? // 에러 메시지
    @Published var wcSessionState: WCSessionActivationState = .notActivated // WCSession 활성화 상태
    
    private var cancellables = Set<AnyCancellable>()
    private var session: WCSession?
    
    override init() {
            super.init()
            setupWCSession()
            loadCurrentMatchId()
    }
    
    /// WCSession 설정 및 활성화
    private func setupWCSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    //    @Published var dataPoints: [CGFloat] = []
    //    @Published var dataTime: [Int] = []
    //    @Published var arrayHR: [HeartRateRecord] = []
    //    @Published var homeTeamPercentage: Int = 0
    //    @Published var teamHeartRateData: HeartRateData?
    //
    //    private var model = HeartRateRecord()
    
    //    init() {
    ////        model.authorizeHealthKit { [weak self] success in
    ////            if success {
    ////                self?.updateHeartRateData()
    ////            }
    ////        }
    //    }
    
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
                    eventTime: event.eventTime
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
            homeTeamHeartRate: dto.homeTeamHeartRate.map{ heartRate in
                HeartRate(
                    min: heartRate.min,
                    avg: heartRate.avg,
                    max: heartRate.max
                )
            } ?? HeartRate(min: 0, avg: 0, max: 0),
            awayTeamHeartRate: dto.awayTeamHeartRate.map{ heartRate in
                HeartRate(
                    min: heartRate.min,
                    avg: heartRate.avg,
                    max: heartRate.max
                )
            } ?? HeartRate(min: 0, avg: 0, max: 0),
            homeTeamViewerPercentage: dto.homeTeamViewerPercantage ?? 0
        )
    }
    
    // 사용자 심박수 업로드 함수
    func uploadUserHeartRate(teamName: String, min: Double, avg: Double, max: Double) {
        guard let matchId = currentMatchId else { return }
        
        // TODO: API 호출 로직 구현
        // TODO: matchId, teamName, min, avg, max 값을 사용하여 서버에 데이터 업로드
    }
    
    /// 심박수 업데이트 함수
    func updateHeartRateData(useDummyData: Bool = false) {
        //        let startDate = Calendar.current.date(from: setStartTime()) ?? Date() // 경기 시작 날짜
        //        let endDate = Calendar.current.date(from: setEndTime()) ?? Date() // 경기 종료 날짜
        //        if useDummyData {
        //            self.arrayHR = DummyData.heartRateRecords
        //        } else {
        //            model.loadHeartRate(startDate: startDate, endDate: endDate) { [weak self] records in
        //                DispatchQueue.main.async {
        //                    self?.arrayHR = records.reversed()
        //                    self?.dataPoints = records.map { CGFloat($0.heartRate) }
        //                    self?.dataTime = records.compactMap { minutesExtracted(from: $0.date) }
        ////                    let _ = print(self?.arrayHR)
        //                }
        //            }
    }
    
    /// 사용자의 심박수 데이터 업로드
    //        func uploadUserHeartRate(teamName: String, min: Double, avg: Double, max: Double) {
    //            HeartRateAPI.shared.postUserHeartRate(teamName: teamName, min: min, avg: avg, max: max)
    //                .sink(receiveCompletion: { completion in
    //                    switch completion {
    //                    case .finished:
    //                        break
    //                    case .failure(let error):
    //                        print("Error uploading user heart rate: \(error)")
    //                    }
    //                }, receiveValue: { success in
    //                    if success {
    //                        print("User heart rate uploaded successfully")
    //                    }
    //                })
    //                .store(in: &cancellables)
    //        }
    //    }
    
    

    // MARK: - iOS 데이터 저장
    /// 앱 재시작 시 저장된 matchId 불러오기
    private func loadCurrentMatchId() {
        if let savedMatchId = UserDefaults.standard.value(forKey: "currentMatchId") as? Int64 {
            currentMatchId = savedMatchId
        }
    }
    
    // iOS가 꺼졌을 때도 currentMatchId 보존
    func saveMatchId(_ matchId: Int64) {
        self.currentMatchId = matchId
    }
    
    // MARK: - WCSessionDelegate 메서드
    /// WCSession이 비활성화될 때 호출
        func sessionDidBecomeInactive(_ session: WCSession) {
            DispatchQueue.main.async {
                self.errorMessage = "iOS WCSession became inactive"
            }
        }

        /// WCSession이 비활성화된 후 호출
        func sessionDidDeactivate(_ session: WCSession) {
            DispatchQueue.main.async {
                self.errorMessage = "iOS WCSession deactivated"
            }
            // 세션 재활성화
//            WCSession.default.activate()
        }
    

    /// iOS 기기로부터 메시지 받을 때 호출 (필수 구현)
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: (([String : Any]) -> Void)? = nil) {
        DispatchQueue.main.async {
            if let matchId = message["matchId"] as? Int64 {
                self.currentMatchId = matchId
                print("Received match ID: \(matchId)")
                
                // 필요에 따라 응답 메시지 처리
                replyHandler?(["response": "Match ID received"])
            } else {
                self.errorMessage = "Invalid data received"
            }
        }
    }
    
    
    /// 오류 처리 메서드: 메시지 전송 실패 시 호출
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        if let error = error {
            print("Message delivery failed: \(error.localizedDescription)")
        } else {
            print("Message delivered successfully")
        }
    }
    
    /// WCSession 활성화 완료 시 호출
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.wcSessionState = activationState
            if let error = error {
                self.errorMessage = "iOS WCSession activation error: \(error.localizedDescription)"
            } else {
                switch activationState {
                case .activated:
                    self.errorMessage = nil
                case .inactive:
                    self.errorMessage = "iOS WCSession is inactive"
                case .notActivated:
                    self.errorMessage = "iOS WCSession is not activated"
                @unknown default:
                    self.errorMessage = "iOS Unknown WCSession state"
                }
            }
        }
    }
}
