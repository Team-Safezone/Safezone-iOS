//
//  EditMyTeamsViewModel.swift
//  KickIt
//
//  Created by DaeunLee on 10/10/24.
//

import Combine
import SwiftUI

// 팀 변경 뷰모델
class EditMyTeamsViewModel: ObservableObject {
    @Published var selectedTeams: [String] = []
    @Published var teams: [SoccerTeam] = dummyscteams //[]
    @Published var errorMessage: String?
    private var settingFavViewModel : SettingFavViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(settingFavViewModel: SettingFavViewModel = SettingFavViewModel()) {
        self.settingFavViewModel = settingFavViewModel
        fetchTeams()
    }
    
    /// 팀 선택 함수
    func selectTeam(_ team: SoccerTeam) {
        if let index = selectedTeams.firstIndex(of: team.teamName) {
            selectedTeams.remove(at: index)
        } else if selectedTeams.count < 3 {
            selectedTeams.append(team.teamName)
        }
    }
    
    /// 선호 팀 설정 POST API 호출
    func setFavoriteTeams() {
        let request = FavoriteTeamsUpdateRequest(favoriteTeams: selectedTeams)
        MyPageAPI.shared.updateFavoriteTeams(request: request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error updating favorite teams: \(error)")
                    self.errorMessage = "선호 팀 변경에 실패했습니다"
                }
            } receiveValue: { _ in
                print("\(self.selectedTeams) 수정 성공")
                // 성공 처리 로직 추가
            }
            .store(in: &cancellables)
    }
    
    /// 프리미어 리그 팀 GET  API 호출
    func fetchTeams(){
        settingFavViewModel.fetchTeams()
    }
}

