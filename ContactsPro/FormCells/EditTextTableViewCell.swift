//
//  TextFieldTableViewCell.swift
//
//  Created by Dmitry Shmidt on 07/12/14.
//  Copyright (c) 2014 Dmitry Shmidt. All rights reserved.
//

import UIKit

class EditTextTableViewCell: UITableViewCell, UITextFieldDelegate {

    var label:String{
        get {
            return textField.placeholder!
        }
        set{
            textField.placeholder = label
        }
    }
    var textValue:String{
        get {
            return textField.text
        }
        set {
            textField.text = newValue
            textFieldDidEndEditing(textField)
//            textViewDidChange(textView)
        }
    }
    @IBOutlet weak var textField: UITextField!
    
    typealias EditTextCompletionHandler = (text:String) -> Void
    var completionHandler:EditTextCompletionHandler? = nil
    func pickText(completion:EditTextCompletionHandler) {
        completionHandler = completion
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.text = ""
//        if let c = completionHandler{
//            c(text: textField.text)
//        }
        
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if let c = completionHandler{
            c(text: textField.text)
        }
    }
}
