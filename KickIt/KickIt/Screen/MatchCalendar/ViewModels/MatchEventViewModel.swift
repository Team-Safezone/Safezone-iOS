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
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            formatter.timeZone = TimeZone.current
            return formatter
        }()
    
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
                switch completion {
                case .finished:
                    print("Successfully fetched match events")
                case .failure(let error):
                    print("Error fetching match events: \(error)")
                }
            } receiveValue: { [weak self] events in
                self?.matchEvents = events
                print("Received \(events.count) events")
                self?.updateMatchCode()
                self?.setMatchStartTime()
                self?.loadHeartRateData()
            }
            .store(in: &cancellables)
    }

    // 사용자 평균 심박수 GET
    func fetchUserAverageHeartRate() {
        MatchEventAPI.shared.getUserAverageHeartRate()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched user average heart rate")
                case .failure(let error):
                    print("Error fetching user average heart rate: \(error)")
                }
            } receiveValue: { [weak self] avgHeartRate in
                self?.userAverageHeartRate = avgHeartRate
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
                if !response.exists {   // 존재함 -> true, 미존재 -> false
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
            guard let startTime = matchStartTime else {
                print("Match start time is not set")
                return
            }
            
            let endTime = Date()
            let adjustedStartTime = startTime.addingTimeInterval(5 * 60) // 경기 시작 시각 + 5분
            let adjustedEndTime = endTime.addingTimeInterval(5 * 60) // 경기 종료 시각 + 5분
            
            var heartRateRecords: [matchHeartRateRecord] = []
            
            // 5분마다의 심박수 기록 추가
            var currentTime = adjustedStartTime
            var elapsedMinutes = 5
            while currentTime <= adjustedEndTime {
                if let heartRate = getClosestHeartRate(for: currentTime) {
                    heartRateRecords.append(matchHeartRateRecord(heartRate: heartRate, date: elapsedMinutes))
                }
                currentTime = currentTime.addingTimeInterval(5 * 60) // 5분 간격
                elapsedMinutes += 5
            }
            
            // 경기 이벤트에 대한 심박수 기록 추가
            for event in matchEvents {
                guard let eventDate = dateFormatter.date(from: event.eventTime)?.addingTimeInterval(5 * 60) else { continue }
                let eventElapsedMinutes = Int(eventDate.timeIntervalSince(startTime) / 60)
                if let heartRate = getClosestHeartRate(for: eventDate) {
                    let record = matchHeartRateRecord(heartRate: heartRate, date: eventElapsedMinutes)
                    if !heartRateRecords.contains(where: { $0.date == record.date }) {
                        heartRateRecords.append(record)
                    }
                }
            }
            
            // 중복 제거 및 정렬
            heartRateRecords = Array(Set(heartRateRecords)).sorted { $0.date < $1.date }
            
            let request = MatchHeartRateRequest(matchId: match.id, matchHeartRateRecords: heartRateRecords)
            
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
        
        // 가장 가까운 심박수 기록
        private func getClosestHeartRate(for date: Date) -> Int? {
            let dateString = dateFormatter.string(from: date)
            return heartRateModel.getHeartRate(for: dateString)
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
                print("Failed to authorize HealthKit")
            }
        }
    }
    
    // 심박수 데이터 로딩
    func loadHeartRateData() {
        guard let startTime = matchStartTime else {
            print("Match start time is not set")
            return
        }
        let endTime = Date()
        
        heartRateModel.loadHeartRate(startDate: startTime, endDate: endTime) { [weak self] records in
            DispatchQueue.main.async {
                self?.heartRateRecords = records
                self?.objectWillChange.send()
                print("Loaded \(records.count) heart rate records")
            }
        }
    }
    
    // 특정 이벤트 시간에 대한 심박수 가져오기
    func getHeartRate(for eventTime: String) -> Int? {
        let heartRate = heartRateModel.getHeartRate(for: eventTime)
        print("Heart rate for event at \(eventTime): \(heartRate ?? -1)")
        return heartRate
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
    
    //MARK: - UI 관련 함수
    // 경기 코드 반영
    private func updateMatchCode() {
        if let lastEventCode = matchEvents.last?.eventCode {
            match.matchCode = lastEventCode == 6 ? 3 : (lastEventCode == 2 ? 2 : 1)
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
        } else {
            // eventCode = 0인 이벤트가 없는 경우, 가장 이른 이벤트 시간을 사용
            matchStartTime = matchEvents.compactMap { dateFormatter.date(from: $0.eventTime) }.min()
        }

        if matchStartTime == nil {
            print("Warning: Failed to set match start time")
        }
    }
    
    // 경기 코드에 따른 색상
    func getStatusColor() -> Color {
        switch match.matchCode {
        case 0: return Color.whiteText
        case 1, 2: return Color.lime
        case 3: return Color.gray800Assets
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


// MARK: - dummydata
extension MatchEventViewModel {
    static func withDummyData() -> MatchEventViewModel {
        let dummyMatch = dummySoccerMatches[0]
        let viewModel = MatchEventViewModel(match: dummyMatch)
        let manurl = "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F17_300300.png"
        let pulurl = "https://img1.daumcdn.net/thumb/R150x150/?fname=http%3A%2F%2Ft1.daumcdn.net%2Fmedia%2Fimg-section%2Fsports13%2Flogo%2Fteam%2F14%2F43_300300.png"
        viewModel.matchEvents = [
            MatchEventsData(matchId: 53, eventCode: 0, eventTime: "2024/09/21 19:22:00", eventName: "경기 시작", player1: nil, player2: nil, teamName: nil, teamUrl: nil),
            MatchEventsData(matchId: 53, eventCode: 1, eventTime: "2024/09/21 19:27:00", eventName: "골!", player1: "미트로비치", player2: "윌리안", teamName: "풀럼", teamUrl: pulurl),
                MatchEventsData(matchId: 53, eventCode: 1, eventTime: "2024/09/21 19:30:00", eventName: "교체", player1: "포든", player2: "그릴리쉬", teamName: "맨시티", teamUrl: manurl),
                MatchEventsData(matchId: 53, eventCode: 1, eventTime: "2024/09/21 19:36:00", eventName: "경고", player1: "홀란드", player2: nil, teamName: "맨시티", teamUrl: manurl),
                MatchEventsData(matchId: 53, eventCode: 2, eventTime: "2024/09/21 19:36:00", eventName: "하프타임", player1: "3", player2: "2", teamName: nil, teamUrl: nil),
                MatchEventsData(matchId: 53, eventCode: 3, eventTime: "2024/09/21 19:38:00", eventName: "자책골", player1: "아케", player2: nil, teamName: "맨시티", teamUrl: manurl),
                MatchEventsData(matchId: 53, eventCode: 3, eventTime: "2024/09/21 19:47:00", eventName: "VAR 판독", player1: "홀란드", player2: nil, teamName: nil, teamUrl: nil),
                MatchEventsData(matchId: 53, eventCode: 4, eventTime: "2024/09/21 19:57:00", eventName: "추가 선언", player1: "5", player2: nil, teamName: nil, teamUrl: nil),
                MatchEventsData(matchId: 53, eventCode: 5, eventTime: "2024/09/21 20:00:00", eventName: "골!", player1: "데브라위너", player2: "알바레즈", teamName: "맨시티", teamUrl: manurl)
        ]
        
        viewModel.matchStartTime = DateFormatter().date(from: "2024/09/21 19:22")
        viewModel.userAverageHeartRate = 75
        viewModel.currentMatchId = 53
        
        // Dummy heart rate data
        viewModel.heartRateRecords = [
            HeartRateDate(heartRate: 80, date: "2024/09/21 19:32"),
            HeartRateDate(heartRate: 85, date: "2024/09/21 19:37"),
            HeartRateDate(heartRate: 90, date: "2024/09/21 19:46"),
            HeartRateDate(heartRate: 75, date: "2024/09/21 19:48"),
            HeartRateDate(heartRate: 95, date: "2024/09/21 19:57"),
            HeartRateDate(heartRate: 88, date: "2024/09/21 20:07"),
            HeartRateDate(heartRate: 92, date: "2024/09/21 20:10")
        ]
        
        return viewModel
    }
}
