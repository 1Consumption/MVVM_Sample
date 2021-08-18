//
//  SignUpValidator.swift
//  SignUp_MVC
//
//  Created by Olaf on 2021/08/12.
//

import Foundation

enum ValidationType {
    case id
    case password
    case confirmPassword
}

protocol Validator {

    var passwordStorage: Storage { get }
    func validate(_ text: String?, type: ValidationType) -> Bool
    func validateButton() -> Bool
}

final class SignUpValidator: Validator {
    
    private(set) var passwordStorage: Storage
    
    private var isIDValidation: Bool = false
    private var isPasswordValidation: Bool = false
    private var isConfirmPasswordValidation: Bool = false
    
    init(storage: Storage = PasswordStorage()) {
        self.passwordStorage = storage
    }
    
    func validate(_ text: String?, type: ValidationType) -> Bool {
        guard let text = text else {
            return false
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
    
    func validateButton() -> Bool {
        return isIDValidation && isPasswordValidation && isConfirmPasswordValidation
    }
    
    private func validateID(_ id: String) -> Bool {
        isIDValidation = validateLength(id) && validateWhiteSpace(id)
        return isIDValidation
    }
    
    private func validatePassword(_ password: String) -> Bool {
        passwordStorage.password = password
        isPasswordValidation = validateLength(password)
        return isPasswordValidation
    }
    
    private func validateConfirmPassword(_ confirmPassword: String) -> Bool {
        passwordStorage.confirmPassword = confirmPassword
        isConfirmPasswordValidation = passwordStorage.isEqualOriginPassword && validateLength(confirmPassword)
        return isConfirmPasswordValidation
    }
    
    private func validateLength(_ text: String) -> Bool {
        return (6..<12) ~= text.count
    }
    
    private func validateWhiteSpace(_ text: String) -> Bool {
        return text.contains(" ") == false
    }
}
