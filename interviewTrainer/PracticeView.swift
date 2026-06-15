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
    @State private var isCategoryEasterEggAlertVisible = false
    @State private var categoryEasterEggAlertTitle = ""
    @State private var categoryEasterEggAlertMessage = ""

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
        .background(AppStyle.screenBackground)
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
        .alert(categoryEasterEggAlertTitle, isPresented: $isCategoryEasterEggAlertVisible) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(categoryEasterEggAlertMessage)
        }
    }

    private var emptyStateMessage: String {
        if viewModel.allQuestions.isEmpty {
            return "No questions are available yet. Please check that questions.json is included in the app."
        }

        if viewModel.weakOnlyMode && progressStore.weakQuestionIds.isEmpty {
            return "No weak questions yet. Mark questions for review during practice or from the question list."
        }

        if viewModel.filteredQuestions(progressStore: progressStore).isEmpty {
            if viewModel.weakOnlyMode {
                return "No weak questions match the selected category."
            }

            return "No questions match the selected category."
        }

        return "No questions match this condition."
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
            VStack(alignment: .leading, spacing: AppStyle.sectionSpacing) {
                VStack(alignment: .leading, spacing: AppStyle.cardSpacing) {
                    HStack {
                        Text(question.category)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .onTapGesture(count: 3) {
                                showCategoryEasterEgg()
                            }

                        Spacer()

                        if progressStore.isWeak(question) {
                            Text("Saved for Review")
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
                        .fixedSize(horizontal: false, vertical: true)
                }
                .appCard()

                VStack(alignment: .leading, spacing: AppStyle.cardSpacing) {
                    Text("Answer")
                        .font(.headline)

                    if viewModel.isAnswerVisible {
                        Text(question.answer)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
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
                .appCard()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppStyle.screenPadding)
            .padding(.bottom, 180)
        }
        .background(AppStyle.screenBackground)
    }

    private var categoryEasterEggMessages: [(title: String, message: String)] {
        [
            ("💘최고미녀 김지혜💕", "너무 이쁜 김지혜😍"),
            ("💝사랑하는 김지혜💝", "조녜 김지혜💝"),
            ("누가 제일 이쁘다고?", "💓김지혜라고💓"),
            ("세상 제일 이쁜 여자는?", "💖김.지.혜💖"),
            ("김지혜 사랑해♥️", "💙💙💙세젤예 김지혜 뽀뽀 쪽😘💙💙"),
            ("김지혜가 짱이야❣️❣️❣️", "🌟🌟🌟김지혜가 짱이지🌟🌟🌟")
        ]
    }

    private func showCategoryEasterEgg() {
        let message = categoryEasterEggMessages.randomElement() ?? categoryEasterEggMessages[0]
        categoryEasterEggAlertTitle = message.title
        categoryEasterEggAlertMessage = message.message
        isCategoryEasterEggAlertVisible = true
    }
}

#Preview {
    PracticeView(viewModel: PracticeViewModel())
        .environmentObject(ProgressStore())
}
