//
//  LessonView.swift
//  Flashcards
//
//  Created by Krystian Paszek on 01/09/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import SwiftUI

struct DirectionalFlashcard {
    let spelling: String
    let translation: String
}

struct LessonView: View {

    @Environment(\.presentationMode) var presentation
    @ObservedObject var model: LessonViewModel
    @State private var originalSpelling: String = ""
    @State private var translation: String = ""

    @State private var isShowingErrorModal: Bool = false
    @State private var isShowingFinishModal: Bool = false
    @State private var isTranslationTextFieldFocused: Bool? = false

    @State private var translationFieldBackgroundColor: Color? = nil

    var body: some View {
        ZStack(alignment: .top) {
            Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            VStack {
                List {
                    Section(
                        header: Text("REMAINING - \(model.remainingWordsCount)"),
                        footer: Text("ERRORS - \(model.errorsCount)")
                    ) {
                        TextField(model.currentWord, text: $originalSpelling).disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        FocusableTextField(
                            text: $translation,
                            nextResponder: .constant(nil),
                            isResponder: $isTranslationTextFieldFocused,
                            keyboard: .default,
                            onReturn: {
                                checkWord()
                            }
                        )
                        .listRowBackground(
                            translationFieldBackgroundColor
                                .animation(.linear)
                        )
                    }
                    Section() {
                        HStack(alignment: .center) {
                            Spacer()
                            Button("Check") {
                                checkWord()
                            }
                            .alert(isPresented: $isShowingErrorModal, content: {
                                Alert(
                                    title: Text("Erorr! Correct translation:"),
                                    message: Text(model.currentTranslation),
                                    dismissButton: Alert.Button.cancel() {
                                        proceedToNextWordOrFinish()
                                    }
                                )
                            })
                            Spacer()
                        }
                    }
                }
                .frame(height: 300)

            }
        }
        .listStyle(GroupedListStyle())
        .onAppear {
            isTranslationTextFieldFocused = true
        }
        .alert(isPresented: $isShowingFinishModal, content: {
            Alert(
                title: Text("Finished"),
                message: Text("Congratulations"),
                dismissButton: Alert.Button.default(Text("Done")) {
                    presentation.wrappedValue.dismiss()
                }
            )
        })
    }

    private func checkWord() {
        let color: Color = model.submit(translation: translation) ? .green : .red
        isTranslationTextFieldFocused = false

        // only set after checking if translation is correct!
        translation = model.currentTranslation

        flashTranslationTextField(with: color, completion: {
            proceedToNextWordOrFinish()
        })
    }

    private func proceedToNextWordOrFinish() {
        translation = ""
        if !model.nextWord() {
            isShowingFinishModal = true
        }
    }

    private func flashTranslationTextField(with color: Color, completion: (() -> Void)? = nil) {
        translationFieldBackgroundColor = color

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            translationFieldBackgroundColor = .clear
            completion?()
        }
    }
}

//struct LessonView_Previews: PreviewProvider {
//    static var previews: some View {
//        let model = MockLessonViewModel(
//            remainingWordsCount: 20,
//            errorsCount: 3,
//            currentWord: "versuchen"
//        )
//        LessonView(model: model)
//    }
//}
