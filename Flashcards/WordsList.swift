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
        }.navigationBarTitle("Words")
    }
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct WordsList_Previews: PreviewProvider {
    static var previews: some View {
        WordsList()
    }
}
