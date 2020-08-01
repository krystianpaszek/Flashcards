//
//  RootView.swift
//  Flashcards
//
//  Created by Krystian Paszek on 31/07/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection) {
            LanguagesList()
                .tabItem {
                    VStack {
                        Image(systemName: "globe")
                        Text("Languages")
                    }
                }
                .tag(0)
            CategoriesList()
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Categories")
                    }
                }
                .tag(1)
            WordsList()
                .tabItem {
                    VStack {
                        Image(systemName: "book")
                        Text("Words")
                    }
                }
                .tag(2)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
