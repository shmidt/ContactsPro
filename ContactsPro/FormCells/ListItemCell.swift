//
//  ListItemCell.swift
//  ContactsPro
//
//  Created by Dmitry Shmidt on 18/04/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.
//

import UIKit

class ListItemCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var textValue:String{
        get {
            return textField.text
        }
        set {
            textField.text = newValue
            
            //            textViewDidChange(textView)
        }
    }
    typealias ListItemTextCompletionHandler = (text:String) -> Void
    typealias ListItemCheckboxCompletionHandler = (completed:Bool) -> Void
    var completionHandler:ListItemTextCompletionHandler? = nil
    var checkboxCompletionHandler:ListItemCheckboxCompletionHandler? = nil
    func pickText(completion:ListItemTextCompletionHandler) {
        completionHandler = completion
    }
    func didTapCheckBox(completion:ListItemCheckboxCompletionHandler) {
        checkboxCompletionHandler = completion
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var checkBox: CheckBox!
    
    var isComplete: Bool = false {
        didSet {
            textField.enabled = !isComplete
            checkBox.isChecked = isComplete
            
            textField.textColor = isComplete ? UIColor.lightGrayColor() : UIColor.darkTextColor()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        textField.text = ""
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
    
    @IBAction func checkBoxTapped(sender: CheckBox) {
        if let c = checkboxCompletionHandler{
            c(completed: sender.isChecked)
        }

    }
}
