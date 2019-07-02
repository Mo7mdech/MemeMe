//
//  TextFieldDelegate.swift
//  MemeMe
//
//  Created by Mohammed Jarad on 27/03/2019.
//  Copyright © 2019 Jarad. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    var isUsingBottomDefaultText:Bool = true
    var isUsingTopDefaultText:Bool = true
    
    func returnToDefault(){
        isUsingBottomDefaultText = true
        isUsingTopDefaultText = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isUsingTopDefaultText{
            if textField.text == "TOP"{
                textField.text = ""
                isUsingTopDefaultText = false
            }
        }
        if isUsingBottomDefaultText{
            if textField.text == "BOTTOM"{
                textField.text = ""
                isUsingBottomDefaultText = false
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}
