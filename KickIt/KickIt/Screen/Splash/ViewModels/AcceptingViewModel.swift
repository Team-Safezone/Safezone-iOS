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
        // 개별 동의 상태 변경을 감지하여 전체 동의 상태만 업데이트
        Publishers.CombineLatest3($agreeToTerms, $agreeToPrivacy, $agreeToMarketing)
            .map { $0 && $1 && $2 }
            .sink { [weak self] allAgreed in
                self?.updateCheckedAll(allAgreed)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    /// 전체 동의 상태 업데이트 (개별 항목에 의한 변경)
    private func updateCheckedAll(_ newValue: Bool) {
        if checkedAll != newValue {
            checkedAll = newValue
        }
    }
    
    /// 전체 동의 토글 함수 (직접 제어)
    func toggleAll() {
        checkedAll.toggle()
        let newState = checkedAll
        agreeToTerms = newState
        agreeToPrivacy = newState
        agreeToMarketing = newState
    }
    
    /// 필수 동의 항목 확인
    var canProceed: Bool {
        agreeToTerms && agreeToPrivacy
    }
    
    /// 마케팅 동의 여부 API 호출
    func setMarketingConsent(to mainViewModel: MainViewModel, completion: @escaping (Bool) -> Void) {
            mainViewModel.userSignUpInfo.agreeToMarketing = agreeToMarketing
            mainViewModel.signUp(completion: completion)
    }
}
