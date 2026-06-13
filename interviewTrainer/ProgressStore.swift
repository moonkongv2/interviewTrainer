//
//  ProgressStore.swift
//  interviewTrainer
//
//  Created by Moonsik Kong on 6/13/26.
//

import Combine
import Foundation

final class ProgressStore: ObservableObject {
    @Published private(set) var weakQuestionIds: Set<String> {
        didSet {
            saveWeakQuestionIds()
        }
    }

    private let userDefaults: UserDefaults
    private let weakQuestionIdsKey = "weakQuestionIds"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        let savedIds = userDefaults.stringArray(forKey: weakQuestionIdsKey) ?? []
        weakQuestionIds = Set(savedIds)
    }

    func isWeak(_ question: Question) -> Bool {
        weakQuestionIds.contains(question.id)
    }

    func markWeak(_ question: Question) {
        weakQuestionIds.insert(question.id)
    }

    func removeWeak(_ question: Question) {
        weakQuestionIds.remove(question.id)
    }

    func toggleWeak(_ question: Question) {
        if isWeak(question) {
            removeWeak(question)
        } else {
            markWeak(question)
        }
    }

    func clearWeakQuestions() {
        weakQuestionIds.removeAll()
    }

    private func saveWeakQuestionIds() {
        userDefaults.set(Array(weakQuestionIds).sorted(), forKey: weakQuestionIdsKey)
    }
}
