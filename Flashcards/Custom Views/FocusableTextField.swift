//
//  FocusableTextField.swift
//  Flashcards
//
//  Created by Krystian Paszek on 01/09/2020.
//  Copyright © 2020 Krystian Paszek. All rights reserved.
//

import SwiftUI

struct FocusableTextField: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        @Binding var nextResponder : Bool?
        @Binding var isResponder : Bool?

        var onReturn: (() -> Void)?

        init(text: Binding<String>,nextResponder : Binding<Bool?> , isResponder : Binding<Bool?>, onReturn: (() -> Void)? = nil) {
            _text = text
            _isResponder = isResponder
            _nextResponder = nextResponder

            self.onReturn = onReturn
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isResponder = true
            }
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isResponder = false
                if self.nextResponder != nil {
                    self.nextResponder = true
                }
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            onReturn?()
            return true
        }
    }

    @Binding var text: String
    @Binding var nextResponder : Bool?
    @Binding var isResponder : Bool?

    var keyboard : UIKeyboardType
    var onReturn: (() -> Void)? = nil

    func makeUIView(context: UIViewRepresentableContext<FocusableTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = keyboard
        textField.delegate = context.coordinator
        return textField
    }

    func makeCoordinator() -> FocusableTextField.Coordinator {
        return Coordinator(
            text: $text,
            nextResponder: $nextResponder,
            isResponder: $isResponder,
            onReturn: onReturn
        )
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<FocusableTextField>) {
        uiView.text = text
        if isResponder ?? false {
            uiView.becomeFirstResponder()
        }
    }

}
