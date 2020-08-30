//
//  DataFactory.swift
//  Flashcards
//
//  Created by Krystian Paszek on 01/08/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import UIKit
import CoreData
import SwiftUI

class DataFactory: NSObject, ObservableObject {

    // MARK: - Dependencies
    let context: NSManagedObjectContext

    // MARK: - Initialization
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Adding entities
    @discardableResult
    func addWord(spelling: String, languageCode: String) -> FCDWord? {
        let word = makeWord(spelling: spelling, languageCode: languageCode, in: context)
        saveContext()
        return word
    }

    @discardableResult
    func addLanguage(name: String, code: String) -> FCDLanguage? {
        let language = makeLanguage(name: name, code: code, in: context)
        saveContext()
        return language
    }

    @discardableResult
    func addFlashcard(firstWord: FCDWord, secondWord: FCDWord) -> FCDFlaschard? {
        let flashcard = makeFlashcard(firstWord: firstWord, secondWord: secondWord, in: context)
        saveContext()
        return flashcard
    }

    @discardableResult
    func addCategory(name: String, flashcards: [FCDFlaschard]) -> FCDCategory? {
        let category = makeCategory(name: name, flashcards: flashcards, in: context)
        saveContext()
        return category
    }

    // MARK: - Public functions
    func clearCoreData() {
        removeAll(in: FCDLanguage.fetchRequest(), context: context)
        removeAll(in: FCDCategory.fetchRequest(), context: context)
        removeAll(in: FCDFlaschard.fetchRequest(), context: context)
        removeAll(in: FCDWord.fetchRequest(), context: context)

        saveContext()
    }

    func populateCoreData() {
        createLanguages()
        createCategories()
    }

    // MARK: - Private functions
    private func createLanguages() {
        makeLanguage(name: "Polish", code: "pl", in: context)
        makeLanguage(name: "English", code: "en", in: context)
        makeLanguage(name: "German", code: "de", in: context)

        saveContext()
    }

    private func createCategories() {
        makeCategory(name: "Prepoluated category", flashcards: [
            makeFlashcard(
                firstWord: makeWord(spelling: "riechen", languageCode: "de", in: context)!,
                secondWord: makeWord(spelling: "smell", languageCode: "en", in: context)!,
                in: context
            )!,
            makeFlashcard(
                firstWord: makeWord(spelling: "laufen", languageCode: "de", in: context)!,
                secondWord: makeWord(spelling: "to run", languageCode: "en", in: context)!,
                in: context
            )!,
            makeFlashcard(
                firstWord: makeWord(spelling: "besuchen", languageCode: "de", in: context)!,
                secondWord: makeWord(spelling: "to visit", languageCode: "en", in: context)!,
                in: context
            )!,
        ], in: context)

        saveContext()
    }

    private func saveContext() {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            debugPrint(error)
        }
    }
}

// MARK: - Languages
@discardableResult
private func makeLanguage(name: String, code: String, in context: NSManagedObjectContext) -> FCDLanguage? {
    guard countOfLanguages(withCode: code, in: context) == 0 else {
        return getLanguage(code: code, in: context)
    }

    let language = FCDLanguage(context: context)
    language.id = UUID()
    language.name = name
    language.code = code
    return language
}

private func countOfLanguages(withCode code: String, in context: NSManagedObjectContext) -> Int {
    let fetchRequest: NSFetchRequest<FCDLanguage> = FCDLanguage.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "code == %@", code)
    let count = try! context.count(for: fetchRequest)
    return count
}

private func getLanguage(code: String, in context: NSManagedObjectContext) -> FCDLanguage {
    let fetchRequest: NSFetchRequest<FCDLanguage> = FCDLanguage.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "code == %@", code)
    let result = try! context.fetch(fetchRequest)
    return result.first!
}

// MARK: - Categories
@discardableResult
private func makeCategory(name: String, flashcards: [FCDFlaschard], in context: NSManagedObjectContext) -> FCDCategory? {
    guard countOfCategories(withName: name, in: context) == 0 else {
        return getCategory(name: name, in: context)
    }

    let category = FCDCategory(context: context)
    category.id = UUID()
    category.name = name
    category.addToFlashcards(NSSet(array: flashcards))
    return category
}

private func countOfCategories(withName name: String, in context: NSManagedObjectContext) -> Int {
    let fetchRequest: NSFetchRequest<FCDCategory> = FCDCategory.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name == %@", name)
    let count = try! context.count(for: fetchRequest)
    return count
}

private func getCategory(name: String, in context: NSManagedObjectContext) -> FCDCategory {
    let fetchRequest: NSFetchRequest<FCDCategory> = FCDCategory.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name == %@", name)
    let result = try! context.fetch(fetchRequest)
    return result.first!
}

// MARK: - Words
@discardableResult
private func makeWord(spelling: String, languageCode: String, in context: NSManagedObjectContext) -> FCDWord? {
    guard countOfWords(withSpelling: spelling, languageCode: languageCode, in: context) == 0 else {
        return getWord(withSpelling: spelling, languageCode: languageCode, in: context)
    }

    let word = FCDWord(context: context)
    word.id = UUID()
    word.spelling = spelling
    word.language = getLanguage(code: languageCode, in: context)
    return word
}

private func countOfWords(withSpelling spelling: String, languageCode: String, in context: NSManagedObjectContext) -> Int {
    let fetchRequest: NSFetchRequest<FCDWord> = FCDWord.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "spelling == %@ && language.code == %@", spelling, languageCode)
    let count = try! context.count(for: fetchRequest)
    return count
}

private func getWord(withSpelling spelling: String, languageCode: String, in context: NSManagedObjectContext) -> FCDWord {
    let fetchRequest: NSFetchRequest<FCDWord> = FCDWord.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "spelling == %@ && language.code == %@", spelling, languageCode)
    let result = try! context.fetch(fetchRequest)
    return result.first!
}

// MARK: - Flashcards
@discardableResult
private func makeFlashcard(firstWord: FCDWord, secondWord: FCDWord, in context: NSManagedObjectContext) -> FCDFlaschard? {
    let words = [firstWord, secondWord]
    guard countOfFlashcards(withWords: words, in: context) == 0 else {
        return getFlashcard(withWords: words, in: context)
    }

    let flashcard = FCDFlaschard(context: context)
    flashcard.id = UUID()
    flashcard.words = [firstWord, secondWord]
    return flashcard
}

private func countOfFlashcards(withWords words: [FCDWord], in context: NSManagedObjectContext) -> Int {
    let fetchRequest: NSFetchRequest<FCDFlaschard> = FCDFlaschard.fetchRequest()
    let rawWords = words.compactMap(\.spelling)
    fetchRequest.predicate = NSPredicate(format: "SUBQUERY(words, $word, $word IN %@).@count > 0", rawWords)
    let count = try! context.count(for: fetchRequest)
    return count
}

private func getFlashcard(withWords words: [FCDWord], in context: NSManagedObjectContext) -> FCDFlaschard {
    let fetchRequest: NSFetchRequest<FCDFlaschard> = FCDFlaschard.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "words IN %@", words)
    let result = try! context.fetch(fetchRequest)
    return result.first!
}

// MARK: - General functions
private func removeAll<T: NSManagedObject>(in fetchRequest: NSFetchRequest<T>, context: NSManagedObjectContext) {
    (try! context.fetch(fetchRequest)).forEach { context.delete($0) }
}
