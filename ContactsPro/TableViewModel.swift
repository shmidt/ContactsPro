//
//  TableViewModel.swift
//  ContactsPro
//
//  Created by Dmitry Shmidt on 09/04/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.
//

import Foundation
import UIKit

class CellValue1: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}

struct Constants {
    struct TableViewCell {
        static let DefaultCellID = "Cell"
        static let LabelTextTableViewCellID = "LabelTextTableViewCell"
        static let EditTextCellID = "EditTextTableViewCell"
        
        static let ButtonCellID = "ButtonTableViewCell"
        static let AddButtonCellID = "AddButtonTableViewCell"
        
        static let AddressCellID = "AddressTableViewCell"
        static let EditAddressCellID = "EditAddressTableViewCell"
        
        static let VehicleCellID = "VehicleTableViewCell"
        static let EditVehicleCellID = "EditVehicleTableViewCell"
        
        static let ConvictionCellID = "ConvictionTableViewCell"
        static let EditConvictionCellID = "EditConvictionTableViewCell"
        
        static let EditDateCellID = "EditDateTableViewCell"
        
        static let EditWeightCellID = "EditWeightTableViewCell"
        static let EditHeightCellID = "EditHeightTableViewCell"
        
        static let CheckedCellID = "CheckedTableViewCell"
        
        static let ListCellID = "ListPickerTableViewCell"
        
        static let EditLongTextCellID = "EditLongTextTableViewCell"
        
        static let EditNoteCellID = "EditNoteTableViewCell"
        
        static let ListItemCell = "ListItemCell"
    }
}

struct Section {
    static let WeakPoints = 0
    static let StrongPoints = 1
    static let Notes = 2
    static let ToDo = 3
    

}

let sectionNames = [
    NSLocalizedString("Weak Points", comment: ""),
    NSLocalizedString("Strong Points", comment: ""),
    NSLocalizedString("Notes", comment: ""),
    NSLocalizedString("To Do", comment: "")
]

