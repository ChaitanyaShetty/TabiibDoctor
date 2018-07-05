//
//  LangSeleTableViewCell.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class LangSeleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblofLang : UILabel!
    @IBOutlet weak var imgOflang : UIImageView!
    
    @IBOutlet weak var lblOfLine : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
