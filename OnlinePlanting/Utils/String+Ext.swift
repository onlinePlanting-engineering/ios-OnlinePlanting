//
//  String+Ext.swift
//  OnlinePlanting
//
//  Created by ___Alex___ on 4/30/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation

enum ValidatedType {
    case Email
    case PhoneNumber
}

extension String {
    
    func ValidateText(validatedType type: ValidatedType, validateString: String) -> Bool {
        do {
            let pattern: String
            if type == ValidatedType.Email {
                pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            }
            else {
                pattern = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
            }
            
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: validateString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, validateString.characters.count))
            return matches.count > 0
        }
        catch {
            return false
        }
    }
    
    func EmailIsValidated() -> Bool {
        return ValidateText(validatedType: ValidatedType.Email, validateString: self)
    }
    
    func PhoneNumberIsValidated() -> Bool {
        return ValidateText(validatedType: ValidatedType.PhoneNumber, validateString: self)
    }
}
