//
//  SoccerMatchViewModel.swift
//  Kickit-Watch Watch App
//
//  Created by DaeunLee on 9/21/24.
//

import SwiftUI
import Combine
import HealthKit
import WatchConnectivity

/// watchOS 앱의 축구 경기 뷰모델
class SoccerMatchViewModel: NSObject, ObservableObject {
    @Published var matches: [SoccerMatchWatch] = [] // 현재 표시 중인 축구 경기 목록
    @Published var isLoading = false // 데이터 로딩 중 여부
    
    @Published var currentHeartRate: Double = 0 // 현재 심박수
    private var healthStore: HKHealthStore? // 심박수 저장
    private var heartRateQuery: HKQuery? // 심박수 가져오기
    
    private var session: WCSession? // WCSession 인스턴스
    @Published var wcSessionState: WCSessionActivationState = .notActivated // WCSession 활성화 상태
    private var pendingMessage: [String: Any]? // 전송 실패한 메시지 보관
    @Published var errorMessage: String? // 에러 메시지
    @Published var xAuthToken: String?  // ios에서 받은 값
    
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = SoccerMatchViewModel()
    
    override init() {
        super.init()
        setupWatchSessionManager() // WCSession 초기화 및 활성화
        setupHealthKit() // Health 초기화 및 활성화
        fetchTodayMatches() // 오늘의 경기 일정
    }
    
    // MARK: - get API
    /// 하루 경기 일정 조회
    func fetchTodayMatches() {
        isLoading = true
        errorMessage = nil
        
        let today = Date()
        let request = SoccerMatchDailyRequest(date: today)
        
        DailySoccerMatchAPI.shared.getDailySoccerMatches(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (completion: Subscribers.Completion<NetworkError>) in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] (response: [SoccerMatchDailyResponse]) in
                self?.matches = response.map { data in
                    SoccerMatchWatch(
                        id: data.id,
                        matchDate: stringToDate(date: data.matchDate),
                        matchTime: stringToTime(time: data.matchTime),
                        stadium: data.stadium,
                        matchRound: data.matchRound,
                        homeTeam: SoccerTeam(teamEmblemURL: data.homeTeamEmblemURL, teamName: data.homeTeamName),
                        awayTeam: SoccerTeam(teamEmblemURL: data.awayTeamEmblemURL, teamName: data.awayTeamName),
                        matchCode: data.matchCode,
                        homeTeamScore: data.homeTeamScore,
                        awayTeamScore: data.awayTeamScore
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - HealthKit 관련 함수
    private func setupHealthKit() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            
            let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
            
            // 권한 받기
            healthStore?.requestAuthorization(toShare: nil, read: [heartRateType]) { success, error in
                if success {
                    self.startHeartRateQuery(quantityTypeIdentifier: .heartRate)
                }
            }
        }
    }
    
    // 현재 심박수 가져오기
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            
            guard let samples = samples as? [HKQuantitySample] else {
                return
            }
            
            DispatchQueue.main.async {
                self.currentHeartRate = samples.last?.quantity.doubleValue(for: HKUnit(from: "count/min")) ?? 0
            }
        }
        
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        healthStore?.execute(query)
        self.heartRateQuery = query
    }
    
    func stopHeartRateQuery() {
        if let query = self.heartRateQuery {
            healthStore?.stop(query)
        }
    }
    
    // MARK: - iOS 전송 관련 함수들
    private func setupWatchSessionManager() {
        WatchSessionManager.shared.onXAuthTokenReceived = { [weak self] token in
            self?.xAuthToken = token
            self?.saveXAuthToken(token)
        }
    }
    
    func saveXAuthToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "xAuthToken")
        self.xAuthToken = token
    }
    
    func loadXAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: "xAuthToken")
    }
    
    func sendMatchIdToiOS(matchId: Int64) {
        WatchSessionManager.shared.sendMatchIdToiOS(matchId: matchId)
    }
}
