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

    init(category: FCDCategory, testedLanguageCode: String) {
        self.flashcards = (category.flashcards!.allObjects as! [FCDFlaschard]).map { (flashcard: FCDFlaschard) -> DirectionalFlashcard? in
            var spelling: String?
            var translation: String?
            for word in flashcard.words!.allObjects as! [FCDWord] {
                if word.language!.code == testedLanguageCode {
                    translation = word.spelling
                } else {
                    spelling = word.spelling
                }
            }

            if let spelling = spelling, let translation = translation {
                return DirectionalFlashcard(spelling: spelling, translation: translation)
            } else {
                return nil
            }
        }.compactMap { $0 }

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
