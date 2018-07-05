//
//  AppDetProfileTableViewCell.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class AppDetProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblOfPatientName : UILabel!
    @IBOutlet weak var lblOfAge : UILabel!
    @IBOutlet weak var lblOfMobileNumber : UILabel!
    @IBOutlet weak var lblOfBookedFor : UILabel!
    @IBOutlet weak var lblOfBFPatientName : UILabel!
    @IBOutlet weak var lblOfBFAge : UILabel!
    @IBOutlet weak var lblOfBFMobileNumber : UILabel!
    @IBOutlet weak var viewofPateintDetails : UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

