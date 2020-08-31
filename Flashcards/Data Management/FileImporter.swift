//
//  FileImporter.swift
//  Flashcards
//
//  Created by Krystian Paszek on 30/08/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct FileImporter {
    static let shared = FileImporter()
    var dataFactory: DataFactory {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.dataFactory
    }

    func load(contentsOf url: URL) throws {
        let data = try Data(contentsOf: url)
        let filename = url.lastPathComponent
        let text = String(data: data, encoding: .utf8)!
        let parser = TestYourEnglishFormatParser()
        let items = parser.parse(rawText: text)

        let flashcards = items.map { item -> FCDFlaschard? in
            guard let originalWord = dataFactory.addWord(spelling: item.originalSpelling, languageCode: "de") else { return nil }
            guard let translatedWord = dataFactory.addWord(spelling: item.translation, languageCode: "pl") else { return nil }
            return dataFactory.addFlashcard(firstWord: originalWord, secondWord: translatedWord)!
        }.compactMap { $0 }

        dataFactory.addCategory(name: filename, flashcards: flashcards)
    }
}
