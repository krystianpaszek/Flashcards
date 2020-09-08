//
//  TestYourEnglishFormatParser.swift
//  Flashcards
//
//  Created by Krystian Paszek on 30/08/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import Foundation

struct TestYourEnglishFormatParser {
    func parse(rawText string: String) -> [DirectionalFlashcard] {
        string
            .components(separatedBy: "\r\n")
            .filter { !$0.isEmpty }
            .map { line in
                let components = line.components(separatedBy: ";")
                let original =  components[1]
                let translation = components[2]
                return DirectionalFlashcard(spelling: original, translation: translation)
            }
    }
}
