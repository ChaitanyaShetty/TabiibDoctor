//
//  AppDetActionsTableViewCell.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class AppDetActionsTableViewCell: UITableViewCell {
    
    
    //    @IBOutlet weak var checkInBtn : UIButton!
    //    @IBOutlet weak var checkOutBtn : UIButton!
    //    @IBOutlet weak var delayedBtn : UIButton!
    //    @IBOutlet weak var suggestionBtn : UIButton!
    //    @IBOutlet weak var DidnotArriveBtn : UIButton!
    //    @IBOutlet weak var callBtn : UIButton!
    //    @IBOutlet weak var cancelBtn : UIButton!
    
    @IBOutlet weak var actionCollectionView : UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
