//
//  WordsList.swift
//  Flashcards
//
//  Created by Krystian Paszek on 31/07/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import SwiftUI

struct WordsList: View {

    @FetchRequest(
        entity: FCDWord.entity(),
        sortDescriptors: [NSSortDescriptor(key: "spelling", ascending: true)]
    )
    private var words: FetchedResults<FCDWord>

    var body: some View {
        VStack {
            List {
                Section(header: Text("")) {
                    ForEach(words) { word in
                        Text(word.spelling!)
                    }
                }
            }.listStyle(GroupedListStyle())
            AddWordView()
        }.navigationBarTitle("Words")
    }
}

struct AddWordView: View {
    @EnvironmentObject private var dataFactory: DataFactory
    @State private var newWordName: String = ""

    var body: some View {
        HStack {
            TextField("Enter new word", text: $newWordName)
            Button(action: {
                self.addWord()
            }, label: {
                Text("Add word")
            })
        }.padding(.all)
    }

    private func addWord() {
        dataFactory.addWord(spelling: newWordName, languageCode: "de")
    }
}

struct WordsList_Previews: PreviewProvider {
    static var previews: some View {
        WordsList()
    }
}
