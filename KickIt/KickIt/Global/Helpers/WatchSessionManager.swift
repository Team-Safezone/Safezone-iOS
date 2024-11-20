//
//  WatchSessionManager.swift
//  KickIt
//
//  Created by DaeunLee on 11/10/24.
//

import WatchConnectivity
import Combine

// [ios] - watchos
class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    
    @Published var wcSessionState: WCSessionActivationState = .notActivated
    @Published var errorMessage: String?
    
    var onMatchIdReceived: ((Int64) -> Void)?
    
    private override init() {
        super.init()
        setupWCSession()
    }
    
    // watch sesstion 활성화
    private func setupWCSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.wcSessionState = activationState
            if let error = error {
                self.errorMessage = "[iOS] WCSession activation error: \(error.localizedDescription)"
            } else {
                switch activationState {
                case .activated:
                    self.errorMessage = nil
                    let token = KeyChain.shared.getJwtToken()
                    self.sendXAuthTokenToWatch(token ?? "token x")
                case .inactive:
                    self.errorMessage = "[iOS] WCSession is inactive"
                case .notActivated:
                    self.errorMessage = "[iOS] WCSession is not activated"
                @unknown default:
                    self.errorMessage = "[iOS] Unknown WCSession state"
                }
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        DispatchQueue.main.async {
            self.errorMessage = "[iOS] WCSession became inactive"
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        DispatchQueue.main.async {
            self.errorMessage = "[iOS] WCSession deactivated"
        }
        // 세션 재활성화
        WCSession.default.activate()
    }
    
    // 송신한 matchid 설정
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let matchId = message["matchId"] as? Int64 {
                self.onMatchIdReceived?(matchId)
            }
        }
    }
    
    // ios -> watchos 송신
    func sendXAuthTokenToWatch(_ token: String) {
        guard WCSession.default.isReachable else {
            print("[iOS] Watch is not reachable (JWT)")
            return
        }
        
        let message = ["xAuthToken": token]
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("[iOS] Error sending xAuthToken to watch: \(error.localizedDescription)")
        }
    }
    
    // ios <- watchos 수신
    func sendMatchIdToWatch(_ matchId: Int64) {
        guard WCSession.default.isReachable else {
            print("[iOS] Watch is not reachable (matchID)")
            return
        }
        
        let message = ["matchId": matchId]
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("[iOS] Error sending matchId to watch: \(error.localizedDescription)")
        }
    }
}
