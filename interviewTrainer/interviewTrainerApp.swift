//
//  interviewTrainerApp.swift
//  interviewTrainer
//
//  Created by Moonsik Kong on 6/13/26.
//

import SwiftUI
import UIKit

@main
struct interviewTrainerApp: App {
    @StateObject private var progressStore = ProgressStore()

    var body: some Scene {
        WindowGroup {
            SplashRootView()
                .environmentObject(progressStore)
        }
    }
}

private struct SplashRootView: View {
    @State private var isShowingSplash = true

    var body: some View {
        ZStack {
            HomeView()
                .opacity(isShowingSplash ? 0 : 1)

            if isShowingSplash {
                SplashImageView()
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)

            withAnimation(.easeInOut(duration: 0.35)) {
                isShowingSplash = false
            }
        }
    }
}

private struct SplashImageView: View {
    private var splashImage: UIImage? {
        guard let url = Bundle.main.url(forResource: "splash_image", withExtension: "png") else {
            return nil
        }

        return UIImage(contentsOfFile: url.path)
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color(.systemBackground)

                if let splashImage {
                    Image(uiImage: splashImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                }
            }
            .ignoresSafeArea()
        }
    }
}
