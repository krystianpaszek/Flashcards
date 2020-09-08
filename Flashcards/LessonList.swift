//
//  LessonList.swift
//  Flashcards
//
//  Created by Krystian Paszek on 31/07/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import SwiftUI

struct LessonList: View {

    @FetchRequest(entity: FCDLesson.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var lessons: FetchedResults<FCDLesson>
    @EnvironmentObject private var dataFactory: DataFactory
    @State private var isImporting: Bool = false

    var body: some View {
        List {
            Section(header: Text("")) {
                ForEach(lessons) { lesson in
                    NavigationLink(destination: LessonView(model: LessonViewModel(lesson: lesson))) {
                        Text(lesson.name!)
                    }
                }.onDelete(perform: deleteLessons(at:))
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Select lesson")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add") {
                    self.isImporting = true
                }
            }
        }
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [.text], onCompletion: { result in
            do {
                let selectedFile = try result.get()
                try FileImporter.shared.load(contentsOf: selectedFile)
            } catch {
                print(error)
            }
        })
    }

    private func deleteLessons(at offsets: IndexSet) {
        offsets.forEach { offset in
            let lesson = lessons[offset]

            guard let lessonName = lesson.name else { return }
            dataFactory.removeLesson(name: lessonName)
        }
    }
}

struct LessonList_Previews: PreviewProvider {
    static var previews: some View {
        LessonList()
    }
}
