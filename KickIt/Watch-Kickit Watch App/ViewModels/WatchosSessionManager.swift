//
//  WatchSessionManager.swift
//  Watch-Kickit Watch App
//
//  Created by DaeunLee on 11/10/24.
//

import WatchConnectivity

class WatchosSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchosSessionManager()
    
    @Published var wcSessionState: WCSessionActivationState = .notActivated
    @Published var errorMessage: String?
    
    var onXAuthTokenReceived: ((String) -> Void)?
    
    private override init() {
        super.init()
        setupWCSession()
    }
    
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
                self.errorMessage = "[watch] WCSession activation error: \(error.localizedDescription)"
            } else {
                switch activationState {
                case .activated:
                    self.errorMessage = nil
                case .inactive:
                    self.errorMessage = "[watch] WCSession is inactive"
                case .notActivated:
                    self.errorMessage = "[watch] WCSession is not activated"
                @unknown default:
                    self.errorMessage = "[watch] Unknown WCSession state"
                }
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let token = message["xAuthToken"] as? String {
                    DispatchQueue.main.async {
                        SoccerMatchViewModel.shared.saveXAuthToken(token)
                    }
                }
            }
    
    // matchId 전송
    func sendMatchIdToiOS(matchId: Int64) {
        let message = ["matchId": matchId]
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("[watch] Error sending matchId to iOS: \(error.localizedDescription)")
        }
    }
}
