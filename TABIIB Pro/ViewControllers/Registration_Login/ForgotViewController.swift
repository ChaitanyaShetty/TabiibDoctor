//
//  ForgotViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import MaterialTextField
import CoreTelephony


class ForgotViewController: UIViewController,ErrorProtocalDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var tfOfMobileNumber : MFTextField!
    
    var arrofOptions : Array<String>!
    
    @IBOutlet weak var btnofGender : UIButton!
    @IBOutlet weak var viewofPicker : UIView!
    @IBOutlet weak var pickerData : UIPickerView!
    
    var singltonObj : SingleTonClass!
    var strPrefix : String = String()
    var minCountryMobileNoLength : NSNumber?
    
    @IBOutlet weak var lblOfPrefix : UILabel!
    @IBOutlet weak var lblofDescription : UILabel!
    
    var isError : String = ""
    
    var selectedPrefixPicker : String! = String()
    var isPickerSelectionDone : Bool = false
    
    var arrayOfCountries = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singltonObj = SingleTonClass.SharedInstance
        
        lblOfPrefix.backgroundColor = Constatns.UnSelectThemeColour()
        
        arrofOptions = Array()
        
        if let loadedArrayObjs = UserDefaults.standard.array(forKey: "countries")  {
            
            arrayOfCountries = loadedArrayObjs as NSArray
            
            for item in 0 ..< loadedArrayObjs.count {
                
                let dic = loadedArrayObjs[item] as! NSDictionary
                
                let strOfPhoneCode = dic.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.PhoneCode)
                
                arrofOptions.append(strOfPhoneCode)
                
            }
        }
        
        
        let myString = NSLocalizedString("Enter your mobile number, and we'll send you an OTP to reset your password", comment: "")
        let myAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.colorFromRGB(0x828181)]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        
        // set attributed text on a UILabel
        lblofDescription.attributedText = myAttrString
        
        viewofPicker.isHidden = true
        tfOfMobileNumber.placeholderAnimatesOnFocus = true
        tfOfMobileNumber.isUserInteractionEnabled = false
        getcurrentUserisoCode()
        
        tfOfMobileNumber.delegate = self
        
        tfOfMobileNumber.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        toolbaraddedtoKeyboard()
        // Do any additional setup after loading the view.
    }
    
    func toolbaraddedtoKeyboard(){
        let numberToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            
            
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem.init(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(doneClicked)),
            
        ]
        numberToolbar.sizeToFit()
        tfOfMobileNumber.inputAccessoryView = numberToolbar
        
    }
    @objc func doneClicked(){
        if tfOfMobileNumber.isFirstResponder{
            tfOfMobileNumber.resignFirstResponder()
        }
    }
    
    
    func getcurrentUserisoCode(){
        
        let networkInfp = CTTelephonyNetworkInfo.init()
        let carrierIs   = networkInfp.subscriberCellularProvider
        APIServices.SharedInstance.hideProgress()
        //let arrofCountryCodes : NSArray = NSArray.init(contentsOfFile: NSBundle.mainBundle().pathForResource("CountryCodes", ofType: "plist")!)!
        if carrierIs != nil{
            
            for (_,dictofCoun) in arrayOfCountries.enumerated(){
                
                let dicofCountry : NSDictionary = dictofCoun as! NSDictionary
                
                if String(describing: dicofCountry.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.ShortName)) == carrierIs?.isoCountryCode?.uppercased(){
                    
                    strPrefix = (dicofCountry.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.PhoneCode))
                    selectedPrefixPicker = strPrefix
                    
                    btnofGender.setTitle("+" + strPrefix, for: .normal)
                    
                    let strOfmin = dicofCountry.object(forKey: getCountriesList.APIResponse.minNumberLength) as! String
                    minCountryMobileNoLength = Int(strOfmin)! as NSNumber
                    tfOfMobileNumber.isUserInteractionEnabled = true
                    
                    break
                    
                }
            }
            
        }else{
            
            let country = NSLocalizedString("Please insert SIM Card...", comment: "")
            tfOfMobileNumber.isUserInteractionEnabled = false
            Utilities.sharedInstace.showAlertviewWithMessage(country)
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
        let email = NSLocalizedString("Mobile Number", comment: "")
        tfOfMobileNumber.placeholder = email
        
    }
    
    func allTextFieldResignResp(){
        
        if tfOfMobileNumber.isFirstResponder{
            tfOfMobileNumber.resignFirstResponder()
            tfOfMobileNumber.setError(nil, animated: false)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfOfMobileNumber.resignFirstResponder()
    }
    
    
    @objc func validTxt(_ text : UITextField){
        
        if viewofPicker.isHidden == false {
            viewofPicker.isHidden = true
        }
        
        if text == tfOfMobileNumber  {
            self.validateTextField1(text: text)
        }
        
    }
    
    func error(withLocalizedDescription localizedDescription: String) -> Error? {
        let userInfo = [NSLocalizedDescriptionKey: localizedDescription]
        return NSError(domain: MFDemoErrorDomain as? String ?? "", code: Int(MFDemoErrorCode), userInfo: userInfo)
    }
    
    func validateTextField1(text : UITextField) {
        var error: Error? = nil
        if text == tfOfMobileNumber{
            if !textField1IsValid() {
                let err = NSLocalizedString("please enter valid Mobile Number...", comment: "")
                error = self.error(withLocalizedDescription: err)
            }
            tfOfMobileNumber.setError(error, animated: true)
        }
    }
    
    func textField1IsValid() -> Bool {
        
        //        let stringReplace = btnofGender.currentTitle?.replacingOccurrences(of: "+", with: "")
        //
        //        let pre = NSPredicate(format: "\(getCountriesList.APIResponse.PhoneCode) = %@","\(String(describing: stringReplace))")
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
        
        // if strPrefix == dicOfObj.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.PhoneCode){
        return (tfOfMobileNumber.text?.count)! == Int(truncating: minCountryMobileNoLength!)
        //        }else{
        //            return false
        //        }
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
        
        if textField == tfOfMobileNumber {
            
            let currentCharacterCount = textField.text?.count ?? 0
            
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            
            return newLength <= Int(truncating: minCountryMobileNoLength!)
            
        }
        return true
    }
    
    
    @IBAction func backBtnAction(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelClicked(_ sender : Any){
        viewofPicker.isHidden = true
        lblOfPrefix.backgroundColor = Constatns.UnSelectThemeColour()
    }
    
    @IBAction func mobilePrefix(_ sender : Any){
        
        pickerData.reloadAllComponents()
        viewofPicker.isHidden = false
        lblOfPrefix.backgroundColor = Constatns.ThemeColour()
        tfOfMobileNumber.isUserInteractionEnabled = true
        allTextFieldResignResp()
        
    }
    
    @IBAction func DoneClicked(){
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
                btnofGender.setTitle("+" + strPrefix, for: .normal)
                
                let strOfmin = dicOfObj.object(forKey: getCountriesList.APIResponse.minNumberLength) as! String
                minCountryMobileNoLength = Int(strOfmin)! as NSNumber
                
            }
        }
        
        lblOfPrefix.backgroundColor = Constatns.UnSelectThemeColour()
        btnofGender.setTitle("+" + strPrefix, for: .normal)
        viewofPicker.isHidden = true
        tfOfMobileNumber.text = ""
    }
    
    func callforForgotPasswrd(){
        
        /*{"ApiKey":"OIxv03jBrOUGAKg8","userRef":"UspJ0gzXZkTdHpOL","mobilePrefix":"91","mobileNumber":"8528330637","userType":"2"}*/
        
        
       // APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
        self.showLoader()
        
        let param : [String : Any] =
            [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
             APIRequestKeys.userRef : UserDefaultStore.userRef,
             ForgotPassword.APIRequest.mobileNumber :tfOfMobileNumber.text!,
             ForgotPassword.APIRequest.mobilePrefix : strPrefix,
             ForgotPassword.APIRequest.userType : userType]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.forgotPassword, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            // print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                UserDefaultStore.mobileNumber = self.tfOfMobileNumber.text!
                UserDefaultStore.mobilePrefix = self.strPrefix
                
                
                let OTPVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                OTPVC.isNaviFromRegis = false
                self.navigationController?.pushViewController(OTPVC, animated: true)
                
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
                self.isError = "Forgot"
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        if self.isError == "Forgot"{
            callforForgotPasswrd()
        }
        
    }
    
    
    @IBAction func resetPasswordBtnAction(_ sender : Any){
        
        if strPrefix == ""{
            Utilities.sharedInstace.showAlertviewWithMessage(NSLocalizedString("please select country prefix...", comment: ""))
        }
        else if tfOfMobileNumber.text?.count == 0{
            
            let err = self.error(withLocalizedDescription: NSLocalizedString("please enter mobile number...", comment: ""))
            tfOfMobileNumber.setError(err, animated: true)
            
        } else {
            allTextFieldResignResp()
            
            APIServices.SharedInstance.invalidatePreviousRequest()
            
            if tfOfMobileNumber.text?.count == Int(truncating: minCountryMobileNoLength!){
                if viewofPicker.isHidden == false {
                    viewofPicker.isHidden = true
                }
                callforForgotPasswrd()
            }else{
                let loc = NSLocalizedString("please enter valid Mobile Number...", comment: "")
                Utilities.sharedInstace.showAlertviewWithMessage(loc)
            }
            
        }
        
        //testing....for rest password
        
        //        let OTPVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        //        OTPVC.isNaviFromRegis = false
        //        self.navigationController?.pushViewController(OTPVC, animated: true)
        
    }
    
    @IBAction func cancelBtnAction(_ sender : Any){
        allTextFieldResignResp()
        self.navigationController?.popViewController(animated: true)
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

extension ForgotViewController : UIPickerViewDataSource,UIPickerViewDelegate {
    
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




