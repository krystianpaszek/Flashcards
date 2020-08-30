//
//  FlashcardsList.swift
//  Flashcards
//
//  Created by Krystian Paszek on 30/08/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import SwiftUI

struct FlashcardsList: View {

    @FetchRequest(
        entity: FCDFlaschard.entity(),
        sortDescriptors: []
    )
    private var flashcards: FetchedResults<FCDFlaschard>
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(flashcards) { flashcard in
                    FlashcardView(flashcard: flashcard)
                }
            }.padding()
        }.navigationBarTitle("Flashcards")
    }

}

struct FlashcardView: View {

    let flashcard: FCDFlaschard

    var body: some View {
        HStack {
            Text(firstWord(from: flashcard) + " - " + lastWord(from: flashcard))
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 80)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
    }

    private func firstWord(from flashcard: FCDFlaschard) -> String {
        (flashcard.words!.allObjects.first as! FCDWord).spelling!
    }

    private func lastWord(from flashcard: FCDFlaschard) -> String {
        (flashcard.words!.allObjects.last as! FCDWord).spelling!
    }
}

struct FlashcardsList_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardsList()
    }
}
