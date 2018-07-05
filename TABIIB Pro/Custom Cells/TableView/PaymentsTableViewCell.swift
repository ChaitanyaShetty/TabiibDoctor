//
//  PaymentsTableViewCell.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class PaymentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblOfPatientName : UILabel!
    @IBOutlet weak var lblOfPaymentType : UILabel!
    @IBOutlet weak var lblOfPaymentStatus : UILabel!
    @IBOutlet weak var lblOfPaidDate : UILabel!
    @IBOutlet weak var lblOfTransactionID : UILabel!
    @IBOutlet weak var lblOfAppointmentID : UILabel!
    @IBOutlet weak var lblOfAmount : UILabel!
    @IBOutlet weak var lblOfCurrency : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

