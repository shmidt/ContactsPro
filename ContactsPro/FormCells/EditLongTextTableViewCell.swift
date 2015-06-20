//
//  LongTextTableViewCell.swift
//
//  Created by Dmitry Shmidt on 25/12/14.
//  Copyright (c) 2014 Dmitry Shmidt. All rights reserved.
//
import UIKit

class EditLongTextTableViewCell: UITableViewCell {
    typealias PickLongTextCompletionHandler = (longText:String) -> Void
    var completionHandler:PickLongTextCompletionHandler? = nil
    func pick(completion:PickLongTextCompletionHandler) {
        completionHandler = completion
    }
    
    var label:String{
        get {
            return labelLabel.text!
        }
        set{
            labelLabel.text = newValue
        }
    }
    /// Custom setter so we can initialise the height of the text view
    var longText:String{
        get {
            return textView.text
        }
        set {
            textView.text = newValue
            
            textViewDidChange(textView)
        }
    }
    @IBOutlet weak var labelLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Disable scrolling inside the text view so we enlarge to fitted size
        textView.scrollEnabled = false
        textView.delegate = self
        
        textView.textContainer.widthTracksTextView = true
        
        textView.textContainerInset = UIEdgeInsetsZero
        textView.textContainer.lineFragmentPadding = 0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            textView.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        let text = textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if let c = completionHandler{
            c(longText:text)
        }
    }
}

extension EditLongTextTableViewCell: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        
        var bounds = textView.bounds
        
        let maxSize = CGSize(width: bounds.size.width, height: CGFloat(MAXFLOAT))
        var newSize = textView.sizeThatFits(maxSize)
        
        // Minimum size is 50
        newSize.height = max(50.0, newSize.height)
        
        bounds.size = newSize
        textView.bounds = bounds
        
        // Only way found to make table view update layout of cell
        // More efficient way?
        if let tableView = tableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}

//extension EditLongTextTableViewCell: UITextViewDelegate {
//    func textViewDidChange(textView: UITextView) {
//        
//        let size = textView.bounds.size
//        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.max))
//        
//        // Resize the cell only when cell's size is changed
//        if size.height != newSize.height {
//            UIView.setAnimationsEnabled(false)
//            tableView?.beginUpdates()
//            tableView?.endUpdates()
//            UIView.setAnimationsEnabled(true)
//            
//            if let thisIndexPath = tableView?.indexPathForCell(self) {
//                tableView?.scrollToRowAtIndexPath(thisIndexPath, atScrollPosition: .Bottom, animated: false)
//            }
//        }
//    }
//}
