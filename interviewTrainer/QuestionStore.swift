//
//  QuestionStore.swift
//  interviewTrainer
//
//  Created by Moonsik Kong on 6/13/26.
//

import Foundation

enum QuestionStore {
    static func loadQuestions(from bundle: Bundle = .main) -> [Question] {
        guard let url = bundle.url(forResource: "questions", withExtension: "json") else {
            logLoadFailure("questions.json not found in bundle.")
            return fallbackSamples
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Question].self, from: data)
        } catch {
            logLoadFailure("Failed to load questions.json: \(error)")
            return fallbackSamples
        }
    }

    static let fallbackSamples: [Question] = [
        Question(
            id: "fallback-001",
            category: "운동생리학",
            question: "유산소 운동과 무산소 운동의 차이를 설명하시오.",
            answer: "유산소 운동은 산소를 이용해 장시간 에너지를 공급하는 운동이고, 무산소 운동은 짧고 강한 활동에서 산소 공급보다 빠르게 에너지를 만드는 운동입니다.",
            tags: ["에너지대사", "운동처방"]
        ),
        Question(
            id: "fallback-002",
            category: "스포츠심리학",
            question: "시합 전 긴장을 낮추기 위한 심리 기술을 설명하시오.",
            answer: "심호흡, 점진적 근육 이완, 긍정적 자기 대화, 심상 훈련 등을 활용해 각성 수준을 조절하고 집중을 유지할 수 있습니다.",
            tags: ["불안조절", "심리기술"]
        )
    ]

    private static func logLoadFailure(_ message: String) {
        #if DEBUG
        print("[QuestionStore] \(message)")
        #endif
    }
}
