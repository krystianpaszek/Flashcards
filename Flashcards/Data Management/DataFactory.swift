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
    func addLesson(name: String, data: Data) -> FCDLesson? {
        let lesson = makeLesson(name: name, data: data, in: context)
        saveContext()
        return lesson
    }

    // MARK: - Removing entities
    func removeLesson(name: String) {
        let lesson = getLesson(name: name, in: context)
        context.delete(lesson)
        saveContext()
    }

    // MARK: - Public functions
    func clearCoreData() {
        removeAll(in: FCDLesson.fetchRequest(), context: context)

        saveContext()
    }

    func populateCoreData() {

    }

    // MARK: - Private functions

    private func saveContext() {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            debugPrint(error)
        }
    }
}

// MARK: - Lessons
@discardableResult
private func makeLesson(name: String, data: Data, in context: NSManagedObjectContext) -> FCDLesson? {
    guard countOfLessons(withName: name, in: context) == 0 else {
        return getLesson(name: name, in: context)
    }

    let lesson = FCDLesson(context: context)
    lesson.id = UUID()
    lesson.name = name
    lesson.data = data
    return lesson
}

private func countOfLessons(withName name: String, in context: NSManagedObjectContext) -> Int {
    let fetchRequest: NSFetchRequest<FCDLesson> = FCDLesson.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name == %@", name)
    let count = try! context.count(for: fetchRequest)
    return count
}

private func getLesson(name: String, in context: NSManagedObjectContext) -> FCDLesson {
    let fetchRequest: NSFetchRequest<FCDLesson> = FCDLesson.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name == %@", name)
    let result = try! context.fetch(fetchRequest)
    return result.first!
}

// MARK: - General functions
private func removeAll<T: NSManagedObject>(in fetchRequest: NSFetchRequest<T>, context: NSManagedObjectContext) {
    (try! context.fetch(fetchRequest)).forEach { context.delete($0) }
}
