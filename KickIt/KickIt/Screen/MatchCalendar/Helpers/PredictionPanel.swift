//
//  PredictionPanel.swift
//  KickIt
//
//  Created by 이윤지 on 5/18/24.
//

import SwiftUI

/// SoccerMatchInfo 화면에서 볼 수 있는 예측하기 패널 화면
struct PredictionPanel: View {
    /// 화면 높이 위치 값
    @Binding var offsetY: CGFloat
    
    /// 화면 높이 고정 위치 값
    @State private var screenHeight: CGFloat = 0
    
    /// 드래그 위치 값
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // MARK: 스와이프 텍스트
                VStack(spacing: 0) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.gray600)
                    
                    Text("예측하기")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.gray600)
                    
                    // MARK: 패널 안의 뷰
                    VStack(alignment: .center, spacing: 0) {
                        Text("경기 시작 전\n결과를 예측해볼까요?")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.gray600)
                            .multilineTextAlignment(.center)
                        
                        // MARK: - 참여 인원 수
                        Text("2,399명 참여")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.gray400)
                            .padding(.top, 20)
                        
                        // MARK: - 예측하기 그래픽
                        Rectangle()
                            .fill(.gray100)
                            .frame(width: 300, height: 200)
                            .padding(.top, 30)
                        
                        Spacer()
                        
                        Text("참여만 해도 +3 GOAL")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.gray600)
                            .padding([.top, .bottom], 12)
                            .padding([.leading, .trailing], 24)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(.gray100)
                            )
                        
                        // MARK: - 참여하기 버튼
                        DesignWideButton(label: "참여하기", labelColor: .white, btnBGColor: .gray600)
                    }
                    .padding(.top, 45)
                    .padding(.bottom, 47)
                }
                .padding(.top, 17)
            }
            .onAppear {
                self.offsetY = geometry.size.height * 0.78
                self.screenHeight = geometry.size.height
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.white)
        )
        .offset(y: offsetY + dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    // 패널을 열지 않았거나, 아래로 패널을 닫는 중일 때만 dragOffset 업데이트
                    if (self.offsetY != 0 || value.translation.height > 0) {
                        self.dragOffset = value.translation.height
                    }
                }
                .onEnded { value in
                    // 패널을 열고 있는 상태라면
                    if (self.offsetY == 0) {
                        // 패널이 화면 높이의 10%보다 아래로 내려갔다면
                        if (self.offsetY + value.translation.height > screenHeight * 0.1) {
                            // 패널 닫기
                            self.offsetY = screenHeight * 0.78
                        }
                    }
                    // 패널을 닫고 있는 상태라면
                    else {
                        // 패널이 화면 높이의 10%보다 위로 올라갔다면
                        if (self.offsetY + value.translation.height > screenHeight * 0.1) {
                            // 패널 열기
                            self.offsetY = 0
                        }
                    }
                    // 드래그 종료
                    self.dragOffset = 0
                }
        )
    }
}

#Preview {
    PredictionPanel(offsetY: .constant(0))
}
