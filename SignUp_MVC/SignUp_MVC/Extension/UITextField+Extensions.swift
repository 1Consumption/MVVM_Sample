//
//  UITextField+Extensions.swift
//  SignUp_MVC
//
//  Created by Olaf on 2021/08/12.
//

import UIKit

extension UITextField {
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
