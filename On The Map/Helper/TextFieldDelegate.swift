//
//  TextViewDelegate.swift
//  On The Map
//
//  Created by mitul jindal on 15/09/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if(string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}
