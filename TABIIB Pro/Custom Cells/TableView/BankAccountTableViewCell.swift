//
//  BankAccountTableViewCell.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class BankAccountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblOfName : UILabel!
    @IBOutlet weak var lblOfBankName : UILabel!
    @IBOutlet weak var lblOfBranch : UILabel!
    @IBOutlet weak var lblOfAccountType : UILabel!
    @IBOutlet weak var lblOfAccountNumber : UILabel!
    @IBOutlet weak var lblOfAccountActivationDate : UILabel!
    
    @IBOutlet weak var lblOfPrimaryKey : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

