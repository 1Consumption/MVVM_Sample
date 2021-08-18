//
//  SignUpViewController.swift
//  SignUp_MVC
//
//  Created by Olaf on 2021/08/12.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    
    private let validator: Validator = SignUpValidator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviewsAppearance()
    }
    
    private func setUpSubviewsAppearance() {
        setUpSignUpButtonAppearance()
        setUpTextFieldsAppearance()
    }
    
    private func setUpSignUpButtonAppearance() {
        signUpButton?.clipsToBounds = true
        signUpButton?.layer.cornerRadius = Style.SignUpButton.cornerRadius
        signUpButton?.setBackgroundColor(.systemGray, for: .disabled)
        signUpButton?.isEnabled = false
    }
    
    private func setUpTextFieldsAppearance() {
        setUpTextFieldAppearance(idTextField)
        setUpTextFieldAppearance(passwordTextField)
        setUpTextFieldAppearance(confirmPasswordTextField)
    }
    
    private func setUpTextFieldAppearance(_ textField: UITextField?) {
        textField?.layer.borderColor = Style.TextField.BorderColor.empty
        textField?.layer.borderWidth = Style.TextField.borderWidth
        textField?.layer.cornerRadius = Style.TextField.cornerRadius
        textField?.addLeftPadding()
        textField?.textContentType = .oneTimeCode
    }
    
    @IBAction private func editIDTextField(_ sender: UITextField) {
        let isIdValidated = validator.validate(sender.text, type: .id)
        
        idTextField.layer.borderColor = isIdValidated ? Style.TextField.BorderColor.valid : Style.TextField.BorderColor.invalid
        signUpButton.isEnabled = validator.validateButton()
    }
    
    @IBAction private func editPasswordTextField(_ sender: UITextField) {
        let isPasswordValidated = validator.validate(sender.text, type: .password)
        sender.layer.borderColor = isPasswordValidated ? Style.TextField.BorderColor.valid : Style.TextField.BorderColor.invalid
        
        if validator.passwordStorage.confirmPassword?.isEmpty == false {
            let isConfirmPasswordValidated  = validator.validate(validator.passwordStorage.confirmPassword, type: .confirmPassword)
            confirmPasswordTextField.layer.borderColor = isConfirmPasswordValidated ? Style.TextField.BorderColor.valid : Style.TextField.BorderColor.invalid
        }
        
        signUpButton?.isEnabled = validator.validateButton()
    }
    
    @IBAction private func editConfirmPasswordTextField(_ sender: UITextField) {
        let isConfirmPasswordValidated  = validator.validate(sender.text, type: .confirmPassword)
        
        confirmPasswordTextField.layer.borderColor = isConfirmPasswordValidated ? Style.TextField.BorderColor.valid : Style.TextField.BorderColor.invalid
        
        signUpButton?.isEnabled = validator.validateButton()
    }
}

// MARK: - Style
extension SignUpViewController {
    
    private enum Style {
        
        enum SignUpButton {
            
            static let cornerRadius: CGFloat = 5
        }
        
        enum TextField {
            
            enum BorderColor {
                static let empty: CGColor = UIColor.systemGray.cgColor
                static let valid: CGColor = UIColor.green.cgColor
                static let invalid: CGColor = UIColor.red.cgColor
            }
            static let cornerRadius: CGFloat = 5
            static let borderWidth: CGFloat = 1
        }
    }
}
