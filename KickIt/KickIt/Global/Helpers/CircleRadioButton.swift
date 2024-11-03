//
//  CircleRadioButton.swift
//  KickIt
//
//  Created by 이윤지 on 11/3/24.
//

import SwiftUI

/// 동그라미 라디오 버튼
struct CircleRadioButton: View {
    let id: Int
    let label: String
    let callback: (Int, String) -> Void
    let selectedId: Int
    
    var body: some View {
        Button {
            self.callback(id, label)
        } label: {
            HStack(spacing: 8) {
                ZStack(alignment: .center) {
                    Circle()
                        .stroke(self.id == self.selectedId ? .lime : .gray800, lineWidth: 1)
                        .frame(width: 18, height: 18)
                    
                    if self.id == self.selectedId {
                        Circle()
                            .frame(width: 9, height: 9)
                            .foregroundStyle(.lime)
                    }
                }
                .padding(3)
                
                Text(label)
                    .pretendardTextStyle(.Body2Style)
                    .foregroundStyle(.white0)
            }
            .padding(.vertical, 10)
        }
    }
}
