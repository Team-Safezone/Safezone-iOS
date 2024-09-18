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
    /// 홈팀 여부
    var isHomeTeam: Bool
    
    /// 축구 팀 객체
    var team: SoccerTeam
    
    /// 팀의 선수 리스트
    var teamPlayers: [StartingLineupPlayer]
    
    /// 사용자가 예측했던 팀 선수 리스트
    var userPredictions: UserStartingLineupPrediction?
    
    /// 포메이션 리스트
    typealias Formation = (String, String, [UIImage], [Int])
    private let formations: [Formation] = [
        ("4-3-3 포메이션", "공격형", [(.soccerBall)], [4, 3, 3]),
        ("4-2-3-1 포메이션", "균형형", [(.soccerBall), (.shield)], [4, 2, 3, 1]),
        ("4-4-2 포메이션", "균형형", [(.soccerBall), (.shield)], [4, 4, 2]),
        ("3-4-3 포메이션", "공격형", [(.soccerBall)], [3, 4, 3]),
        ("4-5-1 포메이션", "수비형", [(.shield)], [4, 5, 1]),
        ("3-5-2 포메이션", "공격형", [(.soccerBall)], [3, 5, 2])
    ]
    
    /// 포메이션 선택 시트를 띄우기 위한 변수
    @State private var isFormationPresented = false
    
    /// 현재 선택 중인 팀 포메이션
    @State private var selectedFormation: [Int] = []
    
    /// 현재 선택 중인 팀 포메이션의 배열 순서
    @State private var formationIndex: Int = -1
    
    /// 선수 선택 시트를 띄우기 위한 변수
    @State private var isPlayerPresented = false
    
    /// 라디오그룹에서 선택한 포지션 아이디, 포지션 이름 정보
    @State private var selectedRadioBtnID: Int = 0
    @State private var selectedPositionName: String? = nil
    
    /// 사용자가 선택한 팀 선수 리스트
    @State private var selectedPlayers: [Int: StartingLineupPlayer] = [:]
    
    /// 현재 선택 중인 선수 포지션
    @State private var selectedPosition: Int?
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
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
                    isFormationPresented.toggle()
                } label: {
                    HStack {
                        Text(formationIndex == -1 ? "포메이션 선택" : formations[formationIndex].0)
                            .pretendardTextStyle(.SubTitleStyle)
                            .foregroundStyle(.white0)
                            .padding(.trailing, 4)
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.white0)
                    }
                }
            } //: HSTACK
            
            // 포메이션 선택 뷰
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
                            .fill(selectedFormation.isEmpty ? .black : .clear)
                            .opacity(0.6)
                    }
                
                selectedFormationView()
            } //: ZSTACK
            
        } //: VSTACK
        // 포메이션 선택 바텀 시트
        .sheet(isPresented: $isFormationPresented) {
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
                            formation: item.0,
                            formationType: item.1,
                            formationIcons: item.2
                        )
                        .listRowInsets(EdgeInsets()) // List 내부의 기본 공백 제거
                        // 포메이션 1개를 클릭했을 경우
                        .onTapGesture {
                            selectedFormation = item.3
                            formationIndex = index
                            isFormationPresented.toggle()
                        }
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.hidden)
        } //: SHEET
    }
    
    // MARK: - FUNCTION
    @ViewBuilder
    /// 홈팀, 원정팀 포메이션 리스트 띄우기
    private func selectedFormationView() -> some View {
        // 선택한 포메이션이 있는 경우
        if !selectedFormation.isEmpty {
            VStack(spacing: 0) {
                // 포지션 배열이 3줄이라면
                if (formationIndex != 1) {
                    VStack(alignment: .center, spacing: 22) {
                        // 홈팀이라면
                        if isHomeTeam {
                            ForEach(Array(playerViews().enumerated()), id: \.offset) { index, view in
                                view
                            }
                        }
                        // 원정팀이라면
                        else {
                            ForEach(Array(reversedPlayerViews(extraMidfielders: false).enumerated()), id: \.offset) { index, view in
                                view
                            }
                        }
                    }
                }
                // 포지션 배열이 4줄이라면
                else {
                    VStack(alignment: .center, spacing: 4) {
                        // 홈팀이라면
                        if isHomeTeam {
                            ForEach(Array(playerViews(extraMidfielders: true).enumerated()), id: \.offset) { index, view in
                                view
                            }
                        }
                        // 원정팀이라면
                        else {
                            ForEach(Array(reversedPlayerViews(extraMidfielders: true).enumerated()), id: \.offset) { index, view in
                                view
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $isPlayerPresented) {
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
                    let positions = [ "전체", "골키퍼", "수비수", "미드필더", "공격수" ]
                    ScrollView(.horizontal, showsIndicators: false) {
                        RadioButtonGroup(
                            items: positions,
                            selectedId: $selectedRadioBtnID,
                            selectedTeamName: $selectedPositionName,
                            callback: { previous, current, positionName in
                                selectedRadioBtnID = current
                                selectedPositionName = positionName
                        })
                        .frame(height: 32)
                        .padding(.horizontal, 16)
                    }
                    
                    // 날짜 열 리스트
                    let columns = Array(repeating: GridItem(.flexible()), count: 3)
                    
                    // 선수 필터링 리스트
                    let tempPlayers: [StartingLineupPlayer] = selectedPosition == 0 ? teamPlayers : teamPlayers.filter { $0.playerPosition == selectedPosition }
                    
                    // 선수 리스트
                    LazyVGrid(columns: columns) {
                        ForEach(Array(tempPlayers.enumerated()), id: \.offset) { index, player in
                            PredictionPlayerView(player: player)
                                .onTapGesture {
                                    //selectedPlayers[] = player
                                }
                        }
                    }
                    .frame(height: .infinity)
                    .padding(.top, 42)
                    .padding(.horizontal, 26)
                }
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
                
                Spacer()
            }
        }
        // 선택한 포메이션이 없는 경우
        else {
            Text("포메이션을 선택한 후 선수를 배치해 주세요")
                .pretendardTextStyle(.Body2Style)
                .foregroundStyle(.whiteInAssets)
        }
    }
    
    /// 선수 선택 뷰들을 반환하는 함수
    private func playerViews(extraMidfielders: Bool = false) -> [AnyView] {
        // 뷰들이 추가될 리스트
        var views: [AnyView] = []
        
        // 골기퍼
        views.append(AnyView(playerView(for: 1)))
        
        // 수비수 리스트
        let defenders = HStack(spacing: 12) {
            ForEach(Array(0..<selectedFormation[0]), id: \.self) { i in
                playerView(for: 2)
            }
        }
        views.append(AnyView(defenders))
        
        // 미드필더 리스트
        let midfielders = HStack(spacing: 12) {
            ForEach(Array(0..<selectedFormation[1]), id: \.self) { i in
                playerView(for: 3)
            }
        }
        views.append(AnyView(midfielders))
        
        // 추가 미드필더 리스트
        if extraMidfielders {
            let midfielders2 = HStack(spacing: 12) {
                ForEach(Array(0..<selectedFormation[2]), id: \.self) { i in
                    playerView(for: 3)
                }
            }
            views.append(AnyView(midfielders2))
        }
        
        // 공격수 리스트
        let strikers = HStack(spacing: 12) {
            ForEach(Array(0..<selectedFormation[extraMidfielders ? 3 : 2]), id: \.self) { i in
                playerView(for: 4)
            }
        }
        views.append(AnyView(strikers))
        
        return views
    }
    
    /// 뷰를 역순으로 반환하는 함수
    private func reversedPlayerViews(extraMidfielders: Bool) -> [AnyView] {
        return playerViews(extraMidfielders: extraMidfielders).reversed()
    }
    
    // 특정 포지션에 맞는 뷰를 반환하는 함수
    @ViewBuilder
    private func playerView(for position: Int) -> some View {
        VStack(spacing: 0) {
            if let player = selectedPlayers[position] {
                // 값이 있으면 PredictionPlayerSelectedCardView 사용
                PredictionPlayerSelectedCardView(player: player)
                    .onTapGesture {
                        // 바텀 시트 호출
                        selectedPosition = position
                        print("포지션1", selectedPosition?.description ?? 0)
                        isPlayerPresented.toggle()
                    }
            } else {
                // 값이 없으면 PredictionPlayerCardView 사용
                PredictionPlayerCardView(playerPosition: position)
                    .onTapGesture {
                        // 바텀 시트 호출
                        selectedPosition = position
                        print("포지션2", selectedPosition?.description ?? 0)
                        isPlayerPresented.toggle()
                    }
            }
        }
    }
}

// MARK: - PREVIEW
#Preview("선발라인업 예측 선택") {
    StartingLineupPredictionView(isHomeTeam: true, team: dummySoccerTeams[1], teamPlayers: dummyStartingLineupPlayer)
}
