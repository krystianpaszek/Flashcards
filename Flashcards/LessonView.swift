//
//  LessonView.swift
//  Flashcards
//
//  Created by Krystian Paszek on 01/09/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import SwiftUI

protocol LessonViewModelProtocol {
    var remainingWordsCount: Int { get }
    var errorsCount: Int { get }
    var currentWord: String { get }

    func submit(translation: String) -> Bool
}

struct MockLessonViewModel: LessonViewModelProtocol {
    var remainingWordsCount: Int
    var errorsCount: Int
    var currentWord: String

    func submit(translation: String) -> Bool {
        return true
    }
}

struct DirectionalFlashcard {
    let spelling: String
    let translation: String
}

class LessonViewModel: LessonViewModelProtocol, ObservableObject {

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

    func nextWord() {
        let nextIndex = availableIndexes.randomElement()!
        self.currentIndex = nextIndex
        self.currentWord = flashcards[nextIndex].spelling
        self.currentTranslation = flashcards[nextIndex].translation
        self.remainingWordsCount = flashcards.count - traversedIndexes.count
    }
}

struct LessonView: View {

    @State private var originalSpelling: String = ""
    @State private var translation: String = ""
    @ObservedObject var model: LessonViewModel

    @State private var isShowingErrorModal: Bool = false

    var body: some View {
        ZStack(alignment: .top) {
            Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            VStack {
                List {
                    Section(
                        header: Text("REMAINING - \(model.remainingWordsCount)"),
                        footer: Text("ERRORS - \(model.errorsCount)")
                    ) {
                        TextField(model.currentWord, text: $originalSpelling).disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        TextField("", text: $translation, onCommit: {
                            checkWord()
                        })
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    Section() {
                        HStack(alignment: .center) {
                            Spacer()
                            Button("Check") {
                                checkWord()
                            }
                            .keyboardShortcut(.return)
                            .alert(isPresented: $isShowingErrorModal, content: {
                                Alert(
                                    title: Text("Erorr! Correct translation:"),
                                    message: Text(model.currentTranslation),
                                    dismissButton: Alert.Button.cancel() {
                                        translation = ""
                                        model.nextWord()
                                    }
                                )
                            })
                            Spacer()
                        }
                    }
                }
                .frame(height: 300)

            }
        }
        .listStyle(GroupedListStyle())
    }

    private func checkWord() {
        if !model.submit(translation: translation) {
            isShowingErrorModal = true
        } else {
            translation = ""
            model.nextWord()
        }
    }
}

//struct LessonView_Previews: PreviewProvider {
//    static var previews: some View {
//        let model = MockLessonViewModel(
//            remainingWordsCount: 20,
//            errorsCount: 3,
//            currentWord: "versuchen"
//        )
//        LessonView(model: model)
//    }
//}
