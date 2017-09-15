//
//  TextViewDelegate.swift
//  On The Map
//
//  Created by mitul jindal on 15/09/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit

class TextViewDelegate: NSObject, UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter the location" {
            textView.text = nil
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Enter the location" {
            textView.text = nil
        }
        return true
    }
        
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        if textView.text.isEmpty {
            textView.text = "Enter the location"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
