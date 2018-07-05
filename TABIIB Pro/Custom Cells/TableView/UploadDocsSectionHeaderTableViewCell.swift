//
//  UploadDocsSectionHeaderTableViewCell.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class UploadDocsSectionHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet var imgofSelection : UIImageView!
    @IBOutlet var lblofTitle1 : UILabel!
    @IBOutlet var lblofTitle2 : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

