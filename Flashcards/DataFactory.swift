//
//  DataFactory.swift
//  Flashcards
//
//  Created by Krystian Paszek on 01/08/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import UIKit
import CoreData

class DataFactory: NSObject {

    // MARK: - Dependencies
    let context: NSManagedObjectContext

    // MARK: - Initialization
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Public functions
    func populateCoreData() {
        createLanguages()
        createWords()
        createFlashcards()
    }

    // MARK: - Private functions
    private func createLanguages() {
        makeLanguage(name: "Polish", code: "pl", in: context)
        makeLanguage(name: "English", code: "en", in: context)
        makeLanguage(name: "German", code: "de", in: context)

        saveContext()
    }

    private func createWords() {
        makeWord(spelling: "riechen", languageCode: "de", in: context)
        makeWord(spelling: "smell", languageCode: "en", in: context)
        makeWord(spelling: "laufen", languageCode: "de", in: context)
        makeWord(spelling: "to run", languageCode: "en", in: context)

        saveContext()
    }

    private func createFlashcards() {

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
    guard countOfLanguages(withCode: code, in: context) == 0 else { return nil }

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
private func makeCategory(name: String, code: String, in context: NSManagedObjectContext) -> FCDCategory? {
    guard countOfCategories(withName: code, in: context) == 0 else { return nil }

    let category = FCDCategory(context: context)
    category.id = UUID()
    category.name = name
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
    guard countOfWords(withSpelling: spelling, languageCode: languageCode, in: context) == 0 else { return nil }

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
    guard countOfFlashcards(withWords: [firstWord, secondWord], in: context) == 0 else { return nil }

    let flashcard = FCDFlaschard(context: context)
    flashcard.words = [firstWord, secondWord]
    return flashcard
}

private func countOfFlashcards(withWords words: [FCDWord], in context: NSManagedObjectContext) -> Int {
    let fetchRequest: NSFetchRequest<FCDFlaschard> = FCDFlaschard.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "words IN %@", words)
    let count = try! context.count(for: fetchRequest)
    return count
}

private func getFlashcard(withWords words: [FCDWord], in context: NSManagedObjectContext) -> FCDFlaschard {
    let fetchRequest: NSFetchRequest<FCDFlaschard> = FCDFlaschard.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "words IN %@", words)
    let result = try! context.fetch(fetchRequest)
    return result.first!
}
