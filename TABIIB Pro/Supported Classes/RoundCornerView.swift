//
//  RoundCornerView.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import Foundation

class RoundCornerView: UIView {
    
    override func layoutSubviews() {
        
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = false
        //self.layer.borderWidth = 1
        self.layer.shadowColor = Constatns.CategoryShadowCColour().cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 2
        
    }
    
}

class CircularLabel: UILabel {
    
    override func layoutSubviews() {
        
        
        self.layer.borderColor = Constatns.ThemeColour().cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
    }
    
}


class BottomWhiteShadow: UIView {
    override func layoutSubviews() {
        
        self.layer.shadowColor = Constatns.CategoryShadowCColour().cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 6
        
        
        
    }
}

class BottomButtonWithOutWhiteShadow : UIView{
    override func layoutSubviews() {
        
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
    }
}
