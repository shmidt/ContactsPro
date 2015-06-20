//
//  TextTableViewCell.swift
//  PoliceNetwork
//
//  Created by Dmitry Shmidt on 10/01/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    var textValue:String!{
        didSet{
            valueTextLabel.text = textValue
        }
    }
    @IBOutlet weak var valueTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
