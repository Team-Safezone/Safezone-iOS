//
//  StartingLineup+.swift
//  KickIt
//
//  Created by 이윤지 on 11/15/24.
//

import SwiftUI

/// 선발라인업 관련 화면에서 사용되는 레이아웃 함수
extension View {
    /// 선발라인업 선수 엔티티 변환 함수(Entity -> Entity)
    func lineupPlayerToEntity(_ entity: SoccerPlayer) -> StartingLineupPlayer {
        return StartingLineupPlayer(
            playerImgURL: entity.playerImgURL ?? "",
            playerName: entity.playerName ?? "",
            backNum: entity.backNum ?? 0,
            playerPosition: 0
        )
    }
    
    func teamInfoView(for isHomeTeam: Bool, home homeTeam: SoccerTeam, away awayTeam: SoccerTeam) -> (String, String) {
        let team = isHomeTeam ? homeTeam : awayTeam
        return (team.teamEmblemURL, team.teamName)
    }
    
    /// 팀 엠블럼&이미지
    @ViewBuilder
    func teamInfo(_ isHomeTeam: Bool, _ homeTeam: SoccerTeam, _ awayTeam: SoccerTeam, _ homeFormation: String, _ awayFormation: String) -> some View {
        HStack(spacing: 8) {
            LoadableImage(image: teamInfoView(for: isHomeTeam, home: homeTeam, away: awayTeam).0)
                .frame(width: 32, height: 32)
            
            Text(teamInfoView(for: isHomeTeam, home: homeTeam, away: awayTeam).1)
                .pretendardTextStyle(.Title2Style)
                .foregroundStyle(.white0)
            
            Spacer()
            
            Text("\(isHomeTeam ? homeFormation : awayFormation) 포메이션")
                .pretendardTextStyle(.SubTitleStyle)
                .foregroundStyle(.white0)
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
    
    /// 선발라인업 선수 리스트
    @ViewBuilder
    func lineups(isHomeTeam: Bool, for formations: String, lineup: StartingLineupModel) -> some View {
        VStack(spacing: 0) {
            // 포메이션이 3줄이라면
            let tempFormation: [Int] = formations.split(separator: "-").compactMap { Int($0) }
            if tempFormation.count == 3 {
                VStack(alignment: .center, spacing: 22) {
                    ForEach(Array(playerViews(isHomeTeam: isHomeTeam, for: lineup).enumerated()), id: \.offset) { _, view in
                        view
                    }
                }
            }
            // 포메이션이 4줄이라면
            else {
                VStack(alignment: .center, spacing: 4) {
                    ForEach(Array(playerViews(isHomeTeam: isHomeTeam, for: lineup).enumerated()), id: \.offset) { _, view in
                        view
                    }
                }
            }
        }
    }
    
    /// 선수 리스트 반환 함수
    func playerViews(isHomeTeam: Bool, for lineup: StartingLineupModel) -> [AnyView] {
        // 뷰들이 추가될 리스트
        var views: [AnyView] = []
        
        // 골기퍼
        let goalkeeper = HStack(spacing: 12) {
            ForEach(0..<lineup.goalkeeper.count, id: \.self) { i in
                PredictionPlayerSelectedCardView(player: lineupPlayerToEntity(lineup.goalkeeper[i]))
            }
        }
        views.append(AnyView(goalkeeper))
        
        // 수비수 리스트
        let defenders = HStack(spacing: 12) {
            ForEach(0..<lineup.defenders.count, id: \.self) { i in
                PredictionPlayerSelectedCardView(player: lineupPlayerToEntity(lineup.defenders[i]))
            }
        }
        views.append(AnyView(defenders))
        
        // 미드필더 리스트
        let midfielders = HStack(spacing: 12) {
            ForEach(0..<lineup.midfielders.count, id: \.self) { i in
                PredictionPlayerSelectedCardView(player: lineupPlayerToEntity(lineup.midfielders[i]))
            }
        }
        views.append(AnyView(midfielders))
        
        // 추가 미드필더 리스트
        if let extraMidfielders = lineup.midfielders2 {
            if !extraMidfielders.isEmpty {
                let midfielders2 = HStack(spacing: 12) {
                    ForEach(0..<extraMidfielders.count, id: \.self) { i in
                        PredictionPlayerSelectedCardView(player: lineupPlayerToEntity(extraMidfielders[i]))
                    }
                }
                views.append(AnyView(midfielders2))
            }
        }
        
        // 공격수 리스트
        let strikers = HStack(spacing: 12) {
            ForEach(0..<lineup.strikers.count, id: \.self) { i in
                PredictionPlayerSelectedCardView(player: lineupPlayerToEntity(lineup.strikers[i]))
            }
        }
        views.append(AnyView(strikers))
        
        return isHomeTeam ? views : views.reversed()
    }
    
    /// 사용자 예측&평균 예측 선발라인업 선수 리스트
    @ViewBuilder
    func predictionLineups(isHomeTeam: Bool, for formationIndex: Int, lineup: UserStartingLineupPrediction) -> some View {
        VStack(spacing: 0) {
            // 포메이션이 3줄이라면
            if formationIndex != 1 {
                VStack(alignment: .center, spacing: 22) {
                    ForEach(Array(predictionPlayerViews(isHomeTeam: isHomeTeam, for: lineup, extra: false).enumerated()), id: \.offset) { _, view in
                        view
                    }
                }
            }
            // 포메이션이 4줄이라면
            else {
                VStack(alignment: .center, spacing: 4) {
                    ForEach(Array(predictionPlayerViews(isHomeTeam: isHomeTeam, for: lineup, extra: true).enumerated()), id: \.offset) { _, view in
                        view
                    }
                }
            }
        }
    }
    
    /// 사용자 예측&평균 예측 선수 리스트 반환 함수
    func predictionPlayerViews(isHomeTeam: Bool, for lineup: UserStartingLineupPrediction, extra: Bool) -> [AnyView] {
        // 뷰들이 추가될 리스트
        var views: [AnyView] = []
        
        // 골기퍼
        views.append(AnyView(PredictionPlayerSelectedCardView(player: lineupPlayerToEntity(lineup.goalkeeper))))
        
        // 수비수 리스트
        let defenders = HStack(spacing: 12) {
            ForEach(0..<lineup.defenders.count, id: \.self) { i in
                PredictionPlayerSelectedCardView(player: lineupPlayerToEntity(lineup.defenders[i]))
            }
        }
        views.append(AnyView(defenders))
        
        // 미드필더 리스트
        if !extra {
            let midfielders = HStack(spacing: 12) {
                ForEach(0..<lineup.midfielders.count, id: \.self) { i in
                    PredictionPlayerSelectedCardView(player: lineupPlayerToEntity(lineup.midfielders[i]))
                }
            }
            views.append(AnyView(midfielders))
        }
        // 추가 미드필더 리스트가 있다면
        else {
            let midfielders = HStack(spacing: 12) {
                ForEach(0..<2, id: \.self) { i in
                    PredictionPlayerSelectedCardView(player: lineupPlayerToEntity(lineup.midfielders[i]))
                }
            }
            views.append(AnyView(midfielders))
            
            let midfielders2 = HStack(spacing: 12) {
                ForEach(2..<lineup.midfielders.count, id: \.self) { i in
                    PredictionPlayerSelectedCardView(player: lineupPlayerToEntity(lineup.midfielders[i]))
                }
            }
            views.append(AnyView(midfielders2))
        }
        
        // 공격수 리스트
        let strikers = HStack(spacing: 12) {
            ForEach(0..<lineup.strikers.count, id: \.self) { i in
                PredictionPlayerSelectedCardView(player: lineupPlayerToEntity(lineup.strikers[i]))
            }
        }
        views.append(AnyView(strikers))
        
        return isHomeTeam ? views : views.reversed()
    }
    
    /// 축구장 이미지
    @ViewBuilder
    func soccerFiled(_ isHomeTeam: Bool) -> some View {
        Image(.soccerField)
            .resizable()
            .frame(height: 330)
            .rotationEffect(isHomeTeam ? Angle(degrees: 0) : Angle(degrees: 180))
            .clipShape(
                SpecificRoundedRectangle(radius: 8, corners: isHomeTeam ? [.topLeft, .topRight] : [.bottomLeft, .bottomRight])
            )
            .overlay {
                SpecificRoundedRectangle(radius: 8, corners: isHomeTeam ? [.topLeft, .topRight] : [.bottomLeft, .bottomRight])
                    .fill(.black)
                    .opacity(0.2)
            }
    }
    
    /// 예측 성공 여부 뷰
    @ViewBuilder
    func resultView(_ isPredicted: Bool?) -> some View {
        VStack(spacing: 4) {
            if let predict = isPredicted {
                if predict {
                    Image(uiImage: .circle)
                        .foregroundStyle(.lime)
                    Text("성공")
                        .pretendardTextStyle(.Title2Style)
                        .foregroundStyle(.limeText)
                }
                else {
                    Image(uiImage: .nope)
                        .foregroundStyle(.gray500)
                    Text("실패")
                        .pretendardTextStyle(.Title2Style)
                        .foregroundStyle(.gray500)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
