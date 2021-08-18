//
//  SignUpViewModel.swift
//  SignUp_MVVM
//
//  Created by Olaf on 2021/08/12.
//

import Foundation
import Combine

final class SignUpViewModel {

    struct State {
        
        static var empty: Self {
            return Self(id: .empty, password: .empty, confirmPassword: .empty, validatedAll: false)
        }
        
        var id: TextState
        var password: TextState
        var confirmPassword: TextState
        var validatedAll: Bool
    }
    
    private let validator: Validator
    private(set) var state: CurrentValueSubject<State, Never> = .init(.empty)
    
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
        
        state.value.validatedAll = validator.validateAll()
    }
    
    private func idTextFieldChanged(_ text: String?) {
        state.value.id = validator.validate(text, type: .id)
    }
    
    private func passwordTextFieldChanged(_ text: String?) {
        state.value.password = validator.validate(text, type: .password)
    }
    
    private func confirmPasswordFieldChanged(_ text: String?) {
        state.value.confirmPassword = validator.validate(text, type: .confirmPassword)
    }
}
