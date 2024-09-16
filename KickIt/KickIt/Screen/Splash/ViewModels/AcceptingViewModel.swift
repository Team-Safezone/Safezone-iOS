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
        updateCheckedAll() // 개별 항목 상태에 따른 전체 동의 상태 업데이트
    }
    
    func togglePrivacy() {
        agreeToPrivacy.toggle()
        updateCheckedAll() // 개별 항목 상태에 따른 전체 동의 상태 업데이트
    }
    
    func toggleMarketing() {
        agreeToMarketing.toggle()
        updateCheckedAll() // 개별 항목 상태에 따른 전체 동의 상태 업데이트
    }
    
    // 개별 항목에 따라 전체 동의 상태 업데이트
    private func updateCheckedAll() {
        checkedAll = agreeToTerms && agreeToPrivacy && agreeToMarketing
    }
    
    // 필수 항목 동의 여부 확인
    var canProceed: Bool {
        agreeToTerms && agreeToPrivacy
    }
    
    // API
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
