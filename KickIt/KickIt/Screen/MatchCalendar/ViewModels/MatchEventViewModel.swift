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
class MatchEventViewModel: NSObject, ObservableObject {
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
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    init(match: SoccerMatch) {
        self.match = match
        super.init()
        setupWatchSessionManager()    // 워치 세션 활성화
        loadCurrentMatchId()    // 앱 재시작 시 저장된 matchId 불러오기
        authorizeHealthKit()    // 심박수 권한 허용
    }
    
    // watch - ios
    @Published var errorMessage: String?
    @Published var wcSessionState: WCSessionActivationState = .notActivated
    @Published var currentMatchId: Int64? {
        didSet {
            if let matchId = currentMatchId {
                UserDefaults.standard.set(matchId, forKey: "currentMatchId")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentMatchId")
            }
        }
    }
    
    
    private func setupWatchSessionManager() {
        WatchSessionManager.shared.onMatchIdReceived = { [weak self] matchId in
            self?.currentMatchId = matchId
            print("[타임라인] Received match ID: \(matchId)")
        }
    }
    
    // iOS가 꺼졌을 때도 currentMatchId 보존
    func saveMatchId(_ matchId: Int64) {
        self.currentMatchId = matchId
        WatchSessionManager.shared.sendMatchIdToWatch(matchId)
    }
    
    /// 앱 재시작 시 저장된 matchId 불러오기
    private func loadCurrentMatchId() {
        if let savedMatchId = UserDefaults.standard.value(forKey: "currentMatchId") as? Int64 {
            currentMatchId = savedMatchId
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
                switch completion {
                case .finished:
                    print("[타임라인] Successfully fetched 경기 이벤트")
                case .failure(let error):
                    print("[타임라인] Error fetching 경기 이벤트: \(error)")
                }
            } receiveValue: { [weak self] events in
                self?.matchEvents = events
                print("[타임라인] Received \(events.count) events")
                self?.updateMatchCode()
                self?.setMatchStartTime()
                self?.loadHeartRateData()
            }
            .store(in: &cancellables)
    }
    
    // 사용자 평균 심박수 GET
    //    func fetchUserAverageHeartRate() {
    //        MatchEventAPI.shared.getUserAverageHeartRate()
    //            .receive(on: DispatchQueue.main)
    //            .sink { completion in
    //                switch completion {
    //                case .finished:
    //                    print("[타임라인] Successfully fetched user average heart rate")
    //                case .failure(let error):
    //                    print("[타임라인] Error fetching user average heart rate: \(error)")
    //                }
    //            } receiveValue: { [weak self] avgHeartRate in
    //                self?.userAverageHeartRate = avgHeartRate
    //            }
    //            .store(in: &cancellables)
    //    }
    
    // MARK: - 경기 종료 처리
    
    /// 경기 종료 시 호출되는 함수
    func handleMatchEnd() {
        print("[타임라인] 경기 종료 \(match.matchCode), watchid \(currentMatchId ?? 0) match.id \(match.id)")
        guard match.matchCode == 3, // 경기가 종료되었는지 확인
              currentMatchId == match.id, // 현재 경기가 사용자가 선택한 경기인지 확인
              !isHeartRateDataUploaded else { return }
        
        // 사용자 심박수 데이터 존재 여부 확인
        checkAndUploadHeartRateData()
    }
    
    /// 사용자 심박수 데이터 존재 여부 확인 및 업로드
    private func checkAndUploadHeartRateData() {
        MatchEventAPI.shared.checkHeartRateDataExists(matchId: match.id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("[타임라인] 사용자 심박수 데이터 존재 여부 확인 실패: \(error)")
                    // 실패 시 10초 후에 다시 시도
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        self.uploadHeartRateData()  // POST
                    }
                }
            } receiveValue: { [weak self] exists in
                guard let self = self else { return }
                if !exists {
                    print("[타임라인] 사용자 심박수 데이터가 존재하지 않음. 업로드 시작.")
                    // 데이터가 존재하지 않을 경우 10초 후에 업로드
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        self.uploadHeartRateData()  // POST
                    }
                } else {
                    self.isHeartRateDataUploaded = true
                    print("[타임라인] 사용자 심박수 데이터 이미 존재함")
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 심박수 데이터 업로드
    /// 사용자 심박수 데이터 업로드
    private func uploadHeartRateData() {
        guard let startTime = matchStartTime else {
            print("[타임라인] POST 경기 시작 시각 설정 불가")
            return
        }
        
        // 경기 종료 시각을 matchEvents에서 eventCode가 6인 마지막 이벤트의 eventTime으로 설정
        guard let endEvent = matchEvents.last(where: { $0.eventCode == 6 }) else {
            print("[타임라인] 종료 이벤트를 찾을 수 없음")
            return
        }
        guard let endTime = stringToDate3(date: endEvent.eventTime) else {
            print("[타임라인] POST 경기 종료 시각 설정 불가")
            return
        }
        
        
        let adjustedStartTime = startTime.addingTimeInterval(5 * 60) // 경기 시작 시각 + 5분
        let adjustedEndTime = endTime.addingTimeInterval(5 * 60) // 경기 종료 시각 + 5분
        
        var heartRateRecords: [matchHeartRateRecord] = []
        
        // 5분마다의 심박수 기록 추가
        var currentTime = adjustedStartTime
        var elapsedMinutes = 0 // 시작 시각부터의 경과 분
        while currentTime <= adjustedEndTime {
            if let heartRate = getClosestHeartRate(for: currentTime) {
                heartRateRecords.append(matchHeartRateRecord(heartRate: heartRate, date: elapsedMinutes))
                print("[타임라인] 추가된 심박수 기록: \(heartRate) at \(elapsedMinutes) minutes")
            } else {
                print("[타임라인] \(currentTime)에서의 심박수 데이터 없음.")
            }
            currentTime = currentTime.addingTimeInterval(5 * 60) // 5분 간격
            elapsedMinutes += 5
        }
        
        // 경기 이벤트에 대한 심박수 기록 추가
        for event in matchEvents {
            if let heartRate = getHeartRate(for: event.eventTime) {
                let record = matchHeartRateRecord(heartRate: heartRate, date: event.time ?? 0)
                if !heartRateRecords.contains(where: { $0.date == record.date }) {
                    heartRateRecords.append(record)
                    print("[타임라인] 이벤트로부터 추가된 심박수 기록: \(heartRate) at \(event.time ?? 0) minutes")
                } else {
                    print("[타임라인] 중복된 심박수 기록 발견: \(record.date)")
                }
            } else {
                print("[타임라인] 이벤트 시간 \(event.time ?? 0)에서의 심박수 데이터 없음.")
            }
        }
        
        // 중복 제거 및 정렬
        heartRateRecords = Array(Set(heartRateRecords)).sorted { $0.date < $1.date }
        print("[타임라인] POST 예정 데이터 \(heartRateRecords)")
        
        let request = MatchHeartRateRequest(matchId: match.id, matchHeartRateRecords: heartRateRecords)
        
        // API 호출
        MatchEventAPI.shared.postMatchHeartRate(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("[타임라인] Heart rate data uploaded successfully")
                    self?.isHeartRateDataUploaded = true
                case .failure(let error):
                    print("[타임라인] Failed to upload heart rate data: \(error)")
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    // 가장 가까운 심박수 기록
    private func getClosestHeartRate(for date: Date) -> Int? {
        return heartRateModel.getHeartRate(for: dateToString4(date4: date))
    }
    
    // 특정 이벤트 시간에 대한 심박수 가져오기
    func getHeartRate(for eventTime: String) -> Int? {
        let heartRate = heartRateModel.getHeartRate(for: eventTime)
        print("[타임라인] Heart rate for event at \(eventTime): \(heartRate ?? -1)")
        return heartRate
    }
    
    //MARK: - 심박수 관련 프로퍼티 및 함수
    private let heartRateModel = HeartRateRecordModel()
    @Published var heartRateRecords: [HeartRateDate] = []
    
    // 심박수 권한 요청
    private func authorizeHealthKit() {
        heartRateModel.authorizeHealthKit { [weak self] success in
            if success {
                self?.loadHeartRateData()
            } else {
                print("[타임라인] Failed to authorize HealthKit")
            }
        }
    }
    
    // 심박수 데이터 로딩
    func loadHeartRateData() {
        guard let startTime = matchStartTime else {
            print("[타임라인] 심박수 로딩 경기 시작 시각 설정 불가")
            return
        }
        let endTime = Date()
        
        heartRateModel.loadHeartRate(startDate: startTime, endDate: endTime) { [weak self] records in
            DispatchQueue.main.async {
                self?.heartRateRecords = records
                self?.objectWillChange.send()
                print("[타임라인] Loaded \(records.count) heart rate records")
            }
        }
    }
    
    //MARK: - UI 관련 함수
    // 경기 코드 반영
    private func updateMatchCode() {
        if let lastEventCode = matchEvents.last?.eventCode {
            match.matchCode = lastEventCode == 6 ? 3 : (lastEventCode == 2 ? 2 : 1)
            match.homeTeamScore = Int(matchEvents.last?.player1 ?? "") ?? 0
            match.awayTeamScore = Int(matchEvents.last?.player2 ?? "") ?? 0
        }
    }
    
    // 경기 시작 시각 설정
    private func setMatchStartTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        // eventCode = 0인 이벤트 기준 경기 시작 시각 설정
        if let startEvent = matchEvents.first(where: { $0.eventCode == 0 }) {
            matchStartTime = dateFormatter.date(from: startEvent.eventTime)
            print("[타임라인] eventCode = 0 matchStartTime: \(matchStartTime!)")
        } else {
            // eventCode = 0인 이벤트가 없는 경우
            print("[타임라인] eventCode = x matchStartTime: \(matchStartTime!)")
            matchStartTime = match.matchTime
            print("[타임라인] reset - matchStartTime: \(matchStartTime!)")
            //            matchStartTime = matchEvents.compactMap { dateFormatter.date(from: $0.eventTime) }.min()
        }
        
        if matchStartTime == nil {
            print("[타임라인] Failed to set match start time")
        }
    }
    
    // 경기 코드에 따른 색상
    func getStatusColor() -> Color {
        switch match.matchCode {
        case 0: return Color.whiteText
        case 1, 2: return Color.lime
        case 3: return Color.gray900
        case 4: return Color.gray800Assets
        default: return Color.white0
        }
    }
    
    // 경기 코드에 따른 글
    func getStatusText() -> String { // 경기 상태(0: 예정, 1: 경기중, 2: 휴식, 3: 종료, 4: 연기)
        switch match.matchCode {
        case 0: return "경기예정"
        case 1, 2: return "경기중"
        case 3: return "경기종료"
        case 4: return "연기"
        default: return ""
        }
    }
    
    // 경기 코드에 따른 글자 색상
    func getStatusTextColor() -> Color { // 경기 상태(0: 예정, 1: 경기중, 2: 휴식, 3: 종료, 4: 연기)
        switch match.matchCode {
        case 0: return Color.blackAssets
        case 1: return Color.blackAssets
        case 3: return Color.whiteAssets
        case 4: return Color.gray300Assets
        default: return Color.blackAssets
        }
    }
}
