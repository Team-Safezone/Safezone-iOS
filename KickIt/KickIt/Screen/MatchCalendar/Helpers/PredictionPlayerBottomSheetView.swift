//
//  PredictionPlayerBottomSheetView.swift
//  KickIt
//
//  Created by 이윤지 on 9/18/24.
//

import SwiftUI

/// 선발라인업 예측 화면의 선수 선택 바텀시트
struct PredictionPlayerBottomSheetView: View {
    /// 선발라인업 예측 뷰모델 객체
    @ObservedObject var viewModel: StartingLineupPredictionViewModel
    
    /// 홈팀 여부
    var isHomeTeam: Bool
    
    /// 선택한 선수 리스트
    @Binding var selectedPlayers: [SoccerPosition : StartingLineupPlayer]
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            // 인디케이터
            DragIndicator()
                .foregroundStyle(.white0)
            
            Text("Selecting for \(isHomeTeam ? "Home" : "Away") Team")
            Text("선수 선택")
                .pretendardTextStyle(.Title1Style)
                .foregroundStyle(.white0)
                .padding(.top, 28)
                .padding(.bottom, 24)
            
            // 포지션 선택 리스트
            RadioButtonGroup(
                items: ["골키퍼", "수비수", "미드필더", "공격수"],
                padding: 12,
                selectedId: $viewModel.selectedRadioBtnID,
                selectedTeamName: $viewModel.selectedPositionName,
                callback: { previous, current, positionName in
                    viewModel.selectedRadioBtnID = current
                    viewModel.selectedPositionName = positionName
                    viewModel.selectPosition() // 선택한 포지션 정보 반영
            })
            .frame(height: 32, alignment: .center)
            .padding(.horizontal, 18)
            
            // 날짜 열 리스트
            let columns = Array(repeating: GridItem(.flexible()), count: 3)
            
            // 선수 리스트
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(Array(viewModel.filteredPlayers().enumerated()), id: \.offset) { _, player in
                        PredictionPlayerView(player: player)
                            .onTapGesture {
                                if let position = viewModel.selectedPosition {
                                    selectedPlayers[position] = player
                                    viewModel.isPlayerPresented = false
                                    print("1 팀 선수 리스트 수?: \(selectedPlayers.count)")
                                    print("1 팀 선수 리스트?: \(selectedPlayers)")
                                }
                            }
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 24)
            .padding(.horizontal, 28)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
    }
}

#Preview {
    PredictionPlayerBottomSheetView(viewModel: StartingLineupPredictionViewModel(), isHomeTeam: true, selectedPlayers: .constant([SoccerPosition.DF1:StartingLineupPlayer(playerImgURL: "", playerName: "", backNum: 2, playerPosition: 2)]))
}
