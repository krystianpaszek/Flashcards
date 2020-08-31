//
//  HomescreenView.swift
//  Flashcards
//
//  Created by Krystian Paszek on 01/08/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import SwiftUI

struct HomescreenView: View {

    @FetchRequest(entity: FCDCategory.entity(), sortDescriptors: []) var categories: FetchedResults<FCDCategory>

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("")) {
                    ForEach(categories) { category in
                        NavigationLink(destination: FlashcardsList(categoryName: category.name!)) {
                            Text(category.name!)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Select category")
        }
    }
}

struct HomescreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomescreenView()
    }
}
