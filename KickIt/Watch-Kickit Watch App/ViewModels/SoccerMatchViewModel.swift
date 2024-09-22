//
//  SoccerMatchViewModel.swift
//  Kickit-Watch Watch App
//
//  Created by DaeunLee on 9/21/24.
//

import SwiftUI
import Combine

/// watchOS 앱의 축구 경기 뷰모델
class SoccerMatchViewModel: NSObject, ObservableObject { //WCSessionDelegate
    @Published var matches: [SoccerMatchWatch] = [] // 현재 표시 중인 축구 경기 목록
    @Published var isLoading = false // 데이터 로딩 중 여부
    @Published var errorMessage: String? // 데이터 로딩 중 여부
    
    //    private var session: WCSession?  //Watch Connectivity 세션
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - get API
    
    func loadMatches() {
        isLoading = true
        errorMessage = nil
        
        SoccerMatchService.shared.fetchMatches(for: Date())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] matches in
                self?.matches = matches
            }
            .store(in: &cancellables)
    }
}

//    // MARK: - Initialization
//
//    override init() {
//        super.init()
//        setupWatchConnectivity()
//    }
//
//    // MARK: - Watch Connectivity Setup
//
//    private func setupWatchConnectivity() {
//        if WCSession.isSupported() {
//            session = WCSession.default
//            session?.delegate = self
//            session?.activate()
//        }
//    }
//
//    // MARK: - Data Loading
//
//    /// 경기 데이터 로드 요청
//    func loadMatches() {
//        isLoading = true
//        errorMessage = nil
//        requestDataFromiOS()
//    }
//
//    /// iOS 기기에 데이터 요청
//    private func requestDataFromiOS() {
//        // WCSession이 활성화되었는지 확인
//        guard let session = session, session.activationState == .activated else {
//            isLoading = false
//            errorMessage = "WCSession is not activated"
//            return
//        }
//
//        // iOS 기기가 연결 가능한 상태인지 확인
//        guard session.isReachable else {
//            isLoading = false
//            errorMessage = "iPhone에 연결할 수 없습니다."
//            return
//        }
//
//        // iOS 기기에 데이터 요청 메시지 전송
//        session.sendMessage(["request": "dailyMatches"], replyHandler: { _ in
//            print("Request sent successfully to iPhone")
//        }) { error in
//            DispatchQueue.main.async {
//                self.isLoading = false
//                self.errorMessage = "데이터 요청 중 오류 발생: \(error.localizedDescription)"
//            }
//        }
//    }
//
//    // MARK: - WCSessionDelegate Methods
//
//    /// WCSession 활성화가 완료되었을 때 호출되는 메서드
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        if let error = error {
//            print("watchOS WCSession activation failed with error: \(error.localizedDescription)")
//        } else {
//            print("watchOS WCSession activated with state: \(activationState.rawValue)")
//        }
//    }
//
//    /// iOS 기기로부터 메시지 데이터를 수신했을 때 호출되는 메서드
//    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
//        do {
//            let decodedMatches = try JSONDecoder().decode([WatchSoccerMatch].self, from: messageData)
//            DispatchQueue.main.async {
//                self.matches = decodedMatches
//                self.isLoading = false
//                self.errorMessage = nil
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.isLoading = false
//                self.errorMessage = "데이터 디코딩 중 오류 발생: \(error.localizedDescription)"
//            }
//        }
//    }
//}
