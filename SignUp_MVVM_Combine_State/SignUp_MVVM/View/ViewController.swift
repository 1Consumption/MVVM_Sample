//
//  SignUpViewController.swift
//  SignUp_MVVM
//
//  Created by Olaf on 2021/08/12.
//

import UIKit
import Combine

class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    
    private let viewModel: SignUpViewModel = .init(validator: SignUpValidator())
    private var bag: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviewsAppearance()
        setUpBinding()
    }
    
    private func setUpBinding() {
        viewModel.state
            .map(\.id)
            .removeDuplicates()
            .map { [weak self] in self?.appropriatedColor(with: $0) }
            .assign(to: \.layer.borderColor, on: idTextField)
            .store(in: &bag)
        
        viewModel.state
            .map(\.password)
            .removeDuplicates()
            .map { [weak self] in self?.appropriatedColor(with: $0) }
            .assign(to: \.layer.borderColor, on: passwordTextField)
            .store(in: &bag)
        
        viewModel.state
            .map(\.confirmPassword)
            .removeDuplicates()
            .map { [weak self] in self?.appropriatedColor(with: $0) }
            .assign(to: \.layer.borderColor, on: confirmPasswordTextField)
            .store(in: &bag)
        
        viewModel.state
            .map(\.validatedAll)
            .removeDuplicates()
            .assign(to: \.isEnabled, on: signUpButton)
            .store(in: &bag)
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
    
    private func appropriatedColor(with textState: TextState) -> CGColor {
        switch textState {
        case .empty:
            return Style.TextField.BorderColor.empty
            
        case .valid:
            return Style.TextField.BorderColor.valid
            
        case .invalid:
            return Style.TextField.BorderColor.invalid
        }
    }
    
    @IBAction private func editIDTextField(_ sender: UITextField) {
        viewModel.textFieldChanged(sender.text, type: .id)
    }
    
    @IBAction private func editPasswordTextField(_ sender: UITextField) {
        viewModel.textFieldChanged(sender.text, type: .password)
    }
    
    @IBAction private func editConfirmPasswordTextField(_ sender: UITextField) {
        viewModel.textFieldChanged(sender.text, type: .confirmPassword)
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
