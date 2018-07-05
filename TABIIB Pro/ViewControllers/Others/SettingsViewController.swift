//
//  SettingsViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,ErrorProtocalDelegate {
    
    @IBOutlet var swithofAppointCofirm : UIButton!
    
    var singObj : SingleTonClass!
    
    var isSettingEnable : Bool = false
    var isError : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singObj = SingleTonClass.SharedInstance
        singObj.singIdentifier = "SettingsViewController"
        
        // print(UserDefaultStore.isAutoConfirmAppointment)
        
        if UserDefaultStore.isAutoConfirmAppointment == "1" {
            isSettingEnable = true
        }
        else {
            isSettingEnable = false
        }
        
        setSwithButtonApperance()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    func setSwithButtonApperance(){
        if isSettingEnable {
            swithofAppointCofirm.isSelected = true
        }else{
            swithofAppointCofirm.isSelected = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSwitchActionChanged(_ sender : UIButton) {
        if isSettingEnable {
            updateAppointmentconfirmAPIReqiest("0")
        }else{
            updateAppointmentconfirmAPIReqiest("1")
        }
        
    }
    
    
    func updateAppointmentconfirmAPIReqiest(_ isAutoConfirm : String){
        
        
      //  APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      updateDocSetting.APIRequest.userType : userType,
                                      updateDocSetting.APIRequest.ConfirmAllApp : "\(isAutoConfirm)"]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.updateDocSetting, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            // print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                UserDefaultStore.isAutoConfirmAppointment = isAutoConfirm
                if isAutoConfirm == "1" {
                    self.isSettingEnable = true
                }else{
                    self.isSettingEnable = false
                }
                
                self.setSwithButtonApperance()
                
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
                self.isError = "updateautoconfirm"
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        if self.isError == "logout"{
            callLogOutAPI()
        }
        
    }
    
    @IBAction func changePasswordBtnClicked(_ sender : Any){
        let changePassVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        
        self.navigationController?.pushViewController(changePassVC, animated: true)
    }
    
    
    
    @IBAction func btnBackclicked(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logOutBtnClicked(_ sender : Any){
        
//        let logInVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        UserDefaultStore.isLogined = "0"
//        self.navigationController?.pushViewController(logInVC, animated: true)
        
         callLogOutAPI()
    }
    
    
    func callLogOutAPI(){
        
        let param : [String : Any] = [
            SettingsLogOut.APIRequest.ApiKey:UserDefaultStore.ApiKey,
            SettingsLogOut.APIRequest.userRef : UserDefaultStore.userRef,
            logOut.APIRequest.deviceType : deviceType]
        
      //  APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.logOut, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            // print(response)
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                let logInVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                UserDefaultStore.isLogined = "0"
                self.navigationController?.pushViewController(logInVC, animated: true)
                
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
                self.isError = "logout"
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
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
