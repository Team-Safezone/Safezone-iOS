//
//  StartingLineupView.swift
//  KickIt
//
//  Created by 이윤지 on 9/16/24.
//

import SwiftUI

/// 선발라인업 예측 선택 뷰
struct StartingLineupPredictionView: View {
    // MARK: - PROPERTY
    /// 선발라인업 예측 뷰모델 객체
    @ObservedObject var viewModel: StartingLineupPredictionViewModel
    
    /// 홈팀 여부
    var isHomeTeam: Bool
    
    /// 축구 팀 객체
    var team: SoccerTeam
    
    /// 포메이션 선택 시트를 띄우기 위한 변수
    @State private var isFormationPresented = false
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            // MARK: 팀 정보 및 포메이션 선택
            HStack(spacing: 8) {
                // 팀 이미지
                LoadableImage(image: team.teamEmblemURL)
                    .frame(width: 32, height: 32)
                    .background(.white)
                    .clipShape(Circle())
                
                // 팀 이름
                Text(team.teamName)
                    .pretendardTextStyle(.Title2Style)
                    .foregroundStyle(.white0)
                
                Spacer()
                
                // 포메이션 선택 버튼
                Button {
                    isFormationPresented.toggle() // 시트 띄우기
                } label: {
                    HStack {
                        Text(viewModel.presentFormationInfo(isHomeTeam: isHomeTeam))
                            .pretendardTextStyle(.SubTitleStyle)
                            .foregroundStyle(.white0)
                            .padding(.trailing, 4)
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.white0)
                    }
                }
            } //: HSTACK
            
            // MARK: 포메이션 선택 뷰
            ZStack {
                // 축구필드 이미지
                Image(.soccerField)
                    .resizable()
                    .frame(height: 330)
                    .rotationEffect(isHomeTeam ? Angle(degrees: 0) : Angle(degrees: 180))
                    .clipShape(
                        SpecificRoundedRectangle(radius: 8, corners: isHomeTeam ? [.topLeft, .topRight] : [.bottomLeft, .bottomRight])
                    )
                    .overlay {
                        SpecificRoundedRectangle(radius: 8, corners: isHomeTeam ? [.topLeft, .topRight] : [.bottomLeft, .bottomRight])
                            .fill(isHomeTeam ? (viewModel.homeSelectedFormation == nil ? .black : .clear) : (viewModel.awaySelectedFormation == nil ? .black : .clear))
                            .opacity(0.6)
                    }
                
                // MARK: 선택된 포메이션 리스트 띄우기
                // 선택한 포메이션이 있는 경우
                if let formation = isHomeTeam ? viewModel.homeSelectedFormation : viewModel.awaySelectedFormation {
                    selectedFormationView(formation: formation)
                }
                // 선택한 포메이션이 없는 경우
                else {
                    Text("포메이션을 선택한 후 선수를 배치해 주세요")
                        .pretendardTextStyle(.Body2Style)
                        .foregroundStyle(.whiteInAssets)
                }
            } //: ZSTACK
            
        } //: VSTACK
        // MARK: 포메이션 선택 바텀 시트
        .sheet(isPresented: $isFormationPresented) {
            presentFormationSheet
        }
        // MARK: 선수 선택 바텀 시트
        .sheet(isPresented: $viewModel.isPlayerPresented) {
            PredictionPlayerBottomSheetView(viewModel: viewModel, isHomeTeam: isHomeTeam)
        } //: SHEET
    }
    
    // MARK: - FUNCTION
    /// 포메이션 선택 바텀 시트
    @ViewBuilder
    private var presentFormationSheet: some View {
        VStack(spacing: 0) {
            // 인디케이터
            DragIndicator()
                .foregroundStyle(.white0)
            
            Text("포메이션 선택")
                .pretendardTextStyle(.Title1Style)
                .foregroundStyle(.white0)
                .padding(.top, 28)
                .padding(.bottom, 24)
            
            // 포메이션 리스트
            List {
                ForEach(0..<formations.count, id: \.self) { index in
                    let item = formations[index]
                    FormationRowView(
                        formation: item.name,
                        formationType: item.type,
                        formationIcons: item.images
                    )
                    .listRowInsets(EdgeInsets()) // List 내부의 기본 공백 제거
                    // 포메이션 1개를 클릭했을 경우
                    .onTapGesture {
                        viewModel.selectFormation(formation: item, index: index, isHomeTeam: isHomeTeam)
                        isFormationPresented.toggle() // 시트 띄우기
                    }
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
    }
    
    /// 포메이션에 따른 선수 카드 또는 선수 선택 카드 리스트 띄우기
    @ViewBuilder
    private func selectedFormationView(formation: Formation) -> some View {
        VStack(spacing: 0) {
            // 포지션 배열이 3줄이라면
            if (isHomeTeam ? viewModel.homeFormationIndex != 1 : viewModel.awayFormationIndex != 1) {
                VStack(alignment: .center, spacing: 22) {
                    ForEach(Array(playerViews(for: formation).enumerated()), id: \.offset) { _, view in
                        view
                    }
                }
            }
            // 포지션 배열이 4줄이라면
            else {
                VStack(alignment: .center, spacing: 4) {
                    ForEach(Array(playerViews(for: formation, extraMidfielders: true).enumerated()), id: \.offset) { _, view in
                        view
                    }
                }
            }
        }
    }
    
    /// 선수 선택 뷰들을 반환하는 함수
    private func playerViews(for formation: Formation, extraMidfielders: Bool = false) -> [AnyView] {
        // 뷰들이 추가될 리스트
        var views: [AnyView] = []
        
        // 골기퍼
        views.append(AnyView(playerView(for: 1, position: .GK)))
        
        // 수비수 리스트
        let filteredDefend = formation.positions.filter { $0.rawValue.contains("DF") }
        let defenders = HStack(spacing: 12) {
            ForEach(Array(0..<(formation.positionsToInt[0])), id: \.self) { i in
                playerView(for: 2, position: filteredDefend[i])
                    .onAppear {
                        print("수비수 \(filteredDefend[i])")
                    }
            }
        }
        views.append(AnyView(defenders))
        
        // 미드필더 리스트
        let filteredMidfield = formation.positions.filter { $0.rawValue.contains("MF") }
        let midfielders = HStack(spacing: 12) {
            ForEach(Array(0..<(formation.positionsToInt[1])), id: \.self) { i in
                playerView(for: 3, position: filteredMidfield[i])
                    .onAppear {
                        print("미드필더 \(filteredMidfield[i])")
                    }
            }
        }
        views.append(AnyView(midfielders))
        
        // 추가 미드필더 리스트
        if extraMidfielders {
            let midfielders2 = HStack(spacing: 12) {
                ForEach(Array(0..<(formation.positionsToInt[2])), id: \.self) { i in
                    playerView(for: 3, position: filteredMidfield[i + 2])
                        .onAppear {
                            print("미드필더 \(filteredMidfield[i + 2])")
                        }
                }
            }
            views.append(AnyView(midfielders2))
        }
        
        // 공격수 리스트
        let filteredStrike = formation.positions.filter { $0.rawValue.contains("FW") }
        let strikers = HStack(spacing: 12) {
            ForEach(Array(0..<(formation.positionsToInt[extraMidfielders ? 3 : 2])), id: \.self) { i in
                playerView(for: 4, position: filteredStrike[i])
                    .onAppear {
                        print("공격수 \(filteredStrike[i])")
                    }
            }
        }
        views.append(AnyView(strikers))
        
        return isHomeTeam ? views : views.reversed()
    }
    
    /// 특정 포지션에 맞는 뷰를 반환하는 함수
    @ViewBuilder
    private func playerView(for positionToInt: Int, position: SoccerPosition) -> some View {
        VStack(spacing: 0) {
            if let player = isHomeTeam ? viewModel.homeSelectedPlayers[position] : viewModel.awaySelectedPlayers[position] {
                // 값이 있으면 PredictionPlayerSelectedCardView 사용
                PredictionPlayerSelectedCardView(player: player)
                    .onTapGesture {
                        // 바텀 시트 호출
                        viewModel.presentPlayerBottomSheet(positionToInt: positionToInt, position: position)
                    }
            } else {
                // 값이 없으면 PredictionPlayerCardView 사용
                PredictionPlayerCardView(playerPosition: positionToInt)
                    .onTapGesture {
                        // 바텀 시트 호출
                        viewModel.presentPlayerBottomSheet(positionToInt: positionToInt, position: position)
                    }
            }
        }
    }
}

// MARK: - PREVIEW
#Preview("선발라인업 예측 선택") {
    StartingLineupPredictionView(viewModel: StartingLineupPredictionViewModel(), isHomeTeam: true, team: dummySoccerTeams[1])
}
