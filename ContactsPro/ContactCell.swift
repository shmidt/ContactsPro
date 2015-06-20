//
//  ContactCell.swift
//  ContactsPro
//
//  Created by Dmitry Shmidt on 16/02/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ContactCell: MGSwipeTableCell {
//    let imageSize:CGFloat = 48.0
    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var todoView: UIView!
    var name:NSAttributedString?{
        get {
            return nameLabel.attributedText
        }
        set {

            nameLabel.attributedText = newValue
            if let note = noteLabel.text{
            nameHeight.constant = note.isEmpty ? 3 : -6
            }else{
                nameHeight.constant = 3
            }
        }
    }
    
    var todo:Int{
        get {
            return 1
        }
        set {
            todoLabel.text = (newValue == 0) ? "" : "\(newValue)"
            todoView.hidden = (newValue == 0)
        }
    }
    
    var thumbImage:UIImage?{
        get {
            return thumbImageView.image
        }
        set {
            thumbImageView.image = newValue
            imageWidth.constant = (newValue != nil) ? CGFloat(40) : CGFloat(8)
        }
    }
    
//    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        imageView?.layer.masksToBounds = true
        imageView?.layer.cornerRadius = 20
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
