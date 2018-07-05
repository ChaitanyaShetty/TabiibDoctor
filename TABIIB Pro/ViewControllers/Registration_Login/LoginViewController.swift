//
//  LoginViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

import MaterialTextField
import CoreTelephony

let MFDemoErrorDomain = "MFDemoErrorDomain"
let MFDemoErrorCode: Int = 100


let userType = "2"
let deviceType = "4"





class LoginViewController: UIViewController,ErrorProtocalDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var tfOfEmail : MFTextField!
    @IBOutlet weak var tfOfPassword : MFTextField!
    @IBOutlet weak var btnofPwdHide : UIButton!
    
    @IBOutlet var lblOfPrefix : UILabel!
    @IBOutlet weak var btnOfPrefix : UIButton!
    var minCountryMobileNoLength : NSNumber?
    @IBOutlet var pickerData : UIPickerView!
    @IBOutlet var viewofPicker : UIView!
    
    var singltonObj : SingleTonClass!
    var isError : String = ""
    var strPrefix : String = String()
    var arrofOptions : Array<String>!
    
    var selectedPrefixPicker : String! = String()
    var isPickerSelectionDone : Bool = false
    
   
    var arrOfSuppCountries = NSArray()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        arrofOptions = Array()
        
        singltonObj = SingleTonClass.SharedInstance
        singltonObj.singIdentifier = "SignUpViewController"
        
        UserDefaultStore.ApiKey = "OIxv03jBrOUGAKg8"
        UserDefaultStore.userRef = "UspJ0gzXZkTdHpOL"
        
        //        tfOfEmail.text = "9866862330"
        //        tfOfPassword.text = "123456"
        lblOfPrefix.backgroundColor = Constatns.UnSelectThemeColour()
        
        tfOfEmail.delegate = self
        tfOfPassword.delegate = self
        
        tfOfEmail.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfOfPassword.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        
        tfOfEmail.isUserInteractionEnabled = false
        
        viewofPicker.isHidden = true
        
        getCountriesAPI()
        
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
        tfOfEmail.inputAccessoryView = numberToolbar
        
    }
    @objc func doneClicked(){
        if tfOfEmail.isFirstResponder{
            tfOfEmail.resignFirstResponder()
        }
    }
    
    
    func getcurrentUserisoCode(){
        
        let networkInfp = CTTelephonyNetworkInfo.init()
        let carrierIs   = networkInfp.subscriberCellularProvider
        APIServices.SharedInstance.hideProgress()
        //let arrofCountryCodes : NSArray = NSArray.init(contentsOfFile: NSBundle.mainBundle().pathForResource("CountryCodes", ofType: "plist")!)!
        if carrierIs != nil{
            
            for (_,dictofCoun) in self.arrOfSuppCountries.enumerated(){
                
                let dicofCountry : NSDictionary = dictofCoun as! NSDictionary
                
                if String(describing: dicofCountry.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.ShortName)) == carrierIs?.isoCountryCode?.uppercased(){
                    
                            strPrefix = (dicofCountry.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.PhoneCode))
                            selectedPrefixPicker = strPrefix
                            
                            btnOfPrefix.setTitle("+" + strPrefix, for: .normal)
                            
                            let strOfmin = dicofCountry.object(forKey: getCountriesList.APIResponse.minNumberLength) as! String
                            minCountryMobileNoLength = Int(strOfmin)! as NSNumber
                            tfOfEmail.isUserInteractionEnabled = true
                    
                            break
                        
                        }
                }
            
        }else{
            
            let country = NSLocalizedString("Please insert SIM Card...", comment: "")
            self.tfOfEmail.isUserInteractionEnabled = false
            Utilities.sharedInstace.showAlertviewWithMessage(country)
            
        }
    }
    
    
    
    func getCountriesAPI(){
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef]
        
   //     APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.getCountries, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                self.arrOfSuppCountries = dictofResonse.object(forKey: getCountriesList.APIResponse.Countries) as! NSArray
                
                let arraOfCountries = dictofResonse.object(forKey: getCountriesList.APIResponse.Countries) as! NSArray
                
                if arraOfCountries.count > 0{
                UserDefaults.standard.set(arraOfCountries, forKey: "countries")
                }
                
                
                self.getcurrentUserisoCode()
                
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
                
                self.isError = "getCountries"
                
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
        let email = NSLocalizedString("Mobile Number", comment: "")
        let password = NSLocalizedString("Password", comment: "")
        
        tfOfPassword.placeholder = password
        tfOfEmail.placeholder = email
        
        tfOfEmail.text = ""
        tfOfPassword.text = ""
        
        let err : Error = self.error(withLocalizedDescription: "")!
        tfOfEmail.setError(err, animated: true)
        tfOfPassword.setError(err, animated: true)
        
    }
    
    
    
    
    func allTextFieldResignResp(){
        
       
        
        if tfOfEmail.isFirstResponder{
            tfOfEmail.resignFirstResponder()
            tfOfEmail.setError(nil, animated: false)
        }else if tfOfPassword.isFirstResponder{
            tfOfPassword.resignFirstResponder()
            tfOfPassword.setError(nil, animated: false)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        tfOfEmail.resignFirstResponder()
        tfOfPassword.resignFirstResponder()
    }
    
    @objc func validTxt(_ text : UITextField){
        
        if text == tfOfEmail || text == tfOfPassword {
            self.validateTextField1(text: text)
        }
        
    }
    
    func error(withLocalizedDescription localizedDescription: String) -> Error? {
        let userInfo = [NSLocalizedDescriptionKey: localizedDescription]
        return NSError(domain: MFDemoErrorDomain as? String ?? "", code: Int(MFDemoErrorCode), userInfo: userInfo)
    }
    
    
    
    func validateTextField1(text : UITextField) {
        var error: Error? = nil
        
        if viewofPicker.isHidden == false {
            viewofPicker.isHidden = true
        }
        
        
        if text == tfOfEmail{
            self.validateTF(text: text)
        }else{
            if !textField2IsValid() {
                let emailErr = NSLocalizedString("please enter correct password...", comment: "")
                error = self.error(withLocalizedDescription: emailErr)
            }
            tfOfPassword.setError(error, animated: true)
        }
    }
    
    func validateTF(text : UITextField) {
        var error: Error? = nil
        if text == tfOfEmail{
            if !textField1IsValid() {
                let err = NSLocalizedString("please enter valid Mobile Number...", comment: "")
                error = self.error(withLocalizedDescription: err)
            }
            tfOfEmail.setError(error, animated: true)
        }
    }
    
    //    func textField1IsValid() -> Bool {
    //
    //
    //        let stringReplace = btnOfPrefix.currentTitle?.replacingOccurrences(of: "+", with: "")
    //
    //        let pre = NSPredicate(format: "\(getCountriesList.APIResponse.PhoneCode) = %@","\(String(describing: stringReplace)))")
    //
    //        var dicOfObj = NSDictionary()
    //
    //        if let loadedArrayObjs = UserDefaults.standard.array(forKey: "countries"){
    //            let arrOfmutable = NSMutableArray()
    //            for i in 0 ..< loadedArrayObjs.count {
    //                let dic = loadedArrayObjs[i] as! NSDictionary
    //                arrOfmutable.add(dic)
    //            }
    //            let arr = arrOfmutable.filtered(using: pre)
    //            if arr.count > 0{
    //
    //                dicOfObj = arr[0] as! NSDictionary
    //
    //                let strOfmin = dicOfObj.object(forKey: getCountriesList.APIResponse.minNumberLength) as! String
    //                minCountryMobileNoLength = Int(strOfmin)! as NSNumber
    //            }
    //        }
    //
    //        if strPrefix == dicOfObj.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.PhoneCode){
    //            if (tfOfEmail.text?.count)! < Int(truncating: minCountryMobileNoLength!) {
    //                return false
    //            }else{
    //                return true
    //            }
    //        }else{
    //            return false
    //        }
    //    }
    
    
    func textField1IsValid() -> Bool {
        return (tfOfEmail.text?.count)! == Int(truncating: minCountryMobileNoLength!)
    }
    
    func textField2IsValid() -> Bool {
        return (tfOfPassword.text?.count)! > 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func callLoginApi(){
        /*{"emailMobileNumber":"manishkumar@1wayit.com","password":"1234567","ApiKey":"OIxv03jBrOUGAKg8","userRef":"UspJ0gzXZkTdHpOL"
         ,"deviceId":"123456","deviceType":"3","registerId":"zt3IK2SxxBMvzI8f","userType":"2"}*/
        
        
    //    APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        let param : [String : Any] = [ APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                       APIRequestKeys.userRef : UserDefaultStore.userRef,
                                       Login.APIRequest.emailMobileNumber : tfOfEmail.text!,
                                       Login.APIRequest.password : tfOfPassword.text!,
                                       Login.APIRequest.deviceId : UserDefaultStore.deviceID!,
                                       Login.APIRequest.deviceType : deviceType,
                                       Login.APIRequest.registerId : UserDefaultStore.DeviceToken!,
                                       Login.APIRequest.userType : userType,
                                       Login.APIRequest.mobilePrefix : strPrefix]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.login, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //  print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                UserDefaultStore.isLogined = "1"
                
                
                let responseData = dictofResonse.object(forKey: Login.APIResponse.data) as! NSDictionary
                UserDefaultStore.ApiKey = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.ApiKey))
                UserDefaultStore.userRef = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.userRef))
                UserDefaultStore.mobilePrefix = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.userPrefix))
                UserDefaultStore.userID = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.Userid))
                
                UserDefaultStore.emailId = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.emailId))
                UserDefaultStore.mobileNumber = String(describing:responseData.TabiibDocObjectForKey(forKey: Login.APIResponse.mobileNumber))
                
                UserDefaultStore.password = self.tfOfPassword.text!
                
                
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
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        if self.isError == "getCountries"{
            getCountriesAPI()
        }else{
            callLoginApi()
        }
        
    }
    
    @IBAction func mobilePrefix(_ sender : Any){
        
        arrofOptions.removeAll()
        
        if let loadedArrayObjs = UserDefaults.standard.array(forKey: "countries")  {
            
            for item in 0 ..< loadedArrayObjs.count {
                
                let dic = loadedArrayObjs[item] as! NSDictionary
                
                let strOfPhoneCode = dic.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.PhoneCode)
                
                arrofOptions.append(strOfPhoneCode)
                
            }
        }
        
        pickerData.reloadAllComponents()
        viewofPicker.isHidden = false
        lblOfPrefix.backgroundColor = Constatns.ThemeColour()
        if arrofOptions.count > 0 {
            tfOfEmail.isUserInteractionEnabled = true
        }
        allTextFieldResignResp()
        
        
        
    }
    
    
    @IBAction func pickerDoneClicked(_ sender : Any){
        
        allTextFieldResignResp()
        
        if isPickerSelectionDone == false {
            selectedPrefixPicker = arrofOptions[0]
        }
        
        print(selectedPrefixPicker)
        
        let pre = NSPredicate(format: "\(getCountriesList.APIResponse.PhoneCode) = %@","\(selectedPrefixPicker!)")
        if let loadedArrayObjs = UserDefaults.standard.array(forKey: "countries"){
            let arrOfmutable = NSMutableArray()
            for i in 0 ..< loadedArrayObjs.count {
                let dic = loadedArrayObjs[i] as! NSDictionary
                arrOfmutable.add(dic)
            }
            let arr = arrOfmutable.filtered(using: pre)
            if arr.count > 0{
                let dicOfObj = arr[0] as! NSDictionary
                
                strPrefix = dicOfObj.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.PhoneCode)
                btnOfPrefix.setTitle("+" + strPrefix, for: .normal)
                
                let strOfmin = dicOfObj.object(forKey: getCountriesList.APIResponse.minNumberLength) as! String
                minCountryMobileNoLength = Int(strOfmin)! as NSNumber
                
            }
        }
        
        lblOfPrefix.backgroundColor = Constatns.UnSelectThemeColour()
        btnOfPrefix.setTitle("+" + strPrefix, for: .normal)
        viewofPicker.isHidden = true
        tfOfEmail.text = ""
        
        
    }
    @IBAction func pickerCancelClicked(_ sender : Any){
        
        viewofPicker.isHidden = true
        lblOfPrefix.backgroundColor = Constatns.UnSelectThemeColour()
        
        
    }
    
    
    @IBAction func passwordShowBtnAction(_ sender : Any){
        
        if btnofPwdHide.isSelected == true {
            btnofPwdHide.isSelected = false
            tfOfPassword.isSecureTextEntry = true
        }else{
            btnofPwdHide.isSelected = true
            tfOfPassword.isSecureTextEntry = false
        }
        
    }
    
    @IBAction func tapOnBtnSignIn(_ sender : Any){
        
        
        if tfOfEmail.text?.count == 0{
            let error = self.error(withLocalizedDescription: NSLocalizedString("please enter valid Mobile Number...", comment: ""))
            tfOfEmail.setError(error, animated: true)
        }
            //        else if tfOfEmail.text?.isNumeric == false {
            //            if Utilities.sharedInstace.validateEmail(emailAddress: tfOfEmail.text!) == false {
            //                let error = self.error(withLocalizedDescription: NSLocalizedString("please enter email Id...", comment: ""))
            //                tfOfEmail.setError(error, animated: true)
            //            }else{
            //                if tfOfPassword.text?.count == 0{
            //                    let error = self.error(withLocalizedDescription: NSLocalizedString("please enter password...", comment: ""))
            //                    tfOfPassword.setError(error, animated: true)
            //                }else{
            //                    allTextFieldResignResp()
            //                    callLoginApi()
            //                }
            //            }
            //        }
        else if tfOfPassword.text?.count == 0{
            let error = self.error(withLocalizedDescription: NSLocalizedString("please enter password...", comment: ""))
            tfOfPassword.setError(error, animated: true)
        }else{
            if viewofPicker.isHidden == false {
                viewofPicker.isHidden = true
            }
            allTextFieldResignResp()
            callLoginApi()
        }
        
        
        
    }
    
    @IBAction func tapOnSignUPBtn(_ sender : Any){
        allTextFieldResignResp()
        let signupVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signupVc, animated: true)
        
        
    }
    
    @IBAction func tapOnForgotBtn(_ sender : Any){
        allTextFieldResignResp()
        let forgotVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "ForgotViewController") as! ForgotViewController
        self.navigationController?.pushViewController(forgotVc, animated: true)
        
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
        
        if textField == tfOfEmail {
            
            let currentCharacterCount = textField.text?.count ?? 0
            
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            
            return newLength <= Int(truncating: minCountryMobileNoLength!)
            
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
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension LoginViewController : UIPickerViewDataSource,UIPickerViewDelegate
{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrofOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrofOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        isPickerSelectionDone = true
        self.selectedPrefixPicker = arrofOptions[row]
        // btnofGender.setTitle(arrofOptions[row], for: .normal)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    //    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    //
    //        let titleData = arrofOptions[row]
    //
    //        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Lato", size: 20.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
    //
    //        return myTitle
    //    }
    
    
}
