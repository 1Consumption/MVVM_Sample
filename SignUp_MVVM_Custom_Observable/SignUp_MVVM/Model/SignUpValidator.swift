//
//  SignUpValidator.swift
//  SignUp_MVVM
//
//  Created by Olaf on 2021/08/12.
//

import Foundation

protocol Validator {

    var passwordStorage: Storage { get }
    func validate(_ text: String?, type: ValidationType) -> TextState
    func validateAll() -> Bool
}

enum TextState {
    
    case empty
    case valid
    case invalid
}

enum ValidationType {
    
    case id
    case password
    case confirmPassword
}

final class SignUpValidator: Validator {
    
    private(set) var passwordStorage: Storage
    
    private var isIDValidated: Bool = false
    private var isPasswordValidated: Bool = false
    private var isConfirmPasswordValidated: Bool = false
    
    init(storage: Storage = PasswordStorage()) {
        self.passwordStorage = storage
    }
    
    func validate(_ text: String?, type: ValidationType) -> TextState {
        guard let text = text,
              text.isEmpty == false else {
            return .empty
        }
        
        switch type {
        case .id:
            return validateID(text)
        
        case .password:
            return validatePassword(text)
            
        case .confirmPassword:
            return validateConfirmPassword(text)
        }
    }
    
    func validateAll() -> Bool {
        return isIDValidated && isPasswordValidated && isConfirmPasswordValidated
    }
    
    private func validateID(_ id: String) -> TextState {
        isIDValidated = validateLength(id) && validateWhiteSpace(id)
        return isIDValidated ? .valid : .invalid
    }
    
    private func validatePassword(_ password: String) -> TextState {
        passwordStorage.password = password
        isPasswordValidated = validateLength(password)
        return isPasswordValidated ? .valid : .invalid
    }
    
    private func validateConfirmPassword(_ confirmPassword: String) -> TextState {
        passwordStorage.confirmPassword = confirmPassword
        isConfirmPasswordValidated = passwordStorage.isEqualOriginPassword && validateLength(confirmPassword)
        return isConfirmPasswordValidated ? .valid : .invalid
    }
    
    private func validateLength(_ text: String) -> Bool {
        return (6..<12) ~= text.count
    }
    
    private func validateWhiteSpace(_ text: String) -> Bool {
        return text.contains(" ") == false
    }
}
