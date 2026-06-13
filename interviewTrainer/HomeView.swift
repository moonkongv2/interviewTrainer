//
//  HomeView.swift
//  interviewTrainer
//
//  Created by Moonsik Kong on 6/13/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var progressStore: ProgressStore
    @StateObject private var viewModel = PracticeViewModel()
    @State private var isPracticeActive = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Oral Random Trainer")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.vertical, 8)

                    LabeledContent("Total Questions", value: "\(viewModel.allQuestions.count)")
                    LabeledContent("Weak Questions", value: "\(progressStore.weakQuestionIds.count)")
                }

                Section("Practice Settings") {
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                }

                Section {
                    Button("Start Random Practice") {
                        startPractice(weakOnlyMode: false)
                    }

                    Button("Practice Weak Questions") {
                        startPractice(weakOnlyMode: true)
                    }
                    .disabled(progressStore.weakQuestionIds.isEmpty)

                    if progressStore.weakQuestionIds.isEmpty {
                        Text("Mark questions as weak during practice to review them later.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationDestination(isPresented: $isPracticeActive) {
                PracticeView(viewModel: viewModel)
                    .environmentObject(progressStore)
            }
        }
    }

    private func startPractice(weakOnlyMode: Bool) {
        viewModel.weakOnlyMode = weakOnlyMode
        viewModel.nextRandomQuestion(progressStore: progressStore)
        isPracticeActive = true
    }
}

#Preview {
    HomeView()
        .environmentObject(ProgressStore())
}
