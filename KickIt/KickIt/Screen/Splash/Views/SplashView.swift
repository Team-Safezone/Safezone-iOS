//
//  ContentView.swift
//  KickIt
//
//  Created by 이윤지 on 5/10/24.
//

import SwiftUI

/// 스플래시 화면
struct SplashView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    SplashView()
}
