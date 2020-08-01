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

@discardableResult
private func makeLanguage(name: String, code: String, in context: NSManagedObjectContext) -> FCDLanguage {
    let english = FCDLanguage(context: context)
    english.id = UUID()
    english.name = name
    english.code = code
    return english
}

private func getLanguage(code: String, in context: NSManagedObjectContext) -> FCDLanguage {
    let fetchRequest: NSFetchRequest<FCDLanguage> = FCDLanguage.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "code == %@", code)
    let result = try! context.fetch(fetchRequest)
    return result.first!
}

@discardableResult
private func makeWord(spelling: String, languageCode: String, in context: NSManagedObjectContext) -> FCDWord {
    let word = FCDWord(context: context)
    word.id = UUID()
    word.spelling = spelling
    word.language = getLanguage(code: languageCode, in: context)
    return word
}
