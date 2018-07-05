//
//  AddBankDetailsViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import MaterialTextField


class AddBankDetailsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfOfNameAsPassbook : MFTextField!
    @IBOutlet weak var tfOfBankName : MFTextField!
    @IBOutlet weak var tfOfBranch : MFTextField!
    @IBOutlet weak var tfOfAddress : MFTextField!
    @IBOutlet weak var tfOfAccountNumber : MFTextField!
    @IBOutlet weak var tfOfAccountType : MFTextField!
    @IBOutlet weak var tfOfCode : MFTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
         AllTextFieldDelegates()
        
        tfOfNameAsPassbook.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfOfBankName.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfOfBranch.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfOfAddress.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfOfAccountNumber.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfOfAccountType.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfOfCode.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnAction(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func validTxt(_ text : UITextField){
        
    
        if text == tfOfNameAsPassbook || text == tfOfBankName || text == tfOfBranch || text == tfOfAddress || text == tfOfAccountNumber || text == tfOfAccountType || text == tfOfCode {
            
            self.validateTextField1(text: text)
        }
        
    }
    
    func AllTextFieldDelegates(){
        tfOfNameAsPassbook.delegate = self
        tfOfBankName.delegate = self
        tfOfBranch.delegate = self
        tfOfAddress.delegate = self
        tfOfAccountNumber.delegate = self
        tfOfAccountType.delegate = self
        tfOfCode.delegate = self
    }
    
    
    func textField1IsValid() -> Bool {
        return (tfOfNameAsPassbook.text?.count)! > 0
    }
    
    func textField2IsValid() -> Bool {
        return (tfOfBankName.text?.count)! > 0
    }
    
    func textField3IsValid() -> Bool {
        return (tfOfBranch.text?.count)! > 0
    }
    
    func textField4IsValid() -> Bool {
        return (tfOfAddress.text?.count)! > 0
    }
    
    func textField5IsValid() -> Bool {
        return (tfOfAccountNumber.text?.count)! > 0
    }
    
    func textField6IsValid() -> Bool {
        return (tfOfAccountType.text?.count)! > 0
    }
    
    func textField7IsValid() -> Bool {
        return (tfOfCode.text?.count)! > 0
    }
    
    func error(withLocalizedDescription localizedDescription: String) -> Error? {
        let userInfo = [NSLocalizedDescriptionKey: localizedDescription]
        return NSError(domain: MFDemoErrorDomain as? String ?? "", code: Int(MFDemoErrorCode), userInfo: userInfo)
    }
    
    
    func validateTextField1(text : UITextField) {
        var error: Error? = nil
        
        if text == tfOfNameAsPassbook{
            if !textField1IsValid() {
                let err = NSLocalizedString("please enter name as passbook...", comment: "")
                error = self.error(withLocalizedDescription: err)
            }
            tfOfNameAsPassbook.setError(error, animated: true)
        }
        else if text == tfOfBankName{
            if !textField2IsValid() {
                let err = NSLocalizedString("please enter bank name...", comment: "")
                error = self.error(withLocalizedDescription: err)
            }
            tfOfBankName.setError(error, animated: true)
        }
        else  if text == tfOfBranch{
            if !textField1IsValid() {
                let err = NSLocalizedString("please enter branch name...", comment: "")
                error = self.error(withLocalizedDescription: err)
            }
            tfOfBranch.setError(error, animated: true)
        }
        else  if text == tfOfAddress{
            if !textField1IsValid() {
                let err = NSLocalizedString("please enter  address...", comment: "")
                error = self.error(withLocalizedDescription: err)
            }
            tfOfAddress.setError(error, animated: true)
        }
        else  if text == tfOfAccountNumber{
            if !textField1IsValid() {
                let err = NSLocalizedString("please enter account number...", comment: "")
                error = self.error(withLocalizedDescription: err)
            }
            tfOfAccountNumber.setError(error, animated: true)
        }
        else  if text == tfOfAccountType{
            if !textField1IsValid() {
                let err = NSLocalizedString("please enter account type...", comment: "")
                error = self.error(withLocalizedDescription: err)
            }
            tfOfAccountType.setError(error, animated: true)
        }
        else  if text == tfOfCode{
            if !textField1IsValid() {
                let err = NSLocalizedString("please enter code...", comment: "")
                error = self.error(withLocalizedDescription: err)
            }
            tfOfCode.setError(error, animated: true)
        }
       
    }
    
    func validateInputFields() -> Bool{
        
        var ifAllSuccess : Bool = true
        
        var error: Error? = nil
        
     //   let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ")
        
        let tfOfNameAsPass = self.tfOfNameAsPassbook.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfOfBankname = self.tfOfBankName.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfBranch = self.tfOfBranch.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfOfbankAddress = self.tfOfAddress.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfOfAccountNo = self.tfOfAccountNumber.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfOfAccounttype = self.tfOfAccountType.text?.trimmingCharacters(in: CharacterSet.whitespaces)
         let tfcode = self.tfOfCode.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if tfOfNameAsPass?.count == 0 {
    
            let err = NSLocalizedString("please enter name as passbook...", comment: "")
            error = self.error(withLocalizedDescription: err)
            tfOfNameAsPassbook.setError(error, animated: true)
            ifAllSuccess = false
            
        }
        else if tfOfBankname?.count == 0 {
            
            let err = NSLocalizedString("please enter bank name...", comment: "")
            error = self.error(withLocalizedDescription: err)
            tfOfBankName.setError(error, animated: true)
            ifAllSuccess = false
        }
        else if tfBranch?.count == 0 {
            
            let err = NSLocalizedString("please enter branch name...", comment: "")
            error = self.error(withLocalizedDescription: err)
            tfOfBranch.setError(error, animated: true)
            ifAllSuccess = false
        }
        else if tfOfbankAddress?.count == 0 {
            
            let err = NSLocalizedString("please enter address...", comment: "")
            error = self.error(withLocalizedDescription: err)
            tfOfAddress.setError(error, animated: true)
            ifAllSuccess = false
        }
        else if tfOfAccountNo?.count == 0 {
            
            let err = NSLocalizedString("please enter account number...", comment: "")
            error = self.error(withLocalizedDescription: err)
            tfOfAccountNumber.setError(error, animated: true)
            ifAllSuccess = false
        }
        else if tfOfAccounttype?.count == 0 {
            
            let err = NSLocalizedString("please enter account type...", comment: "")
            error = self.error(withLocalizedDescription: err)
            tfOfAccountType.setError(error, animated: true)
            ifAllSuccess = false
        }
        else if tfcode?.count == 0 {
            
            let err = NSLocalizedString("please enter code...", comment: "")
            error = self.error(withLocalizedDescription: err)
            tfOfCode.setError(error, animated: true)
            ifAllSuccess = false
        }
        
        
        
        return ifAllSuccess
        
    }
    
    func allTextFieldResignResp(){
        
        if tfOfNameAsPassbook.isFirstResponder{
            tfOfNameAsPassbook.resignFirstResponder()
        }else if tfOfBankName.isFirstResponder{
            tfOfBankName.resignFirstResponder()
        }else if tfOfBranch.isFirstResponder{
            tfOfBranch.resignFirstResponder()
        }else if tfOfAddress.isFirstResponder{
            tfOfAddress.resignFirstResponder()
        }else if tfOfAccountNumber.isFirstResponder{
            tfOfAccountNumber.resignFirstResponder()
        }else if tfOfAccountType.isFirstResponder{
            tfOfAccountType.resignFirstResponder()
        }else if tfOfCode.isFirstResponder{
            tfOfCode.resignFirstResponder()
        }
        
        
    }
    
    @IBAction func SaveBtnAction(_ sender : Any){
        
    //    let param : [String : Any] = ["":""]
        allTextFieldResignResp()
         if validateInputFields(){
       
        }
        
        
        
        
    }
    
    
    
}
