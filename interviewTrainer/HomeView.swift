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

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("지혜 외우기 노트>_<\n김지혜 화이팅❤️")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.vertical, 8)

                    LabeledContent("Total Questions", value: "\(viewModel.allQuestions.count)")
                    LabeledContent("Weak Questions", value: "\(weakQuestionCount)")

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

                    if weakQuestionCountInSelectedCategory == 0 {
                        Text("Mark questions as weak during practice to review them later.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    NavigationLink("Question List") {
                        QuestionListView(questions: viewModel.allQuestions)
                            .environmentObject(progressStore)
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
