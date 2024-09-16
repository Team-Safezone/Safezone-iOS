//
//  AcceptingViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 9/13/24.
//

import Combine
import Foundation

class AcceptingViewModel: ObservableObject {
    @Published var checkedAll: Bool = false
    @Published var agreeToTerms: Bool = false
    @Published var agreeToPrivacy: Bool = false
    @Published var agreeToMarketing: Bool = false
    @Published var showModal: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
            // 개별 동의 항목의 변화를 감지하고 전체 동의 상태 업데이트
            Publishers.CombineLatest3($agreeToTerms, $agreeToPrivacy, $agreeToMarketing)
                .map { $0 && $1 && $2 }
                .assign(to: \.checkedAll, on: self)
                .store(in: &cancellables)
        }
    
    // 전체 동의 처리
    func toggleAll() {
        // 전체 동의 상태를 토글하고 개별 항목에 반영
        let newState = !checkedAll // 전체 동의의 새로운 상태
        checkedAll = newState
        agreeToTerms = newState
        agreeToPrivacy = newState
        agreeToMarketing = newState
    }
    
    // 개별 항목 동의 처리
    func toggleTerms() {
        agreeToTerms.toggle()
    }
    
    func togglePrivacy() {
        agreeToPrivacy.toggle()
    }
    
    func toggleMarketing() {
        agreeToMarketing.toggle()
    }
    
    // 필수 항목 동의 여부 확인
    var canProceed: Bool {
        agreeToTerms && agreeToPrivacy
    }
    
    /// 마케팅 동의 여부 API
    func setMarketingConsent(completion: @escaping () -> Void) {
        UserAPI.shared.setMarketingConsent(consent: agreeToMarketing)
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    print("Marketing consent set successfully")
                case .failure(let error):
                    print("Failed to set marketing consent: \(error)")
                }
                completion()
            } receiveValue: { success in
                if success {
                    User.currentUser.agreeToMarketing = self.agreeToMarketing
                }
            }
            .store(in: &cancellables)
    }
}
