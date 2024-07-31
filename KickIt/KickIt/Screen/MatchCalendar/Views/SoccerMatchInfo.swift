//
//  SoccerMatchInfo.swift
//  KickIt
//
//  Created by 이윤지 on 5/18/24.
//

import SwiftUI

/// 1개의 축구 경기 정보 화면
// TODO: 추후 MVVM 구조로 변경 필요
struct SoccerMatchInfo: View {
    /// 축구 경기 객체
    var soccerMatch: SoccerMatch
    
    /// 경기 정보 텍스트 버튼 클릭 상태 여부
    @State private var isShowMatchInfo = true
    
    /// 경기 예측 텍스트 버튼 클릭 상태 여부
    @State private var isShowPredicted = false
    
    /// 툴팁에 들어갈 텍스트 리스트
    private let toolTips = ["참여하면 +1골", "2,395명 참여"]
    
    /// 현재 툴팁에 보여지는 텍스트 인덱스
    @State private var currentToolTipIdx = 0
    
    /// 이전에 툴팁에 보여졌던 텍스트 인덱스
    @State private var prevToolTipIdx = 0
    
    /// 툴팁 텍스트 변경 시 애니메이션 여부
    @State private var isFadeAnim = false
    
    /// 오늘 날짜
    @State private var nowDate = Date()
    
    var body: some View {
        ZStack(alignment: .top) {
            // 배경화면 색 지정
            Color(.background)
            
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    // MARK: - 상단 경기 정보
                    HStack(spacing: 8) {
                        // 장소
                        Text("\(soccerMatch.stadium)")
                            .pretendardTextStyle(.Body2Style)
                            .foregroundStyle(.gray200)
                        
                        // 구분선
                        RoundedRectangle(cornerRadius: 8)
                            .rotation(Angle(degrees: 90))
                            .fill(.gray500)
                            .frame(width: 14, height: 1)
                        
                        // 매치 라운드
                        Text("\(soccerMatch.matchRound)R")
                            .pretendardTextStyle(.Body1Style)
                            .foregroundStyle(.gray200)
                        
                        Spacer()
                        
                        // 경기 상태
                        Text(soccerMatchLabel().0)
                            .pretendardTextStyle(.SubTitleStyle)
                            .foregroundStyle(soccerMatchLabelColor().0)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(soccerMatchLabelColor().1)
                            )
                    }
                    .padding(.top, 12)
                    .padding(.horizontal, 16)
                    
                    // MARK: - 팀 정보 및 경기 날짜 정보
                    HStack(alignment: .center) {
                        // MARK: 홈 팀
                        VStack(alignment: .center, spacing: 0) {
                            // 홈 팀 엠블럼 이미지
                            LoadableImage(image: soccerMatch.homeTeam.teamEmblemURL)
                                .frame(width: 88, height: 88)
                                .background(.white)
                                .clipShape(Circle())
                            
                            HStack(spacing: 0) {
                                Image(systemName: "house.fill")
                                    .foregroundStyle(.gray500)
                                    .font(.system(size: 15))
                                
                                // 팀 명
                                Text("\(soccerMatch.homeTeam.teamName)")
                                    .pretendardTextStyle(.Body1Style)
                                    .foregroundStyle(.white)
                            }
                            .padding(.top, 8)
                            .frame(width: 88, alignment: .center)
                        }
                        
                        Spacer()
                        
                        // MARK: 경기 날짜&시간
                        VStack(spacing: 4) {
                            Text("\(dateToString2(date: soccerMatch.matchDate))")
                                .pretendardTextStyle(.Body1Style)
                                .foregroundStyle(.white)
                            
                            Text("\(timeToString(time: soccerMatch.matchTime))")
                                .pretendardTextStyle(.H1Style)
                                .foregroundStyle(.white)
                        }
                        
                        Spacer()
                        
                        // MARK: 원정 팀
                        VStack(alignment: .center, spacing: 0) {
                            // 원정 팀 엠블럼 이미지
                            LoadableImage(image: soccerMatch.awayTeam.teamEmblemURL)
                                .frame(width: 88, height: 88)
                                .background(.white)
                                .clipShape(Circle())
                                
                                // 팀 명
                                Text("\(soccerMatch.awayTeam.teamName)")
                                    .pretendardTextStyle(.Body1Style)
                                    .foregroundStyle(.white)
                                    .padding(.top, 8)
                            }
                            .frame(width: 88, alignment: .center)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 87)
                    
                    // MARK: - 스코어
                    HStack(spacing: 0) {
                        // 홈 팀 스코어
                        Text("\(soccerMatch.homeTeamScore?.description ?? "-")")
                            .pretendardTextStyle(TextStyle(font: .pretendard(.semibold, size: 30), tracking: 0, uiFont: UIFont(name: "Pretendard-SemiBold", size: 30)!, lineHeight: 0))
                            .foregroundStyle(soccerMatch.homeTeamScore != nil ? .white : .gray500)
                            .frame(width: 40)
                        
                        Spacer()
                        
                        // 원정 팀 스코어
                        Text("\(soccerMatch.awayTeamScore?.description ?? "-")")
                            .pretendardTextStyle(TextStyle(font: .pretendard(.semibold, size: 30), tracking: 0, uiFont: UIFont(name: "Pretendard-SemiBold", size: 30)!, lineHeight: 0))
                            .foregroundStyle(soccerMatch.homeTeamScore != nil ? .white : .gray500)
                            .frame(width: 40)
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 56)
                    
                    // MARK: - 하단 경기 정보 버튼 레이아웃
                    HStack(alignment: .center, spacing: 0) {
                        Button {
                            withAnimation {
                                isShowMatchInfo = true
                                isShowPredicted = false
                            }
                        } label: {
                            Text("경기 정보")
                                .pretendardTextStyle(isShowMatchInfo ? .H2Style : TextStyle(font: .pretendard(.medium, size: 20), tracking: 0, uiFont: UIFont(name: "Pretendard-Medium", size: 20)!, lineHeight: 26))
                                .foregroundStyle(isShowMatchInfo ? .white : .gray500)
                        }
                        .padding(.trailing, 12)
                        
                        Button {
                            withAnimation {
                                isShowMatchInfo = false
                                isShowPredicted = true
                            }
                        } label: {
                            Text("경기 예측")
                                .pretendardTextStyle(isShowPredicted ? .H2Style : TextStyle(font: .pretendard(.medium, size: 20), tracking: 0, uiFont: UIFont(name: "Pretendard-Medium", size: 20)!, lineHeight: 26))
                                .foregroundStyle(isShowPredicted ? .white : .gray500)
                        }
                        
                        // "경기 전"일 경우 띄우는 툴팁
                        // FIXME: 애니메이션 수정 필요..
                        if soccerMatch.matchCode == 0 {
                            HStack(spacing: -2) {
                                Image(uiImage: .polygonRotate)
                                
                                ZStack {
                                    Text("\(toolTips[prevToolTipIdx])")
                                        .pretendardTextStyle(.Body3Style)
                                        .foregroundStyle(.black)
                                        .opacity(currentToolTipIdx == prevToolTipIdx ? 1 : 0)
                                        .offset(y: currentToolTipIdx == prevToolTipIdx ? 0 : -50)
                                        .animation(.easeOut(duration: 0.5), value: prevToolTipIdx)
                                    
                                    Text("\(toolTips[currentToolTipIdx])")
                                        .pretendardTextStyle(.Body3Style)
                                        .foregroundStyle(.black)
                                        .opacity(currentToolTipIdx == prevToolTipIdx ? 0 : 1)
                                        .offset(y: currentToolTipIdx == prevToolTipIdx ? 50 : 0)
                                        .animation(.easeOut(duration: 0.5), value: currentToolTipIdx)
                                }
                                .padding(.vertical, 4)
                                .padding(.leading, 11)
                                .padding(.trailing, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 52)
                                        .fill(.lime)
                                )
                            }
                            .onAppear {
                                Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                                    prevToolTipIdx = currentToolTipIdx
                                    currentToolTipIdx = (currentToolTipIdx + 1) % toolTips.count
                                }
                            }
                            .padding(.leading, 10)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 80)
                    
                    // MARK: - 하단 경기 정보 레이아웃
                    // 경기 정보 버튼을 눌렀다면
                    if isShowMatchInfo {
                        HStack(spacing: 13) {
                            // 경기 타임라인 화면으로 이동하는 버튼
                            NavigationLink {
                                TimelineEventView(match: soccerMatch)
                            } label: {
                                VStack(alignment: .leading) {
                                    HStack(alignment: .center) {
                                        Text("경기 타임라인")
                                            .pretendardTextStyle(.Title2Style)
                                            .foregroundStyle(.white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.up.right")
                                            .font(.system(size: 32))
                                            .foregroundStyle(.white)
                                    }
                                    
                                    Text(soccerMatchLabel().1)
                                        .pretendardTextStyle(.Body3Style)
                                        .foregroundStyle(.gray200)
                                    
                                    Image(uiImage: .heart)
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(LinearGradient.pinkGradient)
                                )
                            }
                            
                            VStack(spacing: 16) {
                                // 선발 라인업 화면으로 이동하는 버튼
                                NavigationLink {
                                    
                                } label: {
                                    ZStack {
                                        VStack(alignment: .leading, spacing: 0) {
                                            HStack(alignment: .center) {
                                                Text("선발 라인업")
                                                    .pretendardTextStyle(.Title2Style)
                                                    .foregroundStyle(.white)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "arrow.up.right")
                                                    .font(.system(size: 32))
                                                    .foregroundStyle(.white)
                                            }
                                            
                                            Image(uiImage: .soccer)
                                                .padding(.top, 4)
                                        }
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(LinearGradient.blueGradient)
                                        )
                                        .overlay {
                                            if soccerMatch.matchCode == 0 {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(.black)
                                                    .opacity(soccerMatch.matchCode != 3 ? 0.6 : 0)
                                            }
                                        }
                                        
                                        // FIXME: 경기 날짜, 경기 시간에 따른 타이머로 변경하기
                                        if soccerMatch.matchCode == 0 {
                                            Text(timeInterval(nowDate: nowDate, matchDate: soccerMatch.matchDate, matchTime: soccerMatch.matchTime))
                                                .pretendardTextStyle(.SubTitleStyle)
                                                .foregroundStyle(.white)
                                                .onAppear {
                                                    startTimer()
                                                }
                                        }
                                    }
                                }
                                
                                // 심박수 통계 화면으로 이동하는 버튼
                                NavigationLink {
                                    HeartRateView(selectedMatch: soccerMatch)
                                } label: {
                                    ZStack {
                                        VStack(alignment: .leading, spacing: 0) {
                                            HStack(alignment: .center) {
                                                Text("심박수 통계")
                                                    .pretendardTextStyle(.Title2Style)
                                                    .foregroundStyle(.white)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "arrow.up.right")
                                                    .font(.system(size: 32))
                                                    .foregroundStyle(.white)
                                            }
                                            
                                            Image(uiImage: .chart)
                                                .padding(.top, 4)
                                        }
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(LinearGradient.blueGradient)
                                        )
                                        .overlay {
                                            if soccerMatch.matchCode != 3 {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(.black)
                                                    .opacity(soccerMatch.matchCode != 3 ? 0.6 : 0)
                                            }
                                        }
                                        
                                        if soccerMatch.matchCode != 3 {
                                            Text("경기 종료 후 공개")
                                                .pretendardTextStyle(.SubTitleStyle)
                                                .foregroundStyle(.white)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(16)
                    }
                    // 경기 예측 버튼을 눌렀다면
                    else if isShowPredicted {
                        HStack(spacing: 13) {
                            // 우승 팀 예측 화면으로 이동하는 버튼
                            NavigationLink {
                                // TODO: CASE에 따른 화면 이동 처리 필요
                                WinningTeamPrediction(soccerMatch: soccerMatch)
                                    .toolbarRole(.editor) // back 텍스트 숨기기
                            } label: {
                                VStack(alignment: .leading) {
                                    HStack(alignment: .center) {
                                        Text("우승 팀 예측")
                                            .pretendardTextStyle(.Title2Style)
                                            .foregroundStyle(.black)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.up.right")
                                            .font(.system(size: 32))
                                            .foregroundStyle(.black)
                                    }
                                    
                                    Text("승리할 팀은?")
                                        .pretendardTextStyle(.Body3Style)
                                        .foregroundStyle(.gray900)
                                    
                                    Image(uiImage: .trophys)
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(LinearGradient.limeGradient)
                                )
                            }
                            
                            // 선발 라인업 예측 화면으로 이동하는 버튼
                            NavigationLink {
                                
                            } label: {
                                VStack(alignment: .leading) {
                                    HStack(alignment: .center) {
                                        Text("선발 라인업 예측")
                                            .pretendardTextStyle(.Title2Style)
                                            .foregroundStyle(.black)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.up.right")
                                            .font(.system(size: 32))
                                            .foregroundStyle(.black)
                                    }
                                    
                                    Text("내가 감독이라면?")
                                        .pretendardTextStyle(.Body3Style)
                                        .foregroundStyle(.gray900)
                                    
                                    Image(uiImage: .soccerObjects)
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(LinearGradient.limeGradient)
                                )
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .scrollIndicators(.never)
        }
        // 툴 바, 상태 바 색상 변경
        .ignoresSafeArea(edges: .bottom)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    /// 선발 라인업이 나오기 전까지의 시간 계산
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.nowDate = Date()
        }
    }
    
    /// 경기 상태에 따른 경기 텍스트&배경 색상 값을 반환하는 함수
    private func soccerMatchLabelColor() -> (Color, Color) {
        switch (soccerMatch.matchCode) {
        case 0: return (Color.black, Color.white)
        case 1: return (Color.black, Color.lime)
        case 2: return (Color.black, Color.lime)
        case 3: return (Color.gray300, Color.gray800)
        case 4: return (Color.black, Color.white)
        default: return (Color.gray600, Color.white)
        }
    }
    
    /// 경기 상태 텍스트&타임라인 텍스트 값을 반환하는 함수
    private func soccerMatchLabel() -> (String, String) {
        switch (soccerMatch.matchCode) {
        case 0: return ("경기 예정", "아직 시작 전이에요")
        case 1: return ("경기중", "실시간 업데이트 중")
        case 2: return ("휴식", "실시간 업데이트 중")
        case 3: return ("경기 종료", "업데이트 완료")
        case 4: return ("연기", "경기가 연기됐어요")
        default: return ("경기 예정", "아직 시작 전이에요")
        }
    }
}

#Preview {
    SoccerMatchInfo(soccerMatch: dummySoccerMatches[2])
}
