//
//  AppDetHistoryTableViewCell.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class AppDetHistoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblOfConsultedDate : UILabel!
    @IBOutlet weak var lblOfConsultedTime : UILabel!
    @IBOutlet weak var lblOfVisitReason : UILabel!
    @IBOutlet weak var lblOfDrSuggestion : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
