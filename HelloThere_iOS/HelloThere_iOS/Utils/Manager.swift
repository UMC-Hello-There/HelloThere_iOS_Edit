//
//  Manager.swift
//  HelloThere_iOS
//
//  Created by 우주대스타 on 2023-08-11.
//

import Foundation

final class Manager{
    func checkPasswordValidate (password:String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[A-Za-z\\d$@$!%*?&]{6,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
}
