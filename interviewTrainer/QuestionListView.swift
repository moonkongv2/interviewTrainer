//
//  QuestionListView.swift
//  interviewTrainer
//
//  Created by Moonsik Kong on 6/13/26.
//

import SwiftUI

struct QuestionListView: View {
    let questions: [Question]

    @EnvironmentObject private var progressStore: ProgressStore
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var selectedQuestion: Question?

    private var categories: [String] {
        ["All"] + Set(questions.map(\.category)).sorted()
    }

    private var filteredQuestions: [Question] {
        questions.filter { question in
            let matchesCategory = selectedCategory == "All" || question.category == selectedCategory
            let matchesSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                || question.matches(searchText)

            return matchesCategory && matchesSearch
        }
    }

    var body: some View {
        List {
            Section {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
            }

            Section {
                if filteredQuestions.isEmpty {
                    ContentUnavailableView(
                        "No Questions",
                        systemImage: "magnifyingglass",
                        description: Text("No questions match this condition.")
                    )
                } else {
                    ForEach(filteredQuestions) { question in
                        Button {
                            selectedQuestion = question
                        } label: {
                            QuestionRow(question: question, isWeak: progressStore.isWeak(question))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationTitle("Question List")
        .searchable(text: $searchText, prompt: "Search questions")
        .sheet(item: $selectedQuestion) { question in
            NavigationStack {
                QuestionDetailView(question: question)
                    .environmentObject(progressStore)
            }
        }
    }
}

private struct QuestionRow: View {
    let question: Question
    let isWeak: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(question.category)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Text(question.question)
                    .font(.body)
                    .foregroundStyle(.primary)
            }

            Spacer()

            if isWeak {
                Image(systemName: "bookmark.fill")
                    .foregroundStyle(.orange)
                    .accessibilityLabel("Review Again")
            }
        }
        .contentShape(Rectangle())
    }
}

private struct QuestionDetailView: View {
    let question: Question

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var progressStore: ProgressStore

    var body: some View {
        List {
            Section("Category") {
                Text(question.category)
            }

            Section("Question") {
                Text(question.question)
                    .font(.headline)
            }

            Section("Answer") {
                Text(question.answer)
            }

            Section("Tags") {
                if question.tags.isEmpty {
                    Text("No tags")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(question.tags, id: \.self) { tag in
                        Text(tag)
                    }
                }
            }

            Section {
                Button(progressStore.isWeak(question) ? "Remove from Weak Questions" : "Add to Weak Questions") {
                    progressStore.toggleWeak(question)
                }
            }
        }
        .navigationTitle("Question Detail")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

private extension Question {
    func matches(_ searchText: String) -> Bool {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !query.isEmpty else {
            return true
        }

        return question.localizedCaseInsensitiveContains(query)
            || answer.localizedCaseInsensitiveContains(query)
            || category.localizedCaseInsensitiveContains(query)
            || tags.contains { $0.localizedCaseInsensitiveContains(query) }
    }
}

#Preview {
    NavigationStack {
        QuestionListView(questions: QuestionStore.fallbackSamples)
            .environmentObject(ProgressStore())
    }
}
