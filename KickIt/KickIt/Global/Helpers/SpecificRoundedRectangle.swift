//
//  SpecificRoundedRectangle.swift
//  KickIt
//
//  Created by 이윤지 on 6/9/24.
//

import SwiftUI

/// 특정 모서리를 둥글게 만들어주는 박스
struct SpecificRoundedRectangle: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
        
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            
        return Path(path.cgPath)
    }
}

#Preview {
    SpecificRoundedRectangle()
}
