//
//  LabelTextTableViewCell.swift
//
//  Created by Dmitry Shmidt on 09/12/14.
//  Copyright (c) 2014 Dmitry Shmidt. All rights reserved.
//

import UIKit

class LabelTextTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
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
