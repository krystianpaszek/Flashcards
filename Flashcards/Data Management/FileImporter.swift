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

        dataFactory.addLesson(name: filename, data: data)
    }
}
