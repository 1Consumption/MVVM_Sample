//
//  PasswordSotrage.swift
//  SignUp_MVC
//
//  Created by Olaf on 2021/08/12.
//

import Foundation

protocol Storage {
    
    var password: String? { get set }
    var confirmPassword: String? { get set }
    var isEqualOriginPassword: Bool { get }
}

struct PasswordStorage: Storage {
    
    var password: String?
    var confirmPassword: String?
    var isEqualOriginPassword: Bool {
        return password == confirmPassword
    }
}
