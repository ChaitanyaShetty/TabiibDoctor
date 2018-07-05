//
//  ChangePasswordViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import MaterialTextField
import Crashlytics


class ChangePasswordViewController: UIViewController,ErrorProtocalDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var tfOfOldPassword : MFTextField!
    @IBOutlet weak var tfOfNewPassword : MFTextField!
    @IBOutlet var btnofPwdHide: UIButton!
    @IBOutlet var btnofPwdHideNewPwd: UIButton!
    var isError : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfOfNewPassword.delegate = self
        tfOfOldPassword.delegate = self
        
        tfOfOldPassword.addTarget(self, action: #selector(validTxt(_:)), for: .editingChanged)
        tfOfNewPassword.addTarget(self, action: #selector(validTxt(_:)), for: .editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        let fee = NSLocalizedString("Old password", comment: "")
        let fee1 = NSLocalizedString("New password", comment: "")
        
        tfOfOldPassword.placeholder = fee
        tfOfNewPassword.placeholder = fee1
    }
    
    func allTextFieldsResignResp(){
        
        if tfOfNewPassword.isFirstResponder{
            tfOfNewPassword.resignFirstResponder()
        }else if tfOfOldPassword.isFirstResponder{
            tfOfOldPassword.resignFirstResponder()
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfOfNewPassword.resignFirstResponder()
        tfOfOldPassword.resignFirstResponder()
    }
    
    func textFieldPassword() -> Bool {
        
        
        let boolValue = Utilities.sharedInstace.isValidPassword(candidate: tfOfNewPassword.text!)
        return boolValue
        
    }
    
    
    func textFieldPassword2() -> Bool {
        
        
        let boolValue = Utilities.sharedInstace.isValidPassword(candidate: tfOfOldPassword.text!)
        return boolValue
        
    }
    @objc func validTxt(_ text : UITextField){
        
        if text == tfOfOldPassword  {
            
            if ((tfOfOldPassword.text?.count)! < 6) {
                let errStr = NSLocalizedString("Password length must have at least 6 character !!..", comment: "")
                let error = self.error(withLocalizedDescription: errStr)
                tfOfOldPassword.setError(error, animated: true)
            }else{
                if !textFieldPassword2() {
                    let errStr = NSLocalizedString("Password should be atleast one capital,numeric,small letters...", comment: "")
                    let error = self.error(withLocalizedDescription: errStr)
                    tfOfOldPassword.setError(error, animated: true)
                }else{
                    tfOfOldPassword.setError(nil, animated: true)
                }
            }
            
        }
            
        else if text == tfOfNewPassword{
            
            if ((tfOfNewPassword.text?.count)! < 6) {
                let errStr = NSLocalizedString("Password length must have at least 6 character !!..", comment: "")
                let error = self.error(withLocalizedDescription: errStr)
                tfOfNewPassword.setError(error, animated: true)
            }else{
                if !textFieldPassword() {
                    let errStr = NSLocalizedString("Password should be atleast one capital,numeric,small letters...", comment: "")
                    let error = self.error(withLocalizedDescription: errStr)
                    tfOfNewPassword.setError(error, animated: true)
                }else{
                    tfOfNewPassword.setError(nil, animated: true)
                }
            }
            
        }
        
    }
    
    func error(withLocalizedDescription localizedDescription: String) -> Error? {
        let userInfo = [NSLocalizedDescriptionKey: localizedDescription]
        return NSError(domain: MFDemoErrorDomain as? String ?? "", code: Int(MFDemoErrorCode), userInfo: userInfo)
    }
    
    func validateTextField1(text : UITextField) {
        var error: Error? = nil
        if text == tfOfOldPassword{
            if !textField1IsValid() {
                let err = NSLocalizedString("please enter old password...", comment: "")
                error = self.error(withLocalizedDescription: err)
            }
            tfOfOldPassword.setError(error, animated: true)
        }
    }
    
    func textField1IsValid() -> Bool {
        return tfOfOldPassword.text == UserDefaultStore.password
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 100)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tfOfNewPassword {
            
            let currentCharacterCount = textField.text?.count ?? 0
            
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            
            return newLength <= Int(truncating: 10)
            
        }
        return true
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = view.frame.offsetBy(dx: 0, dy: movement)
        //  self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    @IBAction func backBtnAction(_ sender : Any){
        allTextFieldsResignResp()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func passwordShowBtnAction(_ sender : Any){
        
        if btnofPwdHide.isSelected == true {
            btnofPwdHide.isSelected = false
            tfOfOldPassword.isSecureTextEntry = true
        }else{
            btnofPwdHide.isSelected = true
            tfOfOldPassword.isSecureTextEntry = false
        }
        
    }
    
    
    @IBAction func passwordShowBtnNewPwdAction(_ sender : Any){
        
        if btnofPwdHideNewPwd.isSelected == true {
            btnofPwdHideNewPwd.isSelected = false
            tfOfNewPassword.isSecureTextEntry = true
        }else{
            btnofPwdHideNewPwd.isSelected = true
            tfOfNewPassword.isSecureTextEntry = false
        }
        
    }
    
    func validateInputs() -> Bool {
        var isReturn : Bool = true
        
        if tfOfOldPassword.text?.count == 0 {
            let loc = NSLocalizedString("please enter old password...", comment: "")
            let err = self.error(withLocalizedDescription: loc)
            tfOfOldPassword.setError(err, animated: true)
            isReturn = false
        }
            
        else if tfOfNewPassword.text?.count == 0 {
            let errStr = NSLocalizedString("Password length must have at least 6 character !!..", comment: "")
            let error = self.error(withLocalizedDescription: errStr)
            isReturn = false
            tfOfNewPassword.setError(error, animated: true)
        }
        else if ((tfOfNewPassword.text?.count)! < 6) {
            let errStr = NSLocalizedString("Password length must have at least 6 character !!..", comment: "")
            let error = self.error(withLocalizedDescription: errStr)
            isReturn = false
            tfOfNewPassword.setError(error, animated: true)
        }else{
            
            if ((tfOfNewPassword.text?.count)! < 6) {
                let errStr = NSLocalizedString("Password length must have at least 6 character !!..", comment: "")
                let error = self.error(withLocalizedDescription: errStr)
                isReturn = false
                tfOfNewPassword.setError(error, animated: true)
            }else{
                if !textFieldPassword() {
                    let errStr = NSLocalizedString("Password should be atleast one capital,numeric,small letters...", comment: "")
                    let error = self.error(withLocalizedDescription: errStr)
                    isReturn = false
                    tfOfNewPassword.setError(error, animated: true)
                }
            }
            
            
            
        }
        
        
        return isReturn
        
    }
    
    @IBAction func updatePasswordBtnAction(_ sender : Any){
        
        if validateInputs() {
            allTextFieldsResignResp()
            
            //            if tfOfNewPassword.text != tfOfOldPassword.text{
            callforUpdatePassword()
            //            }else{
            //                Utilities.sharedInstace.showAlertviewWithMessage("don't enter old password")
            //            }
        }
        
    }
    @IBAction func CancelBtnAction(_ sender : Any){
    //      Crashlytics.sharedInstance().crash()
//        Answers.logPurchase(withPrice: 13.50,
//                                     currency: "USD",
//                                     success: true,
//                                     itemName: "Answers Shirt",
//                                     itemType: "Apparel",
//                                     itemId: "sku-350",
//                                     customAttributes: [:])
//        Answers.logPurchase(withPrice: 50,
//                                                 currency: "INR",
//                                                 success: false,
//                                                 itemName: "nothing",
//                                                 itemType: "good",
//                                                 itemId: "12456478",
//                                                 customAttributes: [
//            "Custom String" : "Acesstoken",
//            "Custom Number" : 9703635645])
      
        
      
        
        
        
        allTextFieldsResignResp()
        self.navigationController?.popViewController(animated: true)
    }
    
    func callforUpdatePassword(){
        
        let param : [String : Any] = [
            APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
            APIRequestKeys.userRef : UserDefaultStore.userRef,
            updatePassword.APIRequest.userType : userType,
            updatePassword.APIRequest.oldPassword : tfOfOldPassword.text!,
            updatePassword.APIRequest.password : tfOfNewPassword.text!]
        
     //   APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.updatePassword, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                UserDefaultStore.password = self.tfOfNewPassword.text
                self.navigationController?.popViewController(animated: true)
                
            }else{
                Utilities.sharedInstace.showAlertviewWithMessage(String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.error_message)))
                
            }
            
            
            
        }) { (networkErr, messag) in
            APIServices.SharedInstance.hideProgress()
            if messag == unauthorised {
                
                let unauth = NSLocalizedString("UnAuthorisedUser", comment: "")
                
                let objofSweetAlrt = SweetAlerts()
                objofSweetAlrt.isTapGestureReg = false
                _ =  objofSweetAlrt.showAlert(unauth, style: .none, buttonTitle: NSLocalizedString("Okay", comment : ""), action: { (okay) in
                    objofSweetAlrt.isTapGestureReg = false
                    
                    
                    let loginVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    UserDefaultStore.isLogined = "0"
                    self.navigationController?.pushViewController(loginVC, animated: true)
                    
                    
                })
                
            }else{
                
                let OopsVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
                
                OopsVC.errorDelegate = self
                
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        callforUpdatePassword()
        
    }
    
    
}
