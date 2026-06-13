//
//  PracticeViewModel.swift
//  interviewTrainer
//
//  Created by Moonsik Kong on 6/13/26.
//

import Combine
import Foundation

final class PracticeViewModel: ObservableObject {
    @Published var allQuestions: [Question]
    @Published var currentQuestion: Question?
    @Published var selectedCategory: String
    @Published var weakOnlyMode: Bool
    @Published var isAnswerVisible: Bool
    @Published private(set) var recentQuestionIds: [String]

    private let progressStore: ProgressStore?
    private let recentQuestionLimit = 5

    init(
        allQuestions: [Question] = QuestionStore.loadQuestions(),
        progressStore: ProgressStore? = nil
    ) {
        self.allQuestions = allQuestions
        self.progressStore = progressStore
        currentQuestion = nil
        selectedCategory = "All"
        weakOnlyMode = false
        isAnswerVisible = false
        recentQuestionIds = []
    }

    var categories: [String] {
        let categoryNames = Set(allQuestions.map(\.category)).sorted()
        return ["All"] + categoryNames
    }

    var filteredQuestions: [Question] {
        filteredQuestions(progressStore: progressStore)
    }

    func filteredQuestions(progressStore: ProgressStore?) -> [Question] {
        var questions = allQuestions

        if selectedCategory != "All" {
            questions = questions.filter { $0.category == selectedCategory }
        }

        if weakOnlyMode {
            guard let progressStore else {
                return []
            }

            questions = questions.filter { progressStore.weakQuestionIds.contains($0.id) }
        }

        return questions
    }

    func nextRandomQuestion() {
        nextRandomQuestion(progressStore: progressStore)
    }

    func nextRandomQuestion(progressStore: ProgressStore) {
        nextRandomQuestion(progressStore: Optional(progressStore))
    }

    func showAnswer() {
        isAnswerVisible = true
    }

    func markKnown(progressStore: ProgressStore) {
        guard let currentQuestion else {
            nextRandomQuestion(progressStore: progressStore)
            return
        }

        if progressStore.isWeak(currentQuestion) {
            progressStore.removeWeak(currentQuestion)
        }

        nextRandomQuestion(progressStore: progressStore)
    }

    func markWeak(progressStore: ProgressStore) {
        guard let currentQuestion else {
            nextRandomQuestion(progressStore: progressStore)
            return
        }

        progressStore.markWeak(currentQuestion)
        nextRandomQuestion(progressStore: progressStore)
    }

    private func nextRandomQuestion(progressStore: ProgressStore?) {
        let questions = filteredQuestions(progressStore: progressStore)

        guard !questions.isEmpty else {
            currentQuestion = nil
            isAnswerVisible = false
            return
        }

        let candidates: [Question]
        if questions.count > recentQuestionLimit {
            let recentIds = Set(recentQuestionIds)
            let nonRecentQuestions = questions.filter { !recentIds.contains($0.id) }
            candidates = nonRecentQuestions.isEmpty ? questions : nonRecentQuestions
        } else {
            candidates = questions
        }

        guard let nextQuestion = candidates.randomElement() else {
            currentQuestion = nil
            isAnswerVisible = false
            return
        }

        currentQuestion = nextQuestion
        isAnswerVisible = false
        addRecentQuestionId(nextQuestion.id)
    }

    private func addRecentQuestionId(_ questionId: String) {
        recentQuestionIds.append(questionId)

        if recentQuestionIds.count > recentQuestionLimit {
            recentQuestionIds.removeFirst(recentQuestionIds.count - recentQuestionLimit)
        }
    }
}
