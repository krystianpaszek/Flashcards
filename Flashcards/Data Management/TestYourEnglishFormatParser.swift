//
//  TestYourEnglishFormatParser.swift
//  Flashcards
//
//  Created by Krystian Paszek on 30/08/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import Foundation

struct TestYourEnglishItem {
    let originalSpelling: String
    let translation: String
}

struct TestYourEnglishFormatParser {
    func parse(rawText string: String) -> [TestYourEnglishItem] {
        let lines = string.components(separatedBy: "\r\n")
        let items = lines.map { (line: String) -> TestYourEnglishItem in
            let components = line.components(separatedBy: ";")
            let original =  components[2]
            let translation = components[1]
            return TestYourEnglishItem(originalSpelling: original, translation: translation)
        }

        return items
    }
}
