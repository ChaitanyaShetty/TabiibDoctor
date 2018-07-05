//
//  AppDetHospitalTableViewCell.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class AppDetHospitalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblOfClinicName : UILabel!
    @IBOutlet weak var lblOfVisitReason : UILabel!
    @IBOutlet weak var lblOfRequestedDate : UILabel!
    @IBOutlet weak var lblOfRequestedTime : UILabel!
    @IBOutlet weak var lblOfAppointDate : UILabel!
    @IBOutlet weak var lblOfAppointTime : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

