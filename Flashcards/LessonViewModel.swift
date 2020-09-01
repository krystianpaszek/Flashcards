//
//  LessonViewModel.swift
//  Flashcards
//
//  Created by Krystian Paszek on 01/09/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import Foundation

class LessonViewModel: ObservableObject {

    let flashcards: [DirectionalFlashcard]
    var traversedIndexes: Set<Int> = Set([])
    var indexesFromFlashcard: Set<Int> {
        Set((0..<flashcards.count).map { $0 })
    }
    var availableIndexes: Set<Int> {
        indexesFromFlashcard.subtracting(traversedIndexes)
    }
    @Published var currentIndex = 0

    @Published var remainingWordsCount: Int = 0
    @Published var currentWord: String = ""
    var currentTranslation: String = ""
    @Published var errorsCount: Int = 0

    init(lesson: FCDLesson) {
        let text = String(data: lesson.data!, encoding: .utf8)!
        let parser = TestYourEnglishFormatParser()
        self.flashcards = parser.parse(rawText: text)

        self.remainingWordsCount = flashcards.count
        let startIndex = availableIndexes.randomElement()!
        self.currentWord = flashcards[startIndex].spelling
        self.currentTranslation = flashcards[startIndex].translation
        self.currentIndex = startIndex
    }

    func submit(translation submittedTranslation: String) -> Bool {
        let currentTranslation = flashcards[currentIndex].translation
        if submittedTranslation == currentTranslation {
            self.traversedIndexes.insert(currentIndex)
            return true
        } else {
            self.errorsCount += 1
            return false
        }
    }

    func nextWord() -> Bool {
        self.remainingWordsCount = flashcards.count - traversedIndexes.count
        guard let nextIndex = availableIndexes.randomElement() else {
            return false
        }

        self.currentIndex = nextIndex
        self.currentWord = flashcards[nextIndex].spelling
        self.currentTranslation = flashcards[nextIndex].translation

        return true
    }
}
