//
//  AppDetPaymentTableViewCell.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class AppDetPaymentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblOfMode : UILabel!
    @IBOutlet weak var lblOfAmountPaid : UILabel!
    @IBOutlet weak var lblOfTransactionID : UILabel!
    @IBOutlet weak var lblOfPaidDate : UILabel!
    @IBOutlet weak var lblOfPending : UILabel!
    @IBOutlet weak var lblOfPendingAmount : UILabel!
    @IBOutlet weak var lblOfpaidDateIfPending : UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

