//
//  ListOfClinicTableViewCell.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class ListOfClinicTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgOflistClinic : UIImageView!
    @IBOutlet weak var imgOfClinicAccept : UIImageView!
    
    @IBOutlet weak var lblOfClinicName : UILabel!
    @IBOutlet weak var lblOfClinicMobileNumber : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
