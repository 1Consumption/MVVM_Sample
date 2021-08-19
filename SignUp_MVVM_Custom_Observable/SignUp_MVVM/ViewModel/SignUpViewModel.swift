//
//  SignUpViewModel.swift
//  SignUp_MVVM
//
//  Created by Olaf on 2021/08/12.
//

import Foundation

final class SignUpViewModel {
    
    private let validator: Validator
    
    private(set) var id: Observable<TextState> = .init(value: .empty)
    private(set) var password: Observable<TextState> = .init(value: .empty)
    private(set) var confirmPassword: Observable<TextState> = .init(value: .empty)
    private(set) var validatedAll: Observable<Bool> = .init(value: false)
    
    private var idHandler: ((TextState) -> Void)?
    private var passwordHandler: ((TextState) -> Void)?
    private var confirmPasswordHandler: ((TextState) -> Void)?
    private var validatedAllHandler: ((Bool) -> Void)?
    
    init(validator: Validator) {
        self.validator = validator
    }
    
    func textFieldChanged(_ text: String?, type: ValidationType) {
        switch type {
        case .id:
            idTextFieldChanged(text)
            
        case .password:
            passwordTextFieldChanged(text)
            
        case .confirmPassword:
            confirmPasswordFieldChanged(text)
        }
        
        validatedAll.value = validator.validateAll()
    }
    
    private func idTextFieldChanged(_ text: String?) {
        id.value = validator.validate(text, type: .id)
    }
    
    private func passwordTextFieldChanged(_ text: String?) {
        password.value = validator.validate(text, type: .password)
    }
    
    private func confirmPasswordFieldChanged(_ text: String?) {
        confirmPassword.value = validator.validate(text, type: .confirmPassword)
    }
}

final class Observable<Element> {
    
    var value: Element {
        didSet {
            handler?(value)
        }
    }
    
    private var handler: ((Element) -> Void)?
    
    init(value: Element) {
        self.value = value
    }
    
    func bind(_ handler: @escaping (Element) -> Void) {
        self.handler = handler
    }
}
