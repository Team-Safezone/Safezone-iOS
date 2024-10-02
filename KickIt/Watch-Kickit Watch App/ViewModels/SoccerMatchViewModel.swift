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
class SoccerMatchViewModel: NSObject, ObservableObject, WCSessionDelegate {
    @Published var matches: [SoccerMatchWatch] = [] // 현재 표시 중인 축구 경기 목록
    @Published var isLoading = false // 데이터 로딩 중 여부
    @Published var errorMessage: String? // 에러 메시지
    @Published var wcSessionState: WCSessionActivationState = .notActivated // WCSession 활성화 상태
    private var pendingMessage: [String: Any]? // 전송 실패한 메시지 보관
    private var cancellables = Set<AnyCancellable>()
    private var session: WCSession? // WCSession 인스턴스
    
    @Published var currentHeartRate: Double = 0 // 현재 심박수
    private var healthStore: HKHealthStore? // 심박수 저장
    private var heartRateQuery: HKQuery? // 심박수 가져오기
    
    override init() {
        super.init()
        setupWCSession() // WCSession 초기화 및 활성화
        setupHealthKit() // Health 초기화 및 활성화
    }
    
    // MARK: - dummydata
    let dummySoccerMatches: [SoccerMatchWatch] = [
        SoccerMatchWatch(id: 0, timeStr: "20:30", homeTeam: "울버햄튼", homeTeamScore: 0, awayTeam: "맨시티", awayTeamScore: 0, status: 0),
        SoccerMatchWatch(id: 1, timeStr: "21:30", homeTeam: "아스널", homeTeamScore: 2, awayTeam: "풀럼", awayTeamScore: 4, status: 1),
        SoccerMatchWatch(id: 2, timeStr: "22:30", homeTeam: "토트넘", homeTeamScore: 2, awayTeam: "크리스탈 팰리스", awayTeamScore: 1, status: 3)]
    
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
    
    
    // MARK: - get API
    
    /// 하루 경기 일정 데이터 가져오기
    func loadMatches() {
        isLoading = true
        errorMessage = nil
        
        SoccerMatchService.shared.fetchMatches(for: Date()) //Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()) //
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] matches in
                self?.matches = matches
            }
            .store(in: &cancellables)
    }
    
    // MARK: - iOS 전송 관련 함수들
    
    /// WCSession 설정 및 활성화
    private func setupWCSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self // Delegate 설정
            session?.activate() // WCSession 활성화
        }
    }
    
    /// iOS로 match ID 전송
    func sendMatchIdToiOS(matchId: Int64) {
        let message = ["matchId": matchId]
        
        if let session = session, session.isReachable {
            session.sendMessage(message, replyHandler: { response in
                print("Message sent to iOS with matchId: \(matchId)")
            }, errorHandler: { error in
                print("Error sending message to iOS: \(error.localizedDescription)")
                self.storePendingMessage(message)
            })
        } else {
            print("WCSession is not reachable, saving message locally")
            storePendingMessage(message)
        }
    }
    
    /// 실패한 메시지 저장 (나중에 재시도)
    private func storePendingMessage(_ message: [String: Any]) {
        UserDefaults.standard.set(message, forKey: "pendingMessage")
    }
    
    /// 메시지 재전송 로직
    private func retryPendingMessage() {
        if let message = UserDefaults.standard.dictionary(forKey: "pendingMessage") {
            if let session = session, session.isReachable {
                session.sendMessage(message, replyHandler: { response in
                    print("Pending message sent to iOS successfully.")
                    UserDefaults.standard.removeObject(forKey: "pendingMessage")
                }, errorHandler: { error in
                    print("Error retrying message: \(error.localizedDescription)")
                })
            }
        }
    }
    
    /// WCSessionDelegate 메서드: 세션 활성화 완료 시 호출
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.wcSessionState = activationState
            if let error = error {
                self.errorMessage = "WCSession activation error: \(error.localizedDescription)"
            } else {
                switch activationState {
                case .activated:
                    self.errorMessage = nil
                    self.retryPendingMessage() // 활성화 시 메시지 재전송
                case .inactive:
                    self.errorMessage = "WCSession is inactive"
                case .notActivated:
                    self.errorMessage = "WCSession is not activated"
                @unknown default:
                    self.errorMessage = "Unknown WCSession state"
                }
            }
        }
    }
    
    /// iOS로부터 메시지 수신 시 호출 (옵션)
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        // 수신된 메시지 처리 로직 추가 가능
    }
}
