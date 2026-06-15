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
        VStack(spacing: 12) {
            Button {
                viewModel.markKnown(progressStore: progressStore)
            } label: {
                PracticeActionButtonLabel(
                    title: "I Know This",
                    systemImage: "checkmark.circle.fill",
                    color: .blue,
                    isProminent: true
                )
            }
            .buttonStyle(.plain)

            HStack(spacing: 12) {
                Button {
                    viewModel.markWeak(progressStore: progressStore)
                } label: {
                    PracticeActionButtonLabel(
                        title: "Review Again",
                        systemImage: "bookmark.fill",
                        color: .orange
                    )
                }
                .buttonStyle(.plain)

                Button {
                    viewModel.nextRandomQuestion(progressStore: progressStore)
                } label: {
                    PracticeActionButtonLabel(
                        title: "Next Question",
                        systemImage: "arrow.right.circle.fill",
                        color: .indigo
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppStyle.screenPadding)
        .background(.bar)
    }

    private func questionContent(_ question: Question) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppStyle.sectionSpacing) {
                VStack(alignment: .leading, spacing: AppStyle.cardSpacing) {
                    HStack {
                        Label(question.category, systemImage: "folder.fill")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(AppStyle.rowBackground)
                            .clipShape(Capsule())
                            .onTapGesture(count: 3) {
                                showCategoryEasterEgg()
                            }

                        Spacer()

                        if progressStore.isWeak(question) {
                            Label("Saved", systemImage: "bookmark.fill")
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
                    HStack {
                        Text("Answer")
                            .font(.headline)

                        Spacer()

                        Image(systemName: viewModel.isAnswerVisible ? "eye.fill" : "eye.slash.fill")
                            .foregroundStyle(.secondary)
                    }

                    if viewModel.isAnswerVisible {
                        Text(question.answer)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        HStack(spacing: 10) {
                            Image(systemName: "lock.fill")
                                .foregroundStyle(.secondary)

                            Text("Answer is hidden.")
                                .font(.body)
                                .foregroundStyle(.secondary)

                            Spacer()
                        }
                        .padding(14)
                        .background(AppStyle.rowBackground)
                        .clipShape(RoundedRectangle(cornerRadius: AppStyle.rowCornerRadius, style: .continuous))
                    }

                    Button {
                        if viewModel.isAnswerVisible {
                            viewModel.isAnswerVisible = false
                        } else {
                            viewModel.showAnswer()
                        }
                    } label: {
                        Label(
                            viewModel.isAnswerVisible ? "Hide Answer" : "Show Answer",
                            systemImage: viewModel.isAnswerVisible ? "eye.slash.fill" : "eye.fill"
                        )
                        .font(.body)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.borderedProminent)
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
        guard AppFeatureFlags.isEasterEggEnabled else {
            return
        }

        let message = categoryEasterEggMessages.randomElement() ?? categoryEasterEggMessages[0]
        categoryEasterEggAlertTitle = message.title
        categoryEasterEggAlertMessage = message.message
        isCategoryEasterEggAlertVisible = true
    }
}

private struct PracticeActionButtonLabel: View {
    let title: String
    let systemImage: String
    let color: Color
    var isProminent = false

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.body)
            .fontWeight(.semibold)
            .lineLimit(1)
            .minimumScaleFactor(0.85)
            .frame(maxWidth: .infinity, minHeight: isProminent ? 52 : 48)
            .foregroundStyle(isProminent ? .white : color)
            .background(isProminent ? color : color.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: AppStyle.rowCornerRadius, style: .continuous))
    }
}

#Preview {
    PracticeView(viewModel: PracticeViewModel())
        .environmentObject(ProgressStore())
}
