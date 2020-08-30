//
//  LanguagesList.swift
//  Flashcards
//
//  Created by Krystian Paszek on 01/08/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import SwiftUI

struct LanguagesList: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: FCDLanguage.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var languages: FetchedResults<FCDLanguage>

    var body: some View {
        List(languages) { language in
            Text(language.name!)
        }.listStyle(GroupedListStyle())
    }
}

struct LanguagesList_Previews: PreviewProvider {
    static var previews: some View {
        LanguagesList()
    }
}
