//
//  DragIndicator.swift
//  KickIt
//
//  Created by 이윤지 on 6/11/24.
//

import SwiftUI

/// 모든 화면에서 사용되는 시트 인디케이터
struct DragIndicator: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.black0)
            .frame(width: 80, height: 4)
            .padding(.top, 10)
    }
}

#Preview {
    DragIndicator()
}
