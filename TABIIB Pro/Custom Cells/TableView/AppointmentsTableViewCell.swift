//
//  AppointmentsTableViewCell.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class AppointmentsTableViewCell: UITableViewCell {
    
    @IBOutlet var lblofMonth: UILabel!
    @IBOutlet var lblofDate: UILabel!
    @IBOutlet var lblofDay: UILabel!
    @IBOutlet var lbloftime: UILabel!
    @IBOutlet var lblofPatientName: UILabel!
    @IBOutlet var lblofReason: UILabel!
    @IBOutlet var lblofPaymentStatus: UILabel!
    
    @IBOutlet var lblofFollowup: UILabel!
    @IBOutlet var lblofClinicName: UILabel!
    @IBOutlet var lblofRequestedDate: UILabel!
    @IBOutlet var imgofappointType: UIImageView!
    
    @IBOutlet var viewOfCornerAndShadow : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
