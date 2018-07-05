//
//  SwipeTableViewCell.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

protocol SwipeableCellDelegate {
    
    func btnAcceptClicked(_ cell: SwipeTableViewCell)
    func btnRejectClicked(_ cell: SwipeTableViewCell)
    func cellDidOpen(_ cell : SwipeTableViewCell)
    func cellDidClose(_ cell : SwipeTableViewCell)
}

class SwipeTableViewCell: UITableViewCell,SwipeableCellDelegate {
    
    func btnAcceptClicked(_ cell: SwipeTableViewCell) {
        
    }
    func btnRejectClicked(_ cell: SwipeTableViewCell) {
        
    }
    func cellDidOpen(_ cell: SwipeTableViewCell) {
        
    }
    func cellDidClose(_ cell: SwipeTableViewCell) {
        
    }
    
    
    @IBOutlet var lblofMonth: UILabel!
    @IBOutlet var lblofDate: UILabel!
    @IBOutlet var lblofDay: UILabel!
    @IBOutlet var lbloftime: UILabel!
    @IBOutlet var lblofPatientName: UILabel!
    @IBOutlet var lblofReason: UILabel!
    @IBOutlet var lblofFollowup: UILabel!
    @IBOutlet var lblofClinicName: UILabel!
    @IBOutlet var lblofRequestedDate: UILabel!
    @IBOutlet var imgofappointType: UIImageView!
    
    
    
    @IBOutlet var btnofAccept : UIButton!
    @IBOutlet var btnofReject : UIButton!
    @IBOutlet var viewofContent : UIView!
    
    
    
    @IBOutlet var contentViewRightconstraint : NSLayoutConstraint!
    @IBOutlet var contentViewLeftconstraint : NSLayoutConstraint!
    
    var pangRecognizer : UIPanGestureRecognizer!
    var panStartPoint : CGPoint!
    var startingRightLayoutConstraintConstant : CGFloat!
    
    let kBounceValue  : CGFloat = 20.0
    
    var delegate : SwipeableCellDelegate!
    
    var isEnglishLanguage : Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pangRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(pangestureApplied(_:)))
        pangRecognizer.delegate = self
        viewofContent.addGestureRecognizer(pangRecognizer)
        
        viewofContent.layer.cornerRadius = 6
        viewofContent.layer.masksToBounds = true
        viewofContent.clipsToBounds = true
        
        if UserDefaultStore.selectedLanguage == "0" {
            isEnglishLanguage = true
        }else{
            isEnglishLanguage = false
        }
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    func openCell() {
        setConstraintsToShowButtons(false, false)
    }
    
    @IBAction func actionBtnClicked(_ sender : UIButton){
        
        if sender == btnofAccept {
            if let delegateObj = self.delegate {
                delegateObj.btnAcceptClicked(self)
            }
        }else if sender == btnofReject {
            if let delegateObj = self.delegate {
                delegateObj.btnRejectClicked(self)
            }
        }
    }
    
    @objc func pangestureApplied(_ pangestureRecognizer : UIPanGestureRecognizer){
        
        switch pangestureRecognizer.state {
        case .began:
            panStartPoint = pangestureRecognizer.translation(in: viewofContent)
            startingRightLayoutConstraintConstant = contentViewRightconstraint.constant
            break
        case .changed :
            let currentPoint = pangestureRecognizer.translation(in: viewofContent)
            
            if isEnglishLanguage {
                let deltaX = currentPoint.x - self.panStartPoint.x
                var panningLeft = false
                if currentPoint.x < self.panStartPoint.x {
                    panningLeft = true
                }
                
                if self.startingRightLayoutConstraintConstant == 0 {
                    //this cell is closing ... now its opening newly
                    if !panningLeft {
                        let constant : CGFloat = max(-deltaX, 0)
                        if constant == 0 {
                            resetConstraintConsntantsToZero(true, false)
                        }else{
                            self.contentViewRightconstraint.constant = constant
                        }
                    }else{
                        let constant : CGFloat = min(-deltaX,buttonTotalWidth())
                        if constant == buttonTotalWidth() {
                            setConstraintsToShowButtons(true, false)
                        }else{
                            self.contentViewRightconstraint.constant = constant
                        }
                    }
                }
                else{
                    //this cell was at least partially open
                    
                    let adjustment = self.startingRightLayoutConstraintConstant - deltaX
                    
                    if !panningLeft {
                        let constant : CGFloat = max(adjustment,0)
                        if constant == 0 {
                            resetConstraintConsntantsToZero(true, false)
                        }else{
                            self.contentViewRightconstraint.constant = constant
                        }
                    }else{
                        let constant : CGFloat = min(adjustment,buttonTotalWidth())
                        if constant == buttonTotalWidth() {
                            setConstraintsToShowButtons(true, false)
                        }else{
                            self.contentViewRightconstraint.constant = constant
                        }
                    }
                }
            }
                //for arabic
                
            else{
                let deltaX = currentPoint.x + self.panStartPoint.x
                var panningLeft = false
                if currentPoint.x > self.panStartPoint.x {
                    panningLeft = true
                }
                
                if self.startingRightLayoutConstraintConstant == 0 {
                    //this cell is closing ... now its opening newly
                    
                    if !panningLeft {
                        let constant : CGFloat = max(+deltaX, 0)
                        if constant == 0 {
                            resetConstraintConsntantsToZero(true, false)
                        }else{
                            self.contentViewRightconstraint.constant = constant
                        }
                    }else{
                        let constant : CGFloat = min(+deltaX,buttonTotalWidth())
                        if constant == buttonTotalWidth() {
                            setConstraintsToShowButtons(true, false)
                        }else{
                            self.contentViewRightconstraint.constant = constant
                        }
                    }
                }
                else{
                    //this cell was at least partially open
                    
                    let adjustment = self.startingRightLayoutConstraintConstant + deltaX
                    
                    if !panningLeft {
                        let constant : CGFloat = max(adjustment,0)
                        if constant == 0 {
                            resetConstraintConsntantsToZero(true, false)
                        }else{
                            self.contentViewRightconstraint.constant = constant
                        }
                    }else{
                        let constant : CGFloat = min(adjustment,buttonTotalWidth())
                        if constant == buttonTotalWidth() {
                            setConstraintsToShowButtons(true, false)
                        }else{
                            self.contentViewRightconstraint.constant = constant
                        }
                    }
                }
            }
            
            
            break
        case .ended :
            
            if self.startingRightLayoutConstraintConstant == 0 {
                
                let halfButtonOpen : CGFloat = btnofAccept.frame.width
                
                if self.contentViewRightconstraint.constant >= halfButtonOpen {
                    setConstraintsToShowButtons(true, true)
                }else{
                    resetConstraintConsntantsToZero(true, true)
                }
            }else{
                let buttonOneplusHalfOfButton2 : CGFloat = btnofAccept.frame.width + ( btnofReject.frame.width / 2 )
                if self.contentViewRightconstraint.constant >= buttonOneplusHalfOfButton2 {
                    setConstraintsToShowButtons(true, true)
                }else{
                    resetConstraintConsntantsToZero(true, true)
                }
            }
            break
        case .cancelled :
            if self.startingRightLayoutConstraintConstant == 0{
                resetConstraintConsntantsToZero(true, true)
            }else{
                setConstraintsToShowButtons(true, true)
            }
            break
        default:
            break
        }
    }
    
    func updateConstraintsIfNeed(_ animated : Bool,completion : @escaping (_ finished : Bool) -> Void) {
        
        var duraion : Float = 0
        if animated {
            duraion = 0.1
        }
        
        UIView.animate(withDuration: TimeInterval(duraion), delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: completion)
        
    }
    
    func closeCell(){
        resetConstraintConsntantsToZero(true, true)
    }
    
    
    func resetConstraintConsntantsToZero(_ animated : Bool, _ notifyDelegate : Bool) {
        if notifyDelegate {
            if let delegateObj = self.delegate {
                delegateObj.cellDidClose(self)
            }
        }
        
        if self.startingRightLayoutConstraintConstant == 0 && self.contentViewRightconstraint.constant == 0 {
            return
        }
        
        self.contentViewRightconstraint.constant = -kBounceValue
        self.contentViewLeftconstraint.constant = kBounceValue
        
        updateConstraintsIfNeed(animated) { (finised) in
            self.contentViewRightconstraint.constant = 0
            self.contentViewLeftconstraint.constant = 0
            
            self.updateConstraintsIfNeed(animated, completion: { (finished) in
                self.startingRightLayoutConstraintConstant = self.contentViewRightconstraint.constant
            })
        }
        
        
    }
    
    func buttonTotalWidth() -> CGFloat {
        let selfWidth = self.frame.width - 30
        let buttonWidth = self.btnofAccept.frame.minX
        return selfWidth - buttonWidth
    }
    
    
    func setConstraintsToShowButtons(_ animated : Bool,_ notificationDelegate : Bool){
        if notificationDelegate{
            if let delegateObj = self.delegate {
                delegateObj.cellDidOpen(self)
            }
        }
        
        if self.startingRightLayoutConstraintConstant == buttonTotalWidth() && self.contentViewRightconstraint.constant == buttonTotalWidth() {
            return
        }
        
        if isEnglishLanguage {
            self.contentViewLeftconstraint.constant = buttonTotalWidth() - kBounceValue
        }else{
            self.contentViewLeftconstraint.constant = buttonTotalWidth() + kBounceValue
        }
        
        self.contentViewRightconstraint.constant = buttonTotalWidth() + kBounceValue
        
        
        updateConstraintsIfNeed(animated) { (finished) in
            
            if self.isEnglishLanguage {
                self.contentViewLeftconstraint.constant = -self.buttonTotalWidth()
                self.contentViewRightconstraint.constant = self.buttonTotalWidth()
            }else{
                self.contentViewLeftconstraint.constant = -self.btnofAccept.frame.width
                self.contentViewRightconstraint.constant = self.btnofAccept.frame.width
            }
            
            
            self.updateConstraintsIfNeed(animated, completion: { (finished) in
                
                self.startingRightLayoutConstraintConstant = self.contentViewRightconstraint.constant
            })
        }
        
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
