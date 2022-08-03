//
//  Validation.swift
//  Expensify
//
//  Created by user207261 on 7/30/22.
//

import UIKit

class Validation: NSObject {
    
    static func isvalidEmail(input : String) -> Bool
    {
        let emailRegx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let email = NSPredicate(format: "SELF MATCHES %@", emailRegx)
        return email.evaluate(with: input)
    }

    
    static func isvalidPassword(input : String) -> Bool
    {
        let pwdRegx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let pwd = NSPredicate(format: "SELF MATCHES %@", pwdRegx)
        return pwd.evaluate(with: input)
    }
    
}
