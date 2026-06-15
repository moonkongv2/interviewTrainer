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
            Form {
                Section {
                    Text("지혜 외우기 노트>_<\n김지혜 화이팅❤️❤️❤️")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.vertical, 8)
                        .onTapGesture(count: 3) {
                            showEasterEgg(from: titleEasterEggMessages)
                        }

                    LabeledContent("Total Questions", value: "\(viewModel.allQuestions.count)")
                        .onTapGesture(count: 3) {
                            showEasterEgg(from: questionCountEasterEggMessages)
                        }
                    LabeledContent("Weak Questions", value: "\(weakQuestionCount)")
                        .onTapGesture(count: 3) {
                            showEasterEgg(from: questionCountEasterEggMessages)
                        }

                    if viewModel.allQuestions.isEmpty {
                        Text("No questions are available yet. Add questions.json to the app bundle and try again.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Practice Settings") {
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                }

                Section {
                    Button("Start Practice") {
                        startPractice(weakOnlyMode: false)
                    }
                    .disabled(selectedCategoryQuestionCount == 0)

                    Button("Practice Weak Questions") {
                        startPractice(weakOnlyMode: true)
                    }
                    .disabled(weakQuestionCountInSelectedCategory == 0)

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

                Section {
                    NavigationLink("Question List") {
                        QuestionListView(questions: viewModel.allQuestions)
                            .environmentObject(progressStore)
                    }
                }

                Section {
                    NavigationLink("Energy") {
                        EnergyView()
                    }
                }
            }
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
