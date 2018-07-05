//
//  OTPViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import MaterialTextField



class OTPViewController: UIViewController,ErrorProtocalDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var lblOfOtpNumber : UILabel!
    @IBOutlet weak var tfOfOtpNumber : MFTextField!
    
    let message = "message"
    let voicecall = "voicecall"
    
    var isNaviFromRegis : Bool = false
    var nofotimesResendRequest = 0
    
    var isError : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfOfOtpNumber.placeholderAnimatesOnFocus = true
        
        //Auto detecting the OTP sent to 9955661188
        
        let storfPreTextofOTP = NSLocalizedString("You will receive the OTP shortly ", comment: "")
        
        lblOfOtpNumber.text = storfPreTextofOTP + UserDefaultStore.mobileNumber!
        
        tfOfOtpNumber.delegate = self
        
        tfOfOtpNumber.addTarget(self, action: #selector(validationCheck), for: .editingChanged)
        toolbaraddedtoKeyboard()
    }
    
    func toolbaraddedtoKeyboard(){
        let numberToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            
            
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem.init(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(doneClicked)),
            
        ]
        numberToolbar.sizeToFit()
        tfOfOtpNumber.inputAccessoryView = numberToolbar
        
    }
    @objc func doneClicked(){
        if tfOfOtpNumber.isFirstResponder{
            tfOfOtpNumber.resignFirstResponder()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
        let email = NSLocalizedString("OTP", comment: "")
        tfOfOtpNumber.placeholder = email
        
    }
    
    
    func allTextFieldResignResp(){
        if tfOfOtpNumber.isFirstResponder{
            tfOfOtpNumber.resignFirstResponder()
            tfOfOtpNumber.setError(nil, animated: false)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        tfOfOtpNumber.resignFirstResponder()
        
    }
    
    @objc func validationCheck(){
        self.validateTextField1()
    }
    
    func error(withLocalizedDescription localizedDescription: String) -> Error? {
        let userInfo = [NSLocalizedDescriptionKey: localizedDescription]
        return NSError(domain: MFDemoErrorDomain as? String ?? "", code: Int(MFDemoErrorCode), userInfo: userInfo)
    }
    
    func validateTextField1() {
        var error: Error? = nil
        
        if !textField1IsValid() {
            let err = NSLocalizedString("please enter valid OTP Number...", comment: "")
            error = self.error(withLocalizedDescription: err)
        }
        tfOfOtpNumber.setError(error, animated: true)
    }
    
    func textField1IsValid() -> Bool {
        
        if tfOfOtpNumber.text?.count == 5{
            allTextFieldResignResp()
            callforCheckOTP(isNaviFromRegis)
        }
        return (tfOfOtpNumber.text?.count)! <= 5
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tfOfOtpNumber {
            
            let currentCharacterCount = textField.text?.count ?? 0
            
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            
            return newLength <= 5
            
        }
        return true
    }
    
    @IBAction func backBtnAction(_ sender : Any){
        allTextFieldResignResp()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    func callforCheckOTP(_ isforForgotPwd : Bool){
        
        /*{"userOTP":"95986","mobileNumber":"565465456","userRef":"UspJ0gzXZkTdHpOL","ApiKey":"OIxv03jBrOUGAKg8","userType":"2"}*/
        
   //     APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        var strAPiname : String = APIMethods.checkOTP
        
        if isforForgotPwd == false {
            strAPiname = APIMethods.ForgotPasswordCheckOTP
        }else{
            strAPiname = APIMethods.checkOTP
        }
        
        let param : [String : Any] =
            [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey!,
             APIRequestKeys.userRef : UserDefaultStore.userRef!,
             CheckOTP.APIRequest.userOTP : tfOfOtpNumber.text!,
             CheckOTP.APIRequest.mobileNumber : UserDefaultStore.mobileNumber!,
             CheckOTP.APIRequest.userType : userType,
             CheckOTP.APIRequest.registerId : UserDefaultStore.DeviceToken!,
             CheckOTP.APIRequest.deviceId : UserDefaultStore.deviceID!,
             CheckOTP.APIRequest.deviceType : deviceType]
        
        // print(param)
        
        APIServices.SharedInstance.callApiResponse(MethodName: strAPiname, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            // print(response)
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                if isforForgotPwd == false {
                    
                    //to reset password
                    
                    let resetPwdVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "ResetPassWordViewController") as! ResetPassWordViewController
                    self.navigationController?.pushViewController(resetPwdVC, animated: true)
                    
                    
                }
                else{
                    
                    // self.callLoginApi()
                    
                    
                    let responseData = dictofResonse.object(forKey: Login.APIResponse.data) as! NSDictionary
                    UserDefaultStore.ApiKey = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.ApiKey))
                    UserDefaultStore.userRef = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.userRef))
                    UserDefaultStore.mobilePrefix = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.userPrefix))
                    UserDefaultStore.userID = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.Userid))
                    
                    let strofClincCount = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.clinicCount))
                    
                    //navigate to home vc
                    let homevc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    homevc.strofClinicCount = strofClincCount
                    self.navigationController?.pushViewController(homevc, animated: true)
                    
                    
                }
                
            }
            else{
                
                self.tfOfOtpNumber.text = ""
                
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
                self.isError = "callOtp"
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        if self.isError == "resend"{
            callforResendOtp()
        }else{
            callforCheckOTP(isNaviFromRegis)
        }
        
    }
    
    
    @IBAction func submitBtnAction(_ sender : Any){
        
        allTextFieldResignResp()
        
        if tfOfOtpNumber.text?.count == 0{
            let err = self.error(withLocalizedDescription: NSLocalizedString("please enter otp number...", comment: ""))
            tfOfOtpNumber.setError(err, animated: true)
            
        }else{
            
            callforCheckOTP(isNaviFromRegis)
        }
        
        
    }
    
    
    
    
    
    @IBAction func editBtnAction(_ sender : Any){
        allTextFieldResignResp()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func callLoginApi(){
        /*{"emailMobileNumber":"manishkumar@1wayit.com","password":"1234567","ApiKey":"OIxv03jBrOUGAKg8","userRef":"UspJ0gzXZkTdHpOL"
         ,"deviceId":"123456","deviceType":"3","registerId":"zt3IK2SxxBMvzI8f","userType":"2"}*/
        
        
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
                
                let responseData = dictofResonse.object(forKey: Login.APIResponse.data) as! NSDictionary
                UserDefaultStore.ApiKey = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.ApiKey))
                UserDefaultStore.userRef = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.userRef))
                UserDefaultStore.mobilePrefix = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.userPrefix))
                UserDefaultStore.userID = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.Userid))
                
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
                
                self.isError = "login"
                
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    func callforResendOtp(){
        /*{"mobileNumber":"8528330637","messageType":"message/voicecall","userRef":"UspJ0gzXZkTdHpOL","ApiKey":"OIxv03jBrOUGAKg8","userType":"2"}*/
        
        
    //    APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        let param : [String : Any] =
            [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
             APIRequestKeys.userRef : UserDefaultStore.userRef,
             ResendOTP.APIRequest.messageType : "message",
             ResendOTP.APIRequest.mobileNumber : UserDefaultStore.mobileNumber!,
             ResendOTP.APIRequest.userType : userType]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.resendOTPCode, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //  print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                self.tfOfOtpNumber.text = ""
                Utilities.sharedInstace.showAlertviewWithMessage(String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success_message)))
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
                self.isError = "resend"
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    @IBAction func resendBtnAction(_ sender : Any){
        
        allTextFieldResignResp()
        
        nofotimesResendRequest = nofotimesResendRequest + 1
        
        if nofotimesResendRequest > 2 {
            Utilities.sharedInstace.showAlertviewWithMessage(NSLocalizedString("Resned Password limit Exceeds", comment: ""))
        }else{
            
            callforResendOtp()
        }
        
        
        
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
