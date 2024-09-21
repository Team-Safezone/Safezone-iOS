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
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            // 인디케이터
            DragIndicator()
                .foregroundStyle(.white0)
            
            Text("선수 선택")
                .pretendardTextStyle(.Title1Style)
                .foregroundStyle(.white0)
                .padding(.top, 28)
                .padding(.bottom, 24)
            
            // 포지션 선택 리스트
            ScrollView(.horizontal, showsIndicators: false) {
                RadioButtonGroup(
                    items: ["전체", "골키퍼", "수비수", "미드필더", "공격수"],
                    selectedId: $viewModel.selectedRadioBtnID,
                    selectedTeamName: $viewModel.selectedPositionName,
                    callback: { previous, current, positionName in
                        viewModel.selectedRadioBtnID = current
                        viewModel.selectedPositionName = positionName
                })
                .frame(height: 32)
                .padding(.horizontal, 16)
            }
            
            // 날짜 열 리스트
            let columns = Array(repeating: GridItem(.flexible()), count: 3)
            
            // 선수 리스트
            LazyVGrid(columns: columns) {
                ForEach(Array(viewModel.filteredPlayers().enumerated()), id: \.offset) { _, player in
                    PredictionPlayerView(player: player)
                        .onTapGesture {
                            if let position = viewModel.selectedPosition {
                                viewModel.selectPlayer(player: player, position: position)
                                viewModel.isPlayerPresented = false
                            }
                        }
                }
            }
            .frame(height: .infinity)
            .padding(.top, 42)
            .padding(.horizontal, 26)
            
            Spacer()
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
    }
}

#Preview {
    PredictionPlayerBottomSheetView(viewModel: StartingLineupPredictionViewModel())
}
