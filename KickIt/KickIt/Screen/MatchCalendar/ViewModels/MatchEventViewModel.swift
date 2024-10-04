//
//  MatchEventViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 7/29/24.
//

import Combine
import SwiftUI
import WatchConnectivity

// 타임라인 화면 뷰모델
class MatchEventViewModel: NSObject, ObservableObject, WCSessionDelegate {
    // Timeline API
    @Published var match: SoccerMatch
    @Published var matchEvents: [MatchEventsData] = []
    @Published var matchStartTime: Date?
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // 평균 심박수
    @Published var userAverageHeartRate: Int?
    
    // 사용자 경기 심박수 POST API
    @Published var isHeartRateDataUploaded = false
    var heartRateDates: [HeartRateDate] = []
    
    // DateFormatter 인스턴스
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }()
    
    // watch - ios
    @Published var errorMessage: String? // 에러 메시지
    @Published var wcSessionState: WCSessionActivationState = .notActivated
    private var session: WCSession?
    
    @Published var currentMatchId: Int64? {
        didSet {
            if let matchId = currentMatchId {
                UserDefaults.standard.set(matchId, forKey: "currentMatchId")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentMatchId")
            }
        }
    }
    
    // MARK: - API
    // 타임라인 GET
    func fetchMatchEvents() {
        guard !isLoading else { return }
        isLoading = true
        
        MatchEventAPI.shared.getMatchEvents(request: MatchEventsRequest(matchId: match.id))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching match events: \(error)")
                }
            } receiveValue: { [weak self] response in
                self?.matchEvents = response.data
                print("Received \(response.data.count) events")
                self?.updateMatchCode()
                self?.setMatchStartTime()
                self?.loadHeartRateData()
            }
    }
    
    // 사용자 평균 심박수 GET
    func fetchUserAverageHeartRate() {
        AvgHeartRateAPI.shared.getUserAverageHeartRate()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error fetching user average heart rate: \(error)")
                }
            } receiveValue: { [weak self] averageHeartRate in
                self?.userAverageHeartRate = averageHeartRate
            }
            .store(in: &cancellables)
    }
    
    // onChange 호출 함수
    func handleMatchEnd() {
        guard match.matchCode == 3, // 경기가 종료되었는지 확인
              currentMatchId == match.id, // 현재 경기가 사용자가 선택한 경기인지 확인
              !isHeartRateDataUploaded else { return }
        
        checkAndUploadHeartRateData()
    }
    
    // 사용자 심박수 데이터 존재 여부 GET
    private func checkAndUploadHeartRateData() {
        MatchEventAPI.shared.checkHeartRateDataExists(request: HeartRateDataExistsRequest(matchId: match.id))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Failed to check heart rate data: \(error)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                if !response.exists {
                    self.uploadHeartRateData()
                } else {
                    self.isHeartRateDataUploaded = true
                    print("Heart rate data already exists for this match")
                }
            }
            .store(in: &cancellables)
    }
    
    // 사용자 심박수 POST
    func uploadHeartRateData() {
        guard let startTime = matchStartTime else { return }

        let endTime = Date()

        // 시작 시간부터 종료 시간까지의 심박수 데이터 가져오기
        let heartRateData = heartRateDates.filter { record in
            guard let recordDate = dateFormatter.date(from: record.date) else { return false }
            return recordDate >= startTime && recordDate <= endTime
        }

        // 5분 지연 적용 및 데이터 변환
        let delayedHeartRateData = heartRateData.map { record -> MatchHeartRateRecord in
            guard let recordDate = dateFormatter.date(from: record.date) else {
                return MatchHeartRateRecord(heartRate: 0, date: "")
            }
            let delayedDate = recordDate.addingTimeInterval(-5 * 60)
            let formattedDate = dateFormatter.string(from: delayedDate)

            return MatchHeartRateRecord(heartRate: Int(record.heartRate), date: formattedDate)
        }

        let request = MatchHeartRateRequest(matchId: match.id, MatchHeartRateRecords: delayedHeartRateData)

        // API 호출
        MatchEventAPI.shared.postMatchHeartRate(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("Heart rate data uploaded successfully")
                    self?.isHeartRateDataUploaded = true
                case .failure(let error):
                    print("Failed to upload heart rate data: \(error)")
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }

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
    
    //MARK: - 심박수 관련 함수
    // 심박수 기능 사용
    private let heartRateModel = HeartRateRecordModel()
    
    init(match: SoccerMatch) {
        self.match = match
        super.init()
        setupWCSession()
        loadCurrentMatchId()
        authorizeHealthKit()
    }
    
    private func setupWCSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    // 심박수 권한 사용
    private func authorizeHealthKit() {
        heartRateModel.authorizeHealthKit { success in
            if success {
                self.loadHeartRateData()
            }
        }
    }
    
    // 심박수 로딩 사용
    func loadHeartRateData() {
        guard let startTime = matchStartTime else { return }
        let endTime = Date()
        
        heartRateModel.loadHeartRate(startDate: startTime, endDate: endTime) { [weak self] records in
            DispatchQueue.main.async {
                self?.objectWillChange.send()
            }
        }
    }
    
    // 심박수 가져오기 사용
    func getHeartRate(for eventTime: String) -> Int? {
        return heartRateModel.getHeartRate(for: eventTime)
    }
    
    //MARK: - UI 관련 함수
    // 경기 코드 반영
    private func updateMatchCode() {
        if let lastEventCode = matchEvents.last?.eventCode {
            match.matchCode = lastEventCode == 6 ? 3 : (lastEventCode == 2 ? 2 : 1)
        }
    }
    
    // 경기 시작 시각 설정
    private func setMatchStartTime() {
        if let startEvent = matchEvents.first(where: { $0.eventCode == 0 }) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            matchStartTime = dateFormatter.date(from: startEvent.eventTime)
        }
    }
    
    // 경기 코드에 따른 색상
    func getStatusColor() -> Color {
        switch match.matchCode {
        case 0: return Color.white0
        case 1, 2: return Color.lime
        case 3: return Color.gray800
        case 4: return Color.red0
        default: return Color.white0
        }
    }
    
    // 경기 코드에 따른 글
    func getStatusText() -> String {
        switch match.matchCode {
        case 0: return "경기예정"
        case 1: return "실시간"
        case 2: return "휴식"
        case 3: return "경기종료"
        case 4: return "경기연기"
        default: return ""
        }
    }
    
    // 경기 코드에 따른 글자 색상
    func getStatusTextColor() -> Color {
        switch match.matchCode {
        case 0: return Color.black0
        case 3: return Color.gray300
        default: return Color.black0
        }
    }
}
