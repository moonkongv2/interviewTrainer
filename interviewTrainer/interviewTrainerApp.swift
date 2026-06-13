//
//  interviewTrainerApp.swift
//  interviewTrainer
//
//  Created by Moonsik Kong on 6/13/26.
//

import SwiftUI

@main
struct interviewTrainerApp: App {
    @StateObject private var progressStore = ProgressStore()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(progressStore)
        }
    }
}
