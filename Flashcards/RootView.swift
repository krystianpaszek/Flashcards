//
//  RootView.swift
//  Flashcards
//
//  Created by Krystian Paszek on 31/07/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationView {
            LessonList()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
