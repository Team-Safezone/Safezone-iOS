//
//  SoccerMatchInfo.swift
//  KickIt
//
//  Created by 이윤지 on 5/18/24.
//

import SwiftUI

/// 축구 경기 정보 화면
struct SoccerMatchInfo: View {
    // MARK: - PROPERTY
    /// 축구 경기 객체
    var soccerMatch: SoccerMatch
    
    /// 경기 캘린더 뷰모델
    @ObservedObject var viewModel: MatchCalendarViewModel
    
    /// 경기 정보 텍스트 버튼 클릭 상태 여부
    @State private var isShowMatchInfo = true
    
    /// 현재 툴팁에 보여지는 텍스트 인덱스
    @State private var currentToolTipIdx = 0
    
    /// 이전에 툴팁에 보여졌던 텍스트 인덱스
    @State private var prevToolTipIdx = 0
    
    /// 툴팁 텍스트 변경 시 애니메이션 여부
    @State private var isFadeAnim = false
    
    /// 오늘 날짜
    @State private var nowDate = Date()
    
    // MARK: - BODY
    var body: some View {
        ZStack(alignment: .top) {
            // 배경화면 색상 지정
            Color(.background)
            
            VStack(spacing: 0) {
                // MARK: 상단 경기 정보
                TopMatchInfo()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // MARK: 팀 및 스코어 정보
                        MatchInfo()
                        
                        ZStack {
                            // 하단 시트 색상 지정
                            SpecificRoundedRectangle(radius: 16, corners: [.topLeft, .topRight])
                                .foregroundStyle(.gray950Assets)
                            
                            VStack(spacing: 32) {
                                // MARK: 경기정보 & 경기예측 버튼
                                VStack(spacing: 4) {
                                    Circle()
                                        .frame(width: 6, height: 6)
                                        .foregroundStyle(.lime)
                                        .offset(x: isShowMatchInfo ? -41 : 41) // 이동할 거리 설정
                                        .animation(.easeInOut(duration: 0.3), value: isShowMatchInfo)
                                    
                                    HStack(alignment: .center, spacing: 16) {
                                        Button {
                                            withAnimation {
                                                isShowMatchInfo = true
                                            }
                                        } label: {
                                            Text("경기 정보")
                                                .pretendardTextStyle(isShowMatchInfo ? .Title1Style : TextStyle(font: .pretendard(.medium, size: 18), tracking: -0.4, uiFont: UIFont(name: "Pretendard-Medium", size: 18)!, lineHeight: 24))
                                                .foregroundStyle(isShowMatchInfo ? .white0 : .gray500)
                                                .animation(.easeInOut(duration: 0.3), value: isShowMatchInfo) // 애니메이션 추가
                                        }
                                        
                                        Button {
                                            withAnimation {
                                                isShowMatchInfo = false
                                            }
                                        } label: {
                                            Text("경기 예측")
                                                .pretendardTextStyle(isShowMatchInfo ? TextStyle(font: .pretendard(.medium, size: 18), tracking: -0.4, uiFont: UIFont(name: "Pretendard-Medium", size: 18)!, lineHeight: 24) : .Title1Style)
                                                .foregroundStyle(isShowMatchInfo ? .gray500 : .white0)
                                                .animation(.easeInOut(duration: 0.3), value: !isShowMatchInfo) // 애니메이션 추가
                                        }
                                    }
                                }
                                .padding(.top, 16)
                                
                                // MARK: 경기정보 레이아웃
                                if isShowMatchInfo {
                                    HStack(spacing: 13) {
                                        // MARK: 경기 타임라인 버튼
                                        NavigationLink {
                                            TimelineEventView(match: soccerMatch)
                                        } label: {
                                            VStack(alignment: .leading) {
                                                HStack(alignment: .center, spacing: 0) {
                                                    Text("경기 타임라인")
                                                        .pretendardTextStyle(.Title2Style)
                                                        .foregroundStyle(.blackAssets)
                                                    
                                                    Image(uiImage: .caretRight)
                                                        .resizable()
                                                        .frame(width: 16, height: 16)
                                                        .foregroundStyle(.blackAssets)
                                                }
                                                
                                                Text(soccerMatchLabel().1)
                                                    .pretendardTextStyle(.Body3Style)
                                                    .foregroundStyle(.blackAssets)
                                                
                                                Image(uiImage: .soccerObjects)
                                            }
                                            .padding(12)
                                            .background(
                                                Image(uiImage: .timelineCard)
                                                    .resizable()
                                            )
                                        }
                                        
                                        VStack(spacing: 16) {
                                            // MARK: 선발 라인업 버튼
                                            NavigationLink {
                                                // TODO: 선발라인업 화면 연결
                                            } label: {
                                                ZStack {
                                                    VStack(alignment: .leading, spacing: 0) {
                                                        HStack(alignment: .center, spacing: 0) {
                                                            Text("선발 라인업")
                                                                .pretendardTextStyle(.Title2Style)
                                                                .foregroundStyle(.blackAssets)
                                                            
                                                            Image(uiImage: .caretRight)
                                                                .resizable()
                                                                .frame(width: 16, height: 16)
                                                                .foregroundStyle(.blackAssets)
                                                            
                                                            Spacer()
                                                        }
                                                        
                                                        HStack {
                                                            Spacer()
                                                            Image(uiImage: .soccer)
                                                                .padding(.top, 8)
                                                        }
                                                    }
                                                    .padding(12)
                                                    .background(
                                                        Image(uiImage: .matchInfoCard)
                                                            .resizable()
                                                    )
                                                    .overlay {
                                                        if soccerMatch.matchCode == 0 {
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(.black)
                                                                .opacity(0.55)
                                                        }
                                                    }
                                                    
                                                    // 선발라인업 공개 타이머
                                                    if soccerMatch.matchCode == 0 {
                                                        Text(timeInterval(nowDate: nowDate, matchDate: soccerMatch.matchDate, matchTime: soccerMatch.matchTime))
                                                            .pretendardTextStyle(.SubTitleStyle)
                                                            .foregroundStyle(.whiteAssets)
                                                            .onAppear {
                                                                startTimer()
                                                            }
                                                    }
                                                }
                                            }
                                            
                                            // MARK: 심박수 통계 버튼
                                            NavigationLink {
                                                HeartRateView(selectedMatch: soccerMatch)
                                            } label: {
                                                ZStack {
                                                    VStack(alignment: .leading, spacing: 0) {
                                                        HStack(alignment: .center, spacing: 0) {
                                                            Text("심박수 통계")
                                                                .pretendardTextStyle(.Title2Style)
                                                                .foregroundStyle(.blackAssets)
                                                            
                                                            Image(uiImage: .caretRight)
                                                                .resizable()
                                                                .frame(width: 16, height: 16)
                                                                .foregroundStyle(.blackAssets)
                                                            
                                                            Spacer()
                                                        }
                                                        
                                                        HStack {
                                                            Spacer()
                                                            Image(uiImage: .chart)
                                                                .padding(.top, 8)
                                                        }
                                                    }
                                                    .padding(12)
                                                    .background(
                                                        Image(uiImage: .matchInfoCard)
                                                            .resizable()
                                                    )
                                                    .overlay {
                                                        if soccerMatch.matchCode != 3 {
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(.black)
                                                                .opacity(0.55)
                                                        }
                                                    }
                                                    
                                                    if soccerMatch.matchCode != 3 {
                                                        Text("경기 종료 후 공개")
                                                            .pretendardTextStyle(.SubTitleStyle)
                                                            .foregroundStyle(.whiteAssets)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(16)
                                }
                                // 경기 예측 버튼을 눌렀다면
                                else {
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
                                                    .fill(LinearGradient.greenGradient)
                                            )
                                        }
                                        
                                        // 선발 라인업 예측 화면으로 이동하는 버튼
                                        NavigationLink {
                                            StartingLineupPrediction(soccerMatch: soccerMatch)
                                                .toolbarRole(.editor) // back 텍스트 숨기기
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
                                                    .fill(LinearGradient.greenGradient)
                                            )
                                        }
                                    }
                                    .padding(16)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.top, 55)
                    } //: VSTACK
                } //: ScrollView
                .scrollIndicators(.never)
            }
        } //: ZSTACK
        // 툴 바, 상태 바 색상 변경
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("\(soccerMatch.homeTeam.teamName) VS \(soccerMatch.awayTeam.teamName)")
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    // MARK: - FUNCTION
    /// 상단 경기 정보
    @ViewBuilder
    private func TopMatchInfo() -> some View {
        HStack(spacing: 5) {
            // 장소
            HStack(spacing: 4) {
                Image(uiImage: .mapPin)
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.gray500)
                
                Text("\(soccerMatch.stadium)")
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.gray200)
            }
            
            // 구분선
            RoundedRectangle(cornerRadius: 8)
                .rotation(Angle(degrees: 90))
                .fill(.gray500Text)
                .frame(width: 14, height: 1)
            
            // 라운드
            Text("\(soccerMatch.matchRound)R")
                .pretendardTextStyle(.SubTitleStyle)
                .foregroundStyle(.gray200)
            
            Spacer()
            
            // 경기 상태
            Text(soccerMatchLabel().0)
                .pretendardTextStyle(.Body3Style)
                .foregroundStyle(soccerMatchLabelColor().0)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(soccerMatchLabelColor().1, lineWidth: 2)
                )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.background)
    }
    
    /// 팀 및 경기 정보
    @ViewBuilder
    private func MatchInfo() -> some View {
        // MARK: 팀 정보 및 경기 날짜 정보
        HStack(alignment: .center) {
            // MARK: 홈팀
            VStack(alignment: .center, spacing: 0) {
                // 홈팀 엠블럼 이미지
                LoadableImage(image: soccerMatch.homeTeam.teamEmblemURL)
                    .frame(width: 88, height: 88)
                    .clipShape(Circle())
                
                HStack(spacing: 0) {
                    Image(uiImage: .homeTeam)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.gray500Text)
                    
                    // 팀 명
                    Text("\(soccerMatch.homeTeam.teamName)")
                        .pretendardTextStyle(.Body1Style)
                        .foregroundStyle(.white0)
                }
                .padding(.top, 8)
                .frame(width: 88, alignment: .center)
            }
            
            Spacer()
            
            // MARK: 경기 날짜&시간
            VStack(spacing: 2) {
                Text("\(dateToString2(date: soccerMatch.matchDate))")
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.white0)
                
                Text("\(timeToString(time: soccerMatch.matchTime))")
                    .pretendardTextStyle(.H2Style)
                    .foregroundStyle(.white0)
            }
            
            Spacer()
            
            // MARK: 원정 팀
            VStack(alignment: .center, spacing: 0) {
                // 원정 팀 엠블럼 이미지
                LoadableImage(image: soccerMatch.awayTeam.teamEmblemURL)
                    .frame(width: 88, height: 88)
                    .clipShape(Circle())
                    
                    // 팀 명
                    Text("\(soccerMatch.awayTeam.teamName)")
                        .pretendardTextStyle(.Body1Style)
                        .foregroundStyle(.white0)
                        .padding(.top, 8)
                }
                .frame(width: 88, alignment: .center)
        }
        .padding(.horizontal, 36)
        .padding(.top, 69)
        
        // MARK: - 스코어
        HStack(spacing: 0) {
            // 홈 팀 스코어
            Text("\(soccerMatch.homeTeamScore?.description ?? "-")")
                .font(.pretendard(.semibold, size: 30))
                .frame(width: 40)
            
            Spacer()
            
            // 원정 팀 스코어
            Text("\(soccerMatch.awayTeamScore?.description ?? "-")")
                .font(.pretendard(.semibold, size: 30))
                .frame(width: 40)
        }
        .foregroundStyle(soccerMatch.homeTeamScore == nil ? .gray500 : .white0)
        .padding(.top, 30)
        .padding(.horizontal, 60)
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
        case 0: return (.white0, .gray500)
        case 1: return (.lime, .lime)
        case 3: return (.gray500Text, .gray800)
        case 4: return (.gray500Text, .gray800)
        default: return (.white0, .gray500)
        }
    }
    
    /// 경기 상태 텍스트&타임라인 텍스트 값을 반환하는 함수
    private func soccerMatchLabel() -> (String, String) {
        switch (soccerMatch.matchCode) {
        case 0: return ("경기 예정", "아직 시작 전이에요")
        case 1: return ("경기중", "실시간 업데이트 중")
        case 3: return ("경기 종료", "업데이트 완료")
        case 4: return ("경기 연기", "경기가 연기됐어요")
        default: return ("경기 예정", "아직 시작 전이에요")
        }
    }
}

// MARK: - PREVIEW
#Preview("경기 정보") {
    SoccerMatchInfo(soccerMatch: dummySoccerMatches[1], viewModel: MatchCalendarViewModel())
}
