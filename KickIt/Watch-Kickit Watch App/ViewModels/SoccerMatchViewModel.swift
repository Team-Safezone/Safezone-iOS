//
//  SoccerMatchViewModel.swift
//  Kickit-Watch Watch App
//
//  Created by DaeunLee on 9/21/24.
//

import SwiftUI
import WatchConnectivity

class SoccerMatchViewModel: NSObject, ObservableObject, WCSessionDelegate {
    @Published var matches: [SoccerMatch] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var session: WCSession?

    override init() {
        super.init()
        setupWatchConnectivity()
    }

    /// Watch Connectivity 설정
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    /// 경기 데이터 로드 요청
    func loadMatches() {
        isLoading = true
        errorMessage = nil
        requestDataFromiOS()
    }

    /// iOS 기기에 데이터 요청
    private func requestDataFromiOS() {
        guard let session = session, session.isReachable else {
            isLoading = false
            errorMessage = "iPhone에 연결할 수 없습니다."
            return
        }

        session.sendMessage(["request": "dailyMatches"], replyHandler: { [weak self] response in
            DispatchQueue.main.async {
                self?.handleReceivedMatches(response)
            }
        }) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.errorMessage = "데이터 요청 중 오류 발생: \(error.localizedDescription)"
            }
        }
    }

    /// 받은 경기 데이터 처리
    private func handleReceivedMatches(_ response: [String: Any]) {
        if let matchesData = response["matches"] as? [[String: Any]] {
            self.matches = matchesData.compactMap { data in
                guard let id = data["id"] as? Int64,
                      let matchTime = data["matchTime"] as? String,
                      let homeTeamName = data["homeTeamName"] as? String,
                      let awayTeamName = data["awayTeamName"] as? String else {
                    return nil
                }
                return SoccerMatch(id: id, matchTime: matchTime, homeTeamName: homeTeamName, awayTeamName: awayTeamName)
            }
            self.isLoading = false
            self.errorMessage = nil
        } else {
            self.errorMessage = "잘못된 데이터 형식"
            self.isLoading = false
        }
    }

    // MARK: - WCSessionDelegate methods

    /// WCSession 활성화 완료 시 호출
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("watchOS WCSession activation failed with error: \(error.localizedDescription)")
        } else {
            print("watchOS WCSession activated with state: \(activationState.rawValue)") // 0: .notActivated 1: .inactive 2: .activated
        }
    }

    /// 메시지 수신 시 호출
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async { [weak self] in
            self?.handleReceivedMatches(message)
        }
    }
}
