//
//  CheckBoxCell.swift
//  ContactsPro
//
//  Created by Dmitry Shmidt on 18/04/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.
//

import UIKit

class CheckBoxCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var checkBox: CheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    var isComplete: Bool = false {
//        didSet {
//            textField.enabled = !isComplete
//            checkBox.isChecked = isComplete
//            
//            textField.textColor = isComplete ? UIColor.lightGrayColor() : UIColor.darkTextColor()
//        }
//    }
}
