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

    private var filteredQuestionCount: Int {
        viewModel.filteredQuestions(progressStore: progressStore).count
    }

    private var weakQuestionCount: Int {
        progressStore.weakQuestionIds.count
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Oral Random Trainer")
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
                    .disabled(filteredQuestionCount == 0)

                    Button("Practice Weak Questions") {
                        startPractice(weakOnlyMode: true)
                    }
                    .disabled(weakQuestionCount == 0)

                    if filteredQuestionCount == 0 && !viewModel.allQuestions.isEmpty {
                        Text("No questions match the selected category.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    if weakQuestionCount == 0 {
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
