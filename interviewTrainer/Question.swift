//
//  Question.swift
//  interviewTrainer
//
//  Created by Moonsik Kong on 6/13/26.
//

import Foundation

struct Question: Identifiable, Codable, Hashable {
    let id: String
    let category: String
    let question: String
    let answer: String
    let tags: [String]
}
