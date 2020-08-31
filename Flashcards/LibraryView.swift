//
//  LibraryView.swift
//  Flashcards
//
//  Created by Krystian Paszek on 01/08/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import SwiftUI
import CoreData

struct LibraryView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var dataFactory: DataFactory

    @State private var isImporting: Bool = false
    @State private var isShowingAlert: Bool = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("")) {
                    NavigationLink(destination: LanguagesList()) {
                        LibraryRow(text: "Languages", count: languagesCount())
                    }
                    NavigationLink(destination: CategoriesList()) {
                        LibraryRow(text: "Categories", count: categoriesCount())
                    }
                    NavigationLink(destination: WordsList()) {
                        LibraryRow(text: "Words", count: wordsCount())
                    }
                    NavigationLink(destination: FlashcardsList()) {
                        LibraryRow(text: "Flashcards", count: flashcardCount())
                    }
                }
                Section(header: Text("Utilities")) {
                    Button("Clear data store") {
                        self.isShowingAlert = true
                    }.alert(isPresented: $isShowingAlert) {
                        Alert(
                            title: Text("Clear data store"),
                            message: Text("Are you sure?"),
                            primaryButton: Alert.Button.cancel(),
                            secondaryButton: Alert.Button.destructive(Text("Yes")) { dataFactory.clearCoreData() }
                        )
                    }
                    Button("Import file") {
                        self.isImporting = true
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Library")
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

    private func languagesCount() -> Int {
        return count(for: FCDLanguage.fetchRequest())
    }

    private func categoriesCount() -> Int {
        return count(for: FCDCategory.fetchRequest())
    }

    private func wordsCount() -> Int {
        return count(for: FCDWord.fetchRequest())
    }

    private func flashcardCount() -> Int {
        return count(for: FCDFlaschard.fetchRequest())
    }

    private func count(for fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> Int {
        let count = (try? context.count(for: fetchRequest)) ?? 0
        return count
    }
}

struct LibraryRow: View {
    let text: String
    let count: Int

    var body: some View {
        HStack {
            Text(text)
            Spacer()
            Text("\(count)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
