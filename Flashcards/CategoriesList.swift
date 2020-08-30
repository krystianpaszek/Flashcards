//
//  CategoriesList.swift
//  Flashcards
//
//  Created by Krystian Paszek on 31/07/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import SwiftUI

struct CategoriesList: View {

    @FetchRequest(entity: FCDCategory.entity(), sortDescriptors: []) var categories: FetchedResults<FCDCategory>

    var body: some View {
        List(categories) { category in
            Section(header: Text("")) {
                NavigationLink(destination: FlashcardsList(categoryName: category.name!)) {
                    Text(category.name!)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Categories")
    }

}

struct CategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesList()
    }
}
