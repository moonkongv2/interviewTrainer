//
//  PracticeView.swift
//  interviewTrainer
//
//  Created by Moonsik Kong on 6/13/26.
//

import SwiftUI

struct PracticeView: View {
    @ObservedObject var viewModel: PracticeViewModel
    @EnvironmentObject private var progressStore: ProgressStore

    var body: some View {
        Form {
            if let question = viewModel.currentQuestion {
                Section(question.category) {
                    Text(question.question)
                        .font(.headline)

                    if viewModel.isAnswerVisible {
                        Text(question.answer)
                            .foregroundStyle(.secondary)
                    } else {
                        Button("Show Answer") {
                            viewModel.showAnswer()
                        }
                    }
                }

                Section {
                    Button("Known") {
                        viewModel.markKnown(progressStore: progressStore)
                    }

                    Button("Mark Weak") {
                        viewModel.markWeak(progressStore: progressStore)
                    }
                }
            } else {
                ContentUnavailableView(
                    "No Questions",
                    systemImage: "questionmark.circle",
                    description: Text("Try another category or add weak questions first.")
                )
            }
        }
        .navigationTitle("Practice")
    }
}

#Preview {
    PracticeView(viewModel: PracticeViewModel())
        .environmentObject(ProgressStore())
}
