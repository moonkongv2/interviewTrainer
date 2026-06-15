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
    @State private var isEasterEggAlertVisible = false
    @State private var easterEggAlertTitle = ""
    @State private var easterEggAlertMessage = ""

    private var selectedCategoryQuestionCount: Int {
        questionsInSelectedCategory.count
    }

    private var weakQuestionCount: Int {
        progressStore.weakQuestionIds.count
    }

    private var questionsInSelectedCategory: [Question] {
        guard viewModel.selectedCategory != "All" else {
            return viewModel.allQuestions
        }

        return viewModel.allQuestions.filter { $0.category == viewModel.selectedCategory }
    }

    private var weakQuestionCountInSelectedCategory: Int {
        questionsInSelectedCategory.filter { progressStore.weakQuestionIds.contains($0.id) }.count
    }

    private var weakQuestionHintMessage: String {
        if weakQuestionCountInSelectedCategory == 0 {
            return "Mark questions as weak during practice to review them later."
        }

        return "Weak questions are ready for review."
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppStyle.sectionSpacing) {
                    headerSection
                    questionSummarySection
                    practiceSettingsSection
                    practiceActionsSection
                    librarySection
                }
                .padding(AppStyle.screenPadding)
            }
            .background(AppStyle.screenBackground)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isPracticeActive) {
                PracticeView(viewModel: viewModel)
                    .environmentObject(progressStore)
            }
            .alert(easterEggAlertTitle, isPresented: $isEasterEggAlertVisible) {
                Button("확인", role: .cancel) {}
            } message: {
                Text(easterEggAlertMessage)
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(AppFeatureFlags.isEasterEggEnabled ? "지혜로운 암기 노트>_<\n김지혜 화이팅❤️❤️❤️" : "지혜로운 암기 노트😎\n합격하세요🍀🍀🍀")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
                .onTapGesture(count: 3) {
                    showEasterEgg(from: titleEasterEggMessages)
                }

//            Text("오늘 볼 문제를 고르고 바로 연습을 시작하세요.")
//                .font(.subheadline)
//                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    private var questionSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                AppStatCard(
                    title: "Total Questions",
                    value: "\(viewModel.allQuestions.count)",
                    systemImage: "square.stack.3d.up"
                )
                .onTapGesture(count: 3) {
                    showEasterEgg(from: questionCountEasterEggMessages)
                }

                AppStatCard(
                    title: "Weak Questions",
                    value: "\(weakQuestionCount)",
                    systemImage: "bookmark.fill",
                    color: .orange
                )
                .onTapGesture(count: 3) {
                    showEasterEgg(from: questionCountEasterEggMessages)
                }
            }

            if viewModel.allQuestions.isEmpty {
                Text("No questions are available yet. Add questions.json to the app bundle and try again.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 2)
            }
        }
    }

    private var practiceSettingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Practice Settings")
                .font(.headline)

            HStack(spacing: 12) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title3)
                    .foregroundStyle(.blue)

                Picker("Category", selection: $viewModel.selectedCategory) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .appCard()
    }

    private var practiceActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Practice")
                .font(.headline)

            Button {
                startPractice(weakOnlyMode: false)
            } label: {
                AppActionRow(
                    title: "Start Practice",
                    subtitle: "\(selectedCategoryQuestionCount) questions available",
                    systemImage: "play.fill",
                    color: .blue,
                    showsChevron: false
                )
            }
            .buttonStyle(.plain)
            .disabled(selectedCategoryQuestionCount == 0)
            .opacity(selectedCategoryQuestionCount == 0 ? 0.45 : 1)

            Button {
                startPractice(weakOnlyMode: true)
            } label: {
                AppActionRow(
                    title: "Practice Weak Questions",
                    subtitle: "\(weakQuestionCountInSelectedCategory) saved for review",
                    systemImage: "bookmark.fill",
                    color: .orange,
                    showsChevron: false
                )
            }
            .buttonStyle(.plain)
            .disabled(weakQuestionCountInSelectedCategory == 0)
            .opacity(weakQuestionCountInSelectedCategory == 0 ? 0.45 : 1)

            if selectedCategoryQuestionCount == 0 && !viewModel.allQuestions.isEmpty {
                Text("No questions match the selected category.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Text(weakQuestionHintMessage)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .onTapGesture(count: 3) {
                    showEasterEgg(from: weakHintEasterEggMessages)
                }
        }
        .appCard()
    }

    private var librarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Library")
                .font(.headline)

            NavigationLink {
                QuestionListView(questions: viewModel.allQuestions)
                    .environmentObject(progressStore)
            } label: {
                AppActionRow(
                    title: "Question List",
                    subtitle: "Browse questions and answers",
                    systemImage: "list.bullet.rectangle",
                    color: .indigo
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                EnergyView()
            } label: {
                AppActionRow(
                    title: "Energy",
                    subtitle: "Open motivation images",
                    systemImage: "sparkles",
                    color: .pink
                )
            }
            .buttonStyle(.plain)
        }
        .appCard()
    }

    private var titleEasterEggMessages: [(title: String, message: String)] {
        [
            ("김지혜 화이팅❤️", "❤️❤️❤️이쁜 김지혜 짱짱🙌❤️❤️❤️"),
            ("최고미녀 김지혜💕", "✨✨세상 제일 이쁜 김지혜^0^✨"),
            ("♥️사랑해 김지혜♥️", "김지혜 화이팅😘😘😘")
        ]
    }

    private var questionCountEasterEggMessages: [(title: String, message: String)] {
        [
            ("세상 제일 이쁜 여자는?", "💖김.지.혜💖"),
            ("김지혜 사랑해♥️", "💙💙💙세젤예 김지혜 뽀뽀 쪽😘💙💙"),
            ("김지혜가 짱이야❣️❣️❣️", "🌟🌟🌟김지혜가 짱이지🌟🌟🌟")
        ]
    }

    private var weakHintEasterEggMessages: [(title: String, message: String)] {
        [
            ("💘최고미녀 김지혜💕", "너무 이쁜 김지혜😍"),
            ("💝사랑하는 김지혜💝", "조녜 김지혜💝"),
            ("누가 제일 이쁘다고?", "💓김지혜라고💓")
        ]
    }

    private func startPractice(weakOnlyMode: Bool) {
        viewModel.weakOnlyMode = weakOnlyMode
        viewModel.nextRandomQuestion(progressStore: progressStore)
        isPracticeActive = true
    }

    private func showEasterEgg(from messages: [(title: String, message: String)]) {
        guard AppFeatureFlags.isEasterEggEnabled else {
            return
        }

        let message = messages.randomElement() ?? messages[0]
        easterEggAlertTitle = message.title
        easterEggAlertMessage = message.message
        isEasterEggAlertVisible = true
    }
}

#Preview {
    HomeView()
        .environmentObject(ProgressStore())
}
