//
//  SignUpViewModel.swift
//  SignUp_MVVM
//
//  Created by Olaf on 2021/08/12.
//

import Foundation

final class SignUpViewModel {
    
    private let validator: Validator
    
    private var id: TextState = .empty {
        willSet {
            idHandler?(newValue)
        }
    }
    private var password: TextState = .empty {
        willSet {
            passwordHandler?(newValue)
        }
    }
    private var confirmPassword: TextState = .empty {
        willSet {
            confirmPasswordHandler?(newValue)
        }
    }
    private var validatedAll: Bool = false {
        willSet {
            validatedAllHandler?(newValue)
        }
    }
    
    private var idHandler: ((TextState) -> Void)?
    private var passwordHandler: ((TextState) -> Void)?
    private var confirmPasswordHandler: ((TextState) -> Void)?
    private var validatedAllHandler: ((Bool) -> Void)?
    
    init(validator: Validator) {
        self.validator = validator
    }
    
    func bindID(handler: @escaping (TextState) -> Void) {
        self.idHandler = handler
    }
    
    func bindPassword(handler: @escaping (TextState) -> Void) {
        self.passwordHandler = handler
    }
    
    func bindConfirmPassword(handler: @escaping (TextState) -> Void) {
        self.confirmPasswordHandler = handler
    }
    
    func bindValidateAll(handler: @escaping (Bool) -> Void) {
        self.validatedAllHandler = handler
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
        
        validatedAll = validator.validateAll()
    }
    
    private func idTextFieldChanged(_ text: String?) {
        id = validator.validate(text, type: .id)
    }
    
    private func passwordTextFieldChanged(_ text: String?) {
        password = validator.validate(text, type: .password)
    }
    
    private func confirmPasswordFieldChanged(_ text: String?) {
        confirmPassword = validator.validate(text, type: .confirmPassword)
    }
}
