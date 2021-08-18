//
//  SignUpViewModel.swift
//  SignUp_MVVM
//
//  Created by Olaf on 2021/08/12.
//

import Foundation
import Combine

final class SignUpViewModel {
    
    private let validator: Validator
    
    private(set) var id: PassthroughSubject<TextState, Never> = .init()
    private(set) var password: PassthroughSubject<TextState, Never> = .init()
    private(set) var confirmPassword: PassthroughSubject<TextState, Never> = .init()
    private(set) var validatedAll: PassthroughSubject<Bool, Never> = .init()
    
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
        
        validatedAll.send(validator.validateAll())
    }
    
    private func idTextFieldChanged(_ text: String?) {
        id.send(validator.validate(text, type: .id))
    }
    
    private func passwordTextFieldChanged(_ text: String?) {
        password.send(validator.validate(text, type: .password))
    }
    
    private func confirmPasswordFieldChanged(_ text: String?) {
        confirmPassword.send(validator.validate(text, type: .confirmPassword))
    }
}
