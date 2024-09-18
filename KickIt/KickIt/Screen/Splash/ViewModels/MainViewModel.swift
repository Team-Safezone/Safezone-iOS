//
//  MainViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 9/18/24.
//

import Foundation

// 온보딩 전체 뷰
enum AppView {
    case login
    case settingName
    case settingFav
    case accepting
}

// 현재 표시할 뷰 결정
class MainViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var settingNameViewModel = SettingNameViewModel()
    @Published var settingFavViewModel = SettingFavViewModel()
    @Published var acceptingViewModel = AcceptingViewModel()
    
    func nextStep() {
        currentStep += 1
    }
}
