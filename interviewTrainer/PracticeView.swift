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
        Group {
            if let question = viewModel.currentQuestion {
                questionContent(question)
            } else {
                ContentUnavailableView(
                    "No Questions",
                    systemImage: "questionmark.circle",
                    description: Text(emptyStateMessage)
                )
            }
        }
        .navigationTitle("Practice")
        .safeAreaInset(edge: .bottom) {
            if viewModel.currentQuestion != nil {
                actionButtons
            }
        }
        .onAppear {
            if viewModel.currentQuestion == nil {
                viewModel.nextRandomQuestion(progressStore: progressStore)
            }
        }
    }

    private var emptyStateMessage: String {
        if viewModel.filteredQuestions(progressStore: progressStore).isEmpty {
            return "No questions match this condition."
        }

        return "Tap Next Question to continue."
    }

    private var actionButtons: some View {
        VStack(spacing: 10) {
            Button("I Know This") {
                viewModel.markKnown(progressStore: progressStore)
            }
            .buttonStyle(.borderedProminent)

            Button("Review Again") {
                viewModel.markWeak(progressStore: progressStore)
            }
            .buttonStyle(.bordered)

            Button("Next Question") {
                viewModel.nextRandomQuestion(progressStore: progressStore)
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity)
        .controlSize(.large)
        .padding()
        .background(.bar)
    }

    private func questionContent(_ question: Question) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(question.category)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    Spacer()

                    if progressStore.isWeak(question) {
                        Text("Review Again")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.yellow.opacity(0.2))
                            .foregroundStyle(.orange)
                            .clipShape(Capsule())
                    }
                }

                Text(question.question)
                    .font(.title3)
                    .fontWeight(.semibold)

                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Answer")
                        .font(.headline)

                    if viewModel.isAnswerVisible {
                        Text(question.answer)
                            .font(.body)
                            .foregroundStyle(.primary)
                    } else {
                        Text("Answer is hidden.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    Button(viewModel.isAnswerVisible ? "Hide Answer" : "Show Answer") {
                        if viewModel.isAnswerVisible {
                            viewModel.isAnswerVisible = false
                        } else {
                            viewModel.showAnswer()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.bottom, 180)
        }
    }
}

#Preview {
    PracticeView(viewModel: PracticeViewModel())
        .environmentObject(ProgressStore())
}
