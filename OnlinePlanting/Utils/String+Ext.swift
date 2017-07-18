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
    
    func pbkdf2SHA256(password: String, salt: Data, keyByteCount: Int, rounds: Int) -> Data? {
        
        func pbkdf2(hash :CCPBKDFAlgorithm, password: String, salt: Data, keyByteCount: Int, rounds: Int) -> Data? {
            let passwordData = password.data(using:String.Encoding.utf8)!
            var derivedKeyData = Data(repeating:0, count:keyByteCount)
            
            let derivationStatus = derivedKeyData.withUnsafeMutableBytes {derivedKeyBytes in
                salt.withUnsafeBytes { saltBytes in
                    
                    CCKeyDerivationPBKDF(
                        CCPBKDFAlgorithm(kCCPBKDF2),
                        password, passwordData.count,
                        saltBytes, salt.count,
                        hash,
                        UInt32(rounds),
                        derivedKeyBytes, derivedKeyData.count)
                }
            }
            if (derivationStatus != 0) {
                print("Error: \(derivationStatus)")
                return nil
            }
            
            return derivedKeyData
        }
        
        return pbkdf2(hash:CCPBKDFAlgorithm(kCCPRFHmacAlgSHA256), password:password, salt:salt, keyByteCount:keyByteCount, rounds:rounds)
    }
    
    var pinyin: String {
        let str = NSMutableString(string: self)
        CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)
        return str.capitalized
    }
}
