//
//  ResetPassWordViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import MaterialTextField


class ResetPassWordViewController: UIViewController,ErrorProtocalDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var tfOfNewPassword : MFTextField!
    @IBOutlet weak var tfOfConfirmPassword : MFTextField!
    @IBOutlet var btnofPwdHide: UIButton!
    @IBOutlet var btnofPwdHide2: UIButton!
    
    var isError : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfOfNewPassword.delegate = self
        tfOfConfirmPassword.delegate = self
        
        tfOfNewPassword.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfOfConfirmPassword.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
        let email = NSLocalizedString("New Password", comment: "")
        let email1 = NSLocalizedString("Confirm Password", comment: "")
        
        tfOfNewPassword.placeholder = email
        tfOfConfirmPassword.placeholder = email1
        
    }
    
    func allTextFieldResignResp(){
        
        if tfOfNewPassword.isFirstResponder{
            tfOfNewPassword.resignFirstResponder()
            tfOfNewPassword.setError(nil, animated: false)
        }else if tfOfConfirmPassword.isFirstResponder{
            tfOfConfirmPassword.resignFirstResponder()
            tfOfNewPassword.setError(nil, animated: false)
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        tfOfNewPassword.resignFirstResponder()
        tfOfConfirmPassword.resignFirstResponder()
        
    }
    
    @objc func validTxt(_ text : UITextField){
        
        if text == tfOfNewPassword || text == tfOfConfirmPassword {
            self.validateTextField1(text: text)
        }
        
    }
    
    func error(withLocalizedDescription localizedDescription: String) -> Error? {
        let userInfo = [NSLocalizedDescriptionKey: localizedDescription]
        return NSError(domain: MFDemoErrorDomain as? String ?? "", code: Int(MFDemoErrorCode), userInfo: userInfo)
    }
    
    func validateTextField1(text : UITextField) {
        var error: Error? = nil
        if text == tfOfNewPassword{
            var error: Error? = nil
            if ((tfOfNewPassword.text?.count)! < 6) {
                let errStr = NSLocalizedString("Password length must have at least 6 character !!..", comment: "")
                error = self.error(withLocalizedDescription: errStr)
                tfOfNewPassword.setError(error, animated: true)
            }else{
                if !textField1IsValid() {
                    //bug
                    let errStr = NSLocalizedString("Password should be atleast one capital,numeric,small letters...", comment: "")
                    error = self.error(withLocalizedDescription: errStr)
                }
                tfOfNewPassword.setError(error, animated: true)
            }
        }else{
            
            if !textField2IsValid() {
                let errStr = NSLocalizedString("please enter correct password...", comment: "")
                error = self.error(withLocalizedDescription: errStr)
            }
            tfOfConfirmPassword.setError(error, animated: true)
        }
    }
    func textFieldPassword() -> Bool {
        let boolValue = Utilities.sharedInstace.isValidPassword(candidate: tfOfNewPassword.text!)
        return boolValue
        
    }
    func textField1IsValid() -> Bool {
        
        let boolValue = Utilities.sharedInstace.isValidPassword(candidate: tfOfNewPassword.text!)
        return boolValue
    }
    
    func textField2IsValid() -> Bool {
        return (tfOfConfirmPassword.text?.count)! > 0
    }
    
    func textField3IsValid() -> Bool {
        return tfOfConfirmPassword.text == tfOfNewPassword.text
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //        if Constatns.ViewWidth == Constatns.iPhone5Width{
        animateViewMoving(up: true, moveValue: 100)
        //        }
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        if Constatns.ViewWidth == Constatns.iPhone5Width{
        animateViewMoving(up: false, moveValue: 100)
        //        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tfOfNewPassword ||  textField == tfOfConfirmPassword {
            
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
        
        allTextFieldResignResp()
        
        let loginVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVc, animated: true)
        
        
    }
    
    @IBAction func passwordShowBtnAction(_ sender : Any){
        
        if btnofPwdHide.isSelected == true {
            btnofPwdHide.isSelected = false
            tfOfNewPassword.isSecureTextEntry = true
        }else{
            btnofPwdHide.isSelected = true
            tfOfNewPassword.isSecureTextEntry = false
        }
        
    }
    
    
    @IBAction func passwordShowBtn2Action(_ sender : Any){
        
        if btnofPwdHide2.isSelected == true {
            btnofPwdHide2.isSelected = false
            tfOfConfirmPassword.isSecureTextEntry = true
        }else{
            btnofPwdHide2.isSelected = true
            tfOfConfirmPassword.isSecureTextEntry = false
        }
        
    }
    
    
    
    func validateInputs() -> Bool {
        var isReturn : Bool = true
        if tfOfNewPassword.text?.count == 0{
            
            let errStr = NSLocalizedString("Password length must have at least 6 character !!..", comment: "")
            let error = self.error(withLocalizedDescription: errStr)
            isReturn = false
            tfOfNewPassword.setError(error, animated: true)
            
        } else if tfOfConfirmPassword.text?.count == 0{
            let errStr = NSLocalizedString("Password length must have at least 6 character !!..", comment: "")
            let error = self.error(withLocalizedDescription: errStr)
            isReturn = false
            tfOfConfirmPassword.setError(error, animated: true)
            
        }else if !textFieldPassword() {
            
            if ((tfOfNewPassword.text?.count)! < 6) {
                let errStr = NSLocalizedString("Password length must have at least 6 character !!..", comment: "")
                let error = self.error(withLocalizedDescription: errStr)
                isReturn = false
                tfOfNewPassword.setError(error, animated: true)
            }
            else if !textFieldPassword() {
                let errStr = NSLocalizedString("Password should be atleast one capital,numeric,small letters...", comment: "")
                let error = self.error(withLocalizedDescription: errStr)
                isReturn = false
                tfOfNewPassword.setError(error, animated: true)
            }
        }else if !textField3IsValid()  {
            
            if ((tfOfConfirmPassword.text?.count)! < 6) {
                let errStr = NSLocalizedString("Password length must have at least 6 character !!..", comment: "")
                let error = self.error(withLocalizedDescription: errStr)
                isReturn = false
                tfOfNewPassword.setError(error, animated: true)
            }
            else if !textField3IsValid() {
                let errStr = NSLocalizedString("Password should be atleast one capital,numeric,small letters...", comment: "")
                let error = self.error(withLocalizedDescription: errStr)
                isReturn = false
                tfOfConfirmPassword.setError(error, animated: true)
            }
        }
        
        return isReturn
        
    }
    
    
    @IBAction func resetPasswordBtnAction(_ sender : Any){
        
        if textField3IsValid() {
            if validateInputs(){
                allTextFieldResignResp()
                callforUpdateForgotPassword()
            }
        }else{
            let errStr = NSLocalizedString("Confirm & New passwords should be same", comment: "")
            let error = self.error(withLocalizedDescription: errStr)
            tfOfConfirmPassword.setError(error, animated: true)
        }
        
        
        
    }
    
    
    func callforUpdateForgotPassword(){
        /*{"userRef":"UspJ0gzXZkTdHpOL","ApiKey":"OIxv03jBrOUGAKg8","mobileNumber":"8528330637","password":"12345678","userType":"2"}*/
        
        
    //    APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        let param : [String : Any] = [
            APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
            APIRequestKeys.userRef : UserDefaultStore.userRef,
            UpdateForgotPassword.APIRequest.mobileNumber : UserDefaultStore.mobileNumber!,
            UpdateForgotPassword.APIRequest.password : tfOfNewPassword.text!,
            UpdateForgotPassword.APIRequest.userType : userType,
            UpdateForgotPassword.APIRequest.registerId : UserDefaultStore.DeviceToken!,
            UpdateForgotPassword.APIRequest.deviceId : UserDefaultStore.deviceID!,
            UpdateForgotPassword.APIRequest.deviceType : deviceType]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.updateForgotPassword, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            // print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                if self.tfOfNewPassword.text == self.tfOfConfirmPassword.text{
                    
                    UserDefaultStore.password = self.tfOfNewPassword.text!
                    APIServices.SharedInstance.invalidatePreviousRequest()
                    // self.callLoginApi()
                    
                    let responseData = dictofResonse.object(forKey: Login.APIResponse.data) as! NSDictionary
                    UserDefaultStore.ApiKey = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.ApiKey))
                    UserDefaultStore.userRef = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.userRef))
                    UserDefaultStore.mobilePrefix = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.userPrefix))
                    UserDefaultStore.userID = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.Userid))
                    
                    UserDefaultStore.emailId = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.emailId))
                    UserDefaultStore.mobileNumber = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.mobileNumber))
                    
                    let strofClincCount = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.clinicCount))
                    
                    //navigate to home vc
                    let homevc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    homevc.strofClinicCount = strofClincCount
                    self.navigationController?.pushViewController(homevc, animated: true)
                    
                    
                    
                }else{
                    Utilities.sharedInstace.showAlertviewWithMessage(NSLocalizedString("please enter correct confirm password...", comment: ""))
                }
                
            }
            else{
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
                self.isError = "update"
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        if self.isError == "update"{
            callforUpdateForgotPassword()
        }
        
    }
    
    
    func callLoginApi(){
        
        
    //    APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        let param : [String : Any] =
            [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
             APIRequestKeys.userRef : UserDefaultStore.userRef,
             Login.APIRequest.emailMobileNumber : UserDefaultStore.mobileNumber!,
             Login.APIRequest.password : UserDefaultStore.password!,
             Login.APIRequest.deviceId : UserDefaultStore.deviceID!,
             Login.APIRequest.deviceType : deviceType,
             Login.APIRequest.registerId : UserDefaultStore.DeviceToken!,
             Login.APIRequest.userType : userType,
             Login.APIRequest.mobilePrefix : UserDefaultStore.mobilePrefix!]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.login, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //  print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                
                UserDefaultStore.password = self.tfOfNewPassword.text!
                
                let responseData = dictofResonse.object(forKey: Login.APIResponse.data) as! NSDictionary
                UserDefaultStore.ApiKey = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.ApiKey))
                UserDefaultStore.userRef = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.userRef))
                UserDefaultStore.mobilePrefix = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.userPrefix))
                UserDefaultStore.userID = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.Userid))
                
                UserDefaultStore.emailId = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.emailId))
                UserDefaultStore.mobileNumber = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.mobileNumber))
                
                let strofClincCount = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.clinicCount))
                
                //navigate to home vc
                let homevc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                homevc.strofClinicCount = strofClincCount
                self.navigationController?.pushViewController(homevc, animated: true)
                
                
            }
            else{
                
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
    
    
    
    @IBAction func cancelBtnAction(_ sender : Any){
        
        allTextFieldResignResp()
        
        let loginVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        UserDefaultStore.isLogined = "0"
        self.navigationController?.pushViewController(loginVC, animated: true)
        
        //self.navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
