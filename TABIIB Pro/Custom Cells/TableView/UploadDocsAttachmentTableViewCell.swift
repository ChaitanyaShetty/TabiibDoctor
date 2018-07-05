//
//  UploadDocsAttachmentTableViewCell.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit


protocol DocumentUploadCellDelegate {
    
    func deleteDocClicked(_ cell : UploadDocsAttachmentTableViewCell)
    func viewDocClicked(_ cell : UploadDocsAttachmentTableViewCell)
    
}


class UploadDocsAttachmentTableViewCell: UITableViewCell,DocumentUploadCellDelegate {
    func deleteDocClicked(_ cell: UploadDocsAttachmentTableViewCell) {
        
    }
    
    func viewDocClicked(_ cell: UploadDocsAttachmentTableViewCell) {
        
    }
    
    @IBOutlet var imgofAttachment : UIImageView!
    @IBOutlet var lblofAttachmentTitle : UILabel!
    @IBOutlet var lblofSeparator : UILabel!
    
    @IBOutlet var btnofDeleteFile : UIButton!
    var delegate : DocumentUploadCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func btnDeleteClicked(_ sender : Any){
        if let delegateObj = self.delegate {
            delegateObj.deleteDocClicked(self)
        }
    }
    
    @IBAction func btnShowClicked(_ sender : Any) {
        if let delegateObj = self.delegate {
            delegateObj.viewDocClicked(self)
        }
    }
    
}
