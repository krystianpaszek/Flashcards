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
    @State private var isImporting: Bool = false

    var body: some View {
        List {
            Section(header: Text("")) {
                ForEach(lessons) { lesson in
                    NavigationLink(destination: LessonView(model: LessonViewModel(lesson: lesson))) {
                        Text(lesson.name!)
                    }
                }
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

}

struct LessonList_Previews: PreviewProvider {
    static var previews: some View {
        LessonList()
    }
}
