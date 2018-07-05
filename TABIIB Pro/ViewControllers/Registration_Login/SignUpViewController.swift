//
//  SignUpViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import MaterialTextField
import CoreTelephony

class SignUpViewController: UIViewController,ErrorProtocalDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var tfOfUserName : MFTextField!
    @IBOutlet weak var tfOfEmailID : MFTextField!
    @IBOutlet weak var tfOfMobileNumber : MFTextField!
    @IBOutlet weak var tfOfPassword : MFTextField!
    @IBOutlet weak var tfOfMedicalRegsNo : MFTextField!
    @IBOutlet weak var lblOfVerifyOtpTxt : UILabel!
    
    
    //constatns
    let Gender = "Gender"
    let Prefix = "Prefix"
    
    let BahrainPrefix  = "973"
    let DubaiPrefix = "966"
    let SoudiPrefix = "971"
    let indiaPrefix = "91"
    
    let strMr = NSLocalizedString("Mr.", comment: "")
    let strMiss = NSLocalizedString("Ms.", comment: "")
    let strMrs = NSLocalizedString("Mrs.", comment: "")
    
    @IBOutlet var viewofPicker : UIView!
    @IBOutlet var pickerData : UIPickerView!
    
    @IBOutlet var btnofGender: UIButton!
    @IBOutlet var btnofPrefix : UIButton!
    var isPickerSelection : String!
    @IBOutlet var lblofGenderSelection : UILabel!
    @IBOutlet var lblofPrefixSelection : UILabel!
    @IBOutlet var lblofSelectedSpecilations : UILabel!
    
    
    //    @IBOutlet var btno
    @IBOutlet var btnofSpelization: UIButton!
    var arrofOptions : [String] = [String]()
    
    var singltonObj : SingleTonClass!
    var arrofSelectedSpecilacations : NSMutableArray!
    
    var selectedGender : String! = ""
    var selectedPrefix : String = String()
    
    var minCountryMobileNoLength : NSNumber?
    
    @IBOutlet var btnofTermsAnccondi: UIButton!
    
    @IBOutlet var btnofPrivacyPolicy: UIButton!
    
    @IBOutlet var btnofArrowIs : UIButton!
    
    var isError : String = ""
    
    var selectedPrefixPicker : String! = String()
    var isPickerSelectionDone : Bool = false
    
     var arrayOfCountries = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        singltonObj = SingleTonClass.SharedInstance
        //singltonObj.singIdentifier = "SignUpViewController"
        
        lblofGenderSelection.backgroundColor = Constatns.UnSelectThemeColour()
        lblofPrefixSelection.backgroundColor = Constatns.UnSelectThemeColour()
        
        //        tfOfEmailID.delegate = self
        //        tfOfUserName.delegate = self
        //        tfOfMobileNumber.delegate = self
        tfOfPassword.delegate = self
        tfOfMedicalRegsNo.delegate = self
        
        tfOfMobileNumber.isUserInteractionEnabled = false
        viewofPicker.isHidden = true
        
        arrofSelectedSpecilacations = NSMutableArray.init()
        
        if let loadedArrayObjs = UserDefaults.standard.array(forKey: "countries") as? [[String : Any]] {
            arrayOfCountries = loadedArrayObjs as NSArray
           
        }
        
        
        getcurrentUserisoCode()
        
        tfOfEmailID.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfOfUserName.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfOfMobileNumber.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfOfPassword.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfOfMedicalRegsNo.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        
        arrofOptions = [strMr,strMiss,strMrs]
        selectedGender = arrofOptions[0]
        btnofGender.setTitle(self.selectedGender, for: .normal)
        
        
        let attrs = [
            NSAttributedStringKey.font : Constatns.LatoRegular(10),
            NSAttributedStringKey.foregroundColor : Constatns.ThemeColour(),
            NSAttributedStringKey.underlineStyle : 1] as [NSAttributedStringKey : Any]
        
        let attributedString = NSMutableAttributedString()
        let strTAndC = NSLocalizedString("T & C", comment: "")
        
        let buttonTitleStr = NSMutableAttributedString(string:strTAndC, attributes:attrs)
        attributedString.append(buttonTitleStr)
        btnofTermsAnccondi.setAttributedTitle(attributedString, for: .normal)
        
        
        
        let attributedString2 = NSMutableAttributedString()
        let strPrivacyPoli = NSLocalizedString("PRIVACY POLICY", comment: "")
        
        let buttonTitleStr2 = NSMutableAttributedString(string:strPrivacyPoli, attributes:attrs)
        attributedString2.append(buttonTitleStr2)
        btnofPrivacyPolicy.setAttributedTitle(attributedString2, for: .normal)
        
        if UserDefaultStore.selectedLanguage == "1" {
            //arabic
            btnofArrowIs.setImage(UIImage.init(named: "Back"), for: .normal)
        }
        //        else{
        //            //english
        //            btnofArrowIs.setImage(UIImage.init(named: "Back"), for: .normal)
        //
        //        }
        
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
        tfOfMobileNumber.inputAccessoryView = numberToolbar
        
    }
    @objc func doneClicked(){
        if tfOfMobileNumber.isFirstResponder{
            tfOfMobileNumber.resignFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        
        let email = NSLocalizedString("Email ID", comment: "")
        let password = NSLocalizedString("Password", comment: "")
        let mobile = NSLocalizedString("Mobile Number", comment: "")
        let user = NSLocalizedString("Name", comment: "")
        let medical = NSLocalizedString("Medical Registration Number", comment: "")
        
        
        tfOfEmailID.placeholder = email
        tfOfPassword.placeholder = password
        tfOfUserName.placeholder = user
        tfOfMobileNumber.placeholder = mobile
        tfOfMedicalRegsNo.placeholder = medical
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        tfOfEmailID.resignFirstResponder()
        tfOfPassword.resignFirstResponder()
        tfOfUserName.resignFirstResponder()
        tfOfMobileNumber.resignFirstResponder()
        tfOfMedicalRegsNo.resignFirstResponder()
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
                    
                    selectedPrefix = (dicofCountry.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.PhoneCode))
                    selectedPrefixPicker = selectedPrefix
                    
                    btnofPrefix.setTitle("+" + selectedPrefix, for: .normal)
                    
                    let strOfmin = dicofCountry.object(forKey: getCountriesList.APIResponse.minNumberLength) as! String
                    minCountryMobileNoLength = Int(strOfmin)! as NSNumber
                    tfOfMobileNumber.isUserInteractionEnabled = true
                    
                    break
                    
                }
            }
            
            APIServices.SharedInstance.invalidatePreviousRequest()
            docSpecialisationAPI()
            
            
        }else{
            
            
            APIServices.SharedInstance.invalidatePreviousRequest()
            docSpecialisationAPI()
            tfOfMobileNumber.isUserInteractionEnabled = false
            let country = NSLocalizedString("Please insert SIM Card...", comment: "")
            
            
            Utilities.sharedInstace.showAlertviewWithMessage(country)
            
        }
    }
    
    
    
    @objc func validTxt(_ text : UITextField){
        self.validateTextField(text: text)
    }
    
    func error(withLocalizedDescription localizedDescription: String) -> Error? {
        let userInfo = [NSLocalizedDescriptionKey: localizedDescription]
        return NSError(domain: MFDemoErrorDomain as? String ?? "", code: Int(MFDemoErrorCode), userInfo: userInfo)
    }
    
    func validateTextField(text : UITextField) {
        var error: Error? = nil
        
        if text == tfOfUserName{
            if !textFielduserName() {
                let errStr = NSLocalizedString("please enter Name...", comment: "")
                error = self.error(withLocalizedDescription: errStr)
            }
            tfOfUserName.setError(error, animated: true)
        }else if text == tfOfMobileNumber{
            if !textFieldMobileNumber() {
                
                let errStr = NSLocalizedString("please enter mobile number...", comment: "")
                error = self.error(withLocalizedDescription: errStr)
                lblOfVerifyOtpTxt.isHidden = true
            }
            if error == nil {
                lblOfVerifyOtpTxt.isHidden = false
            }
            
            tfOfMobileNumber.setError(error, animated: true)
        }
        else if text == tfOfPassword{
            
            if !textpass() {
                
                let errStr = NSLocalizedString("Password length must have at least 6 character !!..", comment: "")
                error = self.error(withLocalizedDescription: errStr)
                
            }
            //            else{
            //                if !textFieldPassword() {
            //
            //                    let alert = UIAlertController(title: "", message: "Passwords should be atleast one capital,numeric and small letters", preferredStyle: UIAlertControllerStyle.alert)
            //                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            //                    self.present(alert, animated: true, completion: nil)
            //
            //                }
            tfOfPassword.setError(error, animated: true)
            //            }
            
        }else if text == tfOfEmailID{
            if !textFeiledEmail() {
                let errStr = NSLocalizedString("please enter valid Email id...", comment: "")
                error = self.error(withLocalizedDescription: errStr)
            }
            tfOfEmailID.setError(error, animated: true)
        }else if text == tfOfMedicalRegsNo{
            
            if !textFieldMedicalRegNo() {
                let errStr = NSLocalizedString("please enter valid Medical Registration number...", comment: "")
                error = self.error(withLocalizedDescription: errStr)
            }
            tfOfMedicalRegsNo.setError(error, animated: true)
        }
        
    }
    
    func textFieldMedicalRegNo()->Bool{
        return (tfOfMedicalRegsNo.text?.count)! > 0
    }
    
    func textFielduserName() -> Bool {
        return (tfOfUserName.text?.count)! > 0
    }
    func textFieldMobileNumber() -> Bool {
        
        //        let stringReplace = btnofPrefix.currentTitle?.replacingOccurrences(of: "+", with: "")
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
        
        // if selectedPrefix == dicOfObj.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.PhoneCode){
        //            if  {
        return (tfOfMobileNumber.text?.count)! == Int(truncating: minCountryMobileNoLength!)
        //            }else{
        //                return true
        //            }
        //            return (tfOfMobileNumber.text?.count)! <= Int(truncating: minCountryMobileNoLength!)
        //        }else{
        //            return false
        //        }
    }
    
    func textpass() -> Bool{
        return (tfOfPassword.text?.count)! > 0
    }
    
    
    func textFieldPassword() -> Bool {
        
        let boolValue = Utilities.sharedInstace.isValidPassword(candidate: tfOfPassword.text!)
        return boolValue
        
    }
    
    func textFeiledEmail()-> Bool{
        let boolValue = Utilities.sharedInstace.validateEmail(emailAddress: tfOfEmailID.text!)
        return boolValue
    }
    
    
    
    func signUpAPI(){
        
        if UserDefaultStore.checkMedicalNumber == nil{
            UserDefaultStore.checkMedicalNumber = ""
        }
        
        
        var gender : String! = ""
        if String(describing:btnofGender.titleLabel?.text) == strMr {
            gender = "male"
        }
        else {
            gender = "female"
        }
        var strNamePrefix = "Mr."
        if selectedGender == arrofOptions[0] {
            strNamePrefix = "Mr."
        }else if selectedGender == arrofOptions[1] {
            strNamePrefix = "Ms."
        }else if selectedGender == arrofOptions[2] {
            strNamePrefix = "Mrs."
        }
        
//        strPrefix = btnOfPrefix.currentTitle!
//        strPrefix = strPrefix.replacingOccurrences(of: "+", with: "")
        
        let para : [String:Any] = [Registration.APIRequest.namePrefix: strNamePrefix,
                                   Registration.APIRequest.Name:tfOfUserName.text!,
                                   Registration.APIRequest.mobilePrefix:selectedPrefix,
                                   Registration.APIRequest.mobileNumber:tfOfMobileNumber.text!,
                                   Registration.APIRequest.emailId:tfOfEmailID.text!,
                                   Registration.APIRequest.password:tfOfPassword.text!,
                                   Registration.APIRequest.userType:userType,
                                   Registration.APIRequest.ApiKey:UserDefaultStore.ApiKey,
                                   Registration.APIRequest.userRef:UserDefaultStore.userRef,
                                   Registration.APIRequest.userGender:gender,
                                   Registration.APIRequest.sepcialId : getRequestSpecilaztions(arrofSelectedSpecilacations),
                                   Registration.APIRequest.medicalRegNo:tfOfMedicalRegsNo.text!,
                                   Registration.APIRequest.prevUserRef : UserDefaultStore.checkMedicalNumber!
        ]
        
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.userRegister, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: para, success: { (response) in
            
            
            //     print(response)
            APIServices.SharedInstance.hideProgress()
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                UserDefaultStore.password = self.tfOfPassword.text!
                UserDefaultStore.emailId = self.tfOfEmailID.text!
                UserDefaultStore.mobileNumber = self.tfOfMobileNumber.text!
                UserDefaultStore.mobilePrefix = self.selectedPrefix
                UserDefaultStore.checkMedicalNumber = dictofResonse.TabiibDocObjectForKey(forKey: Registration.APIResponse.NewuserRef)
                
                //navigate to OTP Vc
                let otpvc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                otpvc.isNaviFromRegis = true
                self.navigationController?.pushViewController(otpvc, animated: true)
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
                self.isError = "signup"
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        if self.isError == "signup"{
            signUpAPI()
        }else{
            docSpecialisationAPI()
        }
        
    }
    
    
    //MARK:- Doctor Specialization api
    func docSpecialisationAPI()
        
    {
        
        // APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.docSpecialization, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //  print(response)
            
            // let success = (JSONDictionary as AnyObject).value(forKey:"success") as! String
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                let arrofSpelicartions = dictofResonse.object(forKey: DocSpecialisations.APIResponse.data) as! NSArray
                
                self.singltonObj.arrofSpecilazations = NSMutableArray.init(array: arrofSpelicartions)
                
                // self.arrofSpecilazations =
                
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
                self.isError = "docspec"
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnAction(_ sender : Any){
        resingAllTextFields()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func resingAllTextFields(){
        
        if tfOfMobileNumber.isFirstResponder{
            tfOfMobileNumber.resignFirstResponder()
        }else if tfOfPassword.isFirstResponder{
            tfOfPassword.resignFirstResponder()
        }else if tfOfEmailID.isFirstResponder{
            tfOfEmailID.resignFirstResponder()
        }else if tfOfUserName.isFirstResponder{
            tfOfUserName.resignFirstResponder()
        }else if tfOfMedicalRegsNo.isFirstResponder{
            tfOfMedicalRegsNo.resignFirstResponder()
        }
        
    }
    
    @IBAction func surNamePrefixBtnAction(_ sender : Any){
        
        isPickerSelection = Gender
        arrofOptions.removeAll()
        arrofOptions = [strMr,strMiss,strMrs]
        selectedGender = arrofOptions[0]
        pickerData.reloadAllComponents()
        viewofPicker.isHidden = false
        lblofGenderSelection.backgroundColor = Constatns.ThemeColour()
        
        resingAllTextFields()
        
    }
    
    @IBAction func mobileNumberPrefixBtnAction(_ sender : Any){
        
        isPickerSelection = Prefix
        arrofOptions.removeAll()
        
        if let loadedArrayObjs = UserDefaults.standard.array(forKey: "countries") as? [[String : Any]] {
           
            for item in 0 ..< loadedArrayObjs.count {
                let dic = loadedArrayObjs[item] as NSDictionary
                let strOfPhoneCode = dic.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.PhoneCode)
                arrofOptions.append(strOfPhoneCode)
            }
        }
        
        tfOfMobileNumber.isUserInteractionEnabled = true
        //  selectedPrefix = arrofOptions[0]
        pickerData.reloadAllComponents()
        viewofPicker.isHidden = false
        lblofPrefixSelection.backgroundColor = Constatns.ThemeColour()
        
        resingAllTextFields()
        
    }
    
    @IBAction func btnOfSpelicationClicked(_ sender: Any) {
        resingAllTextFields()
        let spelicationVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "SpelizationSelectionViewController") as! SpelizationSelectionViewController
        if arrofSelectedSpecilacations.count > 0 {
            spelicationVc.arrofCopyofSelctedSpeci  = arrofSelectedSpecilacations
        }
        spelicationVc.delegate = self
        self.navigationController?.pushViewController(spelicationVc, animated: true)
        
    }
    
    
    func validateInputs() -> Bool {
        
        var isValid = true
        
        let tfOfUser = self.tfOfUserName.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfOfEmail = self.tfOfEmailID.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfOfMobile = self.tfOfMobileNumber.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfOfPass = self.tfOfPassword.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfOfMedical = self.tfOfMedicalRegsNo.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if tfOfUser?.count == 0 {
            isValid = false
            let err = self.error(withLocalizedDescription: NSLocalizedString("please enter Name...", comment: ""))
            tfOfUserName.setError(err, animated: true)
        }
        else if tfOfEmail?.count == 0 {
            isValid = false
            let err = self.error(withLocalizedDescription: NSLocalizedString("please enter email Id...", comment: ""))
            tfOfEmailID.setError(err, animated: true)
        }
        else if Utilities.sharedInstace.validateEmail(emailAddress: tfOfEmailID.text!) == false {
            isValid = false
            let err = self.error(withLocalizedDescription: NSLocalizedString("please enter valid Email id...", comment: ""))
            tfOfEmailID.setError(err, animated: true)
        }else if tfOfMobile?.count == 0 {
            isValid = false
            let err = self.error(withLocalizedDescription: NSLocalizedString("please enter mobile number...", comment: ""))
            lblOfVerifyOtpTxt.isHidden = true
            tfOfMobileNumber.setError(err, animated: true)
        }
        else if tfOfMobile?.count != 0 {
            var error: Error? = nil
            if !textFieldMobileNumber() {
                isValid = false
                let errStr = NSLocalizedString("please enter mobile number...", comment: "")
                error = self.error(withLocalizedDescription: errStr)
                lblOfVerifyOtpTxt.isHidden = true
                tfOfMobileNumber.setError(error, animated: true)
            }else{
                if tfOfPass?.count == 0 {
                    isValid = false
                    let err = self.error(withLocalizedDescription: NSLocalizedString("please enter password...", comment: ""))
                    tfOfPassword.setError(err, animated: true)
                }else if (tfOfPassword.text?.count)! < 6{
                    isValid = false
                    let alert = UIAlertController(title: "", message: NSLocalizedString("Password length must have at least 6 character !!..", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment : ""), style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else if Utilities.sharedInstace.isValidPassword(candidate: tfOfPassword.text!) == false {
                    isValid = false
                    let alert = UIAlertController(title: "", message: NSLocalizedString("Password should be atleast one capital,numeric,small letters...", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment : ""), style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else if arrofSelectedSpecilacations.count == 0 {
                    isValid = false
                    Utilities.sharedInstace.showAlertviewWithMessage(NSLocalizedString("Select atleast one specialization", comment: ""))
                }else if tfOfMedical?.count == 0{
                    isValid = false
                    let err = self.error(withLocalizedDescription: NSLocalizedString("please enter medical registration number...", comment: ""))
                    tfOfMedicalRegsNo.setError(err, animated: true)
                }
            }
            //            lblOfVerifyOtpTxt.isHidden = false
            
        }
        //        else if tfOfPass?.count == 0 {
        //            isValid = false
        //            let err = self.error(withLocalizedDescription: "please enter password...")
        //            tfOfPassword.setError(err, animated: true)
        //        }else if Utilities.sharedInstace.isValidPassword(candidate: tfOfPassword.text!) == false {
        //            isValid = false
        //            let err = self.error(withLocalizedDescription: "please enter valid  password...")
        //            tfOfPassword.setError(err, animated: true)
        //        }else if arrofSelectedSpecilacations.count == 0 {
        //            isValid = false
        //            Utilities.sharedInstace.showAlertviewWithMessage("Select atleast one specialization")
        //        }else if tfOfMedical?.count == 0{
        //            isValid = false
        //            let err = self.error(withLocalizedDescription: "please enter Medical registration Number...")
        //            tfOfMedicalRegsNo.setError(err, animated: true)
        //        }
        
        return isValid
        
        
    }
    
    @IBAction func createAccountBtnAction(_ sender : Any){
        
        //   DispatchQueue.main.sync {
        resingAllTextFields()
        if viewofPicker.isHidden == false {
            viewofPicker.isHidden = true
        }
        if validateInputs() {
            
            signUpAPI()
        }
        // }
    }
    
    @IBAction func signInBtnAction(_ sender : Any){
        resingAllTextFields()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func termsAndPrivacyBtnAction(_ sender : Any){
        
        resingAllTextFields()
        let loadVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LoadWebViewController") as! LoadWebViewController
        loadVc.viewtoLoad = "2"
        self.navigationController?.pushViewController(loadVc, animated: true)
    }
    
    @IBAction func termsAndConditionsAction(_ sender : Any){
        
        resingAllTextFields()
        let loadVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LoadWebViewController") as! LoadWebViewController
        loadVc.viewtoLoad = "3"
        self.navigationController?.pushViewController(loadVc, animated: true)
        
    }
    
    
    
    @IBAction func btnDoneinPickerClicked(_ sender : Any) {
        
        viewofPicker.isHidden = true
        if  isPickerSelection == Prefix {
            
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
                    
                    selectedPrefix = dicOfObj.TabiibDocObjectForKey(forKey:  getCountriesList.APIResponse.PhoneCode)
                    btnofPrefix.setTitle("+" + selectedPrefix, for: .normal)
                    
                    let strOfmin = dicOfObj.object(forKey: getCountriesList.APIResponse.minNumberLength) as! String
                    minCountryMobileNoLength = Int(strOfmin)! as NSNumber
                    
                }
            }
            
            lblofPrefixSelection.backgroundColor = Constatns.UnSelectThemeColour()
            btnofPrefix.setTitle("+" + self.selectedPrefix, for: .normal)
            tfOfMobileNumber.text = ""
            //             if (tfOfMobileNumber.text?.count)! > Int(truncating: minCountryMobileNoLength!) {
            //                let struserMobileNumer = String(describing: tfOfMobileNumber.text!)
            //                let newindex = struserMobileNumer.index(struserMobileNumer.startIndex, offsetBy: minCountryMobileNoLength as! String.IndexDistance)
            //                tfOfMobileNumber.text = struserMobileNumer.substring(to: newindex)
            //            }
            
            //            if !textFieldMobileNumber() {
            //
            //                let errStr = NSLocalizedString("please enter valid Mobile Number...", comment: "")
            //                let  error = self.error(withLocalizedDescription: errStr)
            //                tfOfMobileNumber.setError(error, animated: true)
            //                lblOfVerifyOtpTxt.isHidden = true
            //            }
            
        }else{
            lblofGenderSelection.backgroundColor = Constatns.UnSelectThemeColour()
            btnofGender.setTitle(self.selectedGender, for: .normal)
        }
        
    }
    
    @IBAction func BtnCancelinPickerClicked(_ sender : Any){
        
        viewofPicker.isHidden = true
        if  isPickerSelection == Prefix {
            lblofPrefixSelection.backgroundColor = Constatns.UnSelectThemeColour()
            
        }else{
            lblofGenderSelection.backgroundColor = Constatns.UnSelectThemeColour()
            
        }
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        viewofPicker.isHidden = true
        if textField == tfOfMedicalRegsNo {
            animateViewMoving(up: true, moveValue: 100)
        }
    }
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == tfOfMedicalRegsNo {
            animateViewMoving(up: false, moveValue: 100)
        }
        
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
        if textField == tfOfPassword {
            
            let currentCharacterCount = textField.text?.count ?? 0
            
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            
            return newLength <= Int(truncating: 10)
            
        }
        
        if textField == tfOfUserName {
            
            let currentCharacterCount = textField.text?.count ?? 0
            
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            
            return newLength <= Int(truncating: 25)
            
        }
        return true
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
extension SignUpViewController : UIPickerViewDataSource,UIPickerViewDelegate {
    
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
        
        if isPickerSelection == Gender {
            self.selectedGender = arrofOptions[row]
        }
        else if isPickerSelection == Prefix {
            isPickerSelectionDone = true
            self.selectedPrefixPicker = arrofOptions[row]
        }
    }
}

extension SignUpViewController : SpelicilationsSelected {
    
    func getRequestSpecilaztions(_ arrofSelectedOnes : NSMutableArray) -> NSMutableArray {
        
        let arrofSelecteOnes = NSMutableArray.init()
        
        for case let dictofOb as NSDictionary in arrofSelectedOnes {
            let dictofobje = NSMutableDictionary.init()
            dictofobje.setValue(String(describing:dictofOb.TabiibDocObjectForKey(forKey: DocSpecialisations.APIResponse.spId)), forKey: Registration.APIRequest.sepcialId)
            arrofSelecteOnes.add(dictofobje)
        }
        return arrofSelecteOnes
    }
    
    
    func getSpecilazionNames(_ arrofSelectedOnes : NSMutableArray)  -> String {
        
        var strofnSpecioaltions : String! = ""
        
        for case let dictofOb as NSDictionary in arrofSelectedOnes {
            strofnSpecioaltions.append( String(describing:dictofOb.TabiibDocObjectForKey(forKey: DocSpecialisations.APIResponse.spName)))
            strofnSpecioaltions.append(",")
        }
        let finalStrng = String(strofnSpecioaltions.dropLast())
        
        return finalStrng
        
    }
    
    func getFirst2Specialtionname(_ arrofSelectedOnces : NSMutableArray) -> String {
        
        var strofSelecteOnces : String! = ""
        
        if arrofSelectedOnces.count > 2 {
            var strofSelecteOnces2 : String! = ""
            
            for i in 0...1 {
                let dicotfObj = arrofSelectedOnces[i] as! NSDictionary
                strofSelecteOnces2.append( String(describing:dicotfObj.TabiibDocObjectForKey(forKey: DocSpecialisations.APIResponse.spName)))
                strofSelecteOnces2.append(",")
                
            }
            let finalStrng = String(strofSelecteOnces2.dropLast())
            let remainingString = String.init(format: "%d more", arrofSelectedOnces.count - 2)
            
            strofSelecteOnces.append(finalStrng)
            strofSelecteOnces.append(" ")
            strofSelecteOnces.append(remainingString)
            
        }
        
        
        return strofSelecteOnces
        
    }
    
    
    func selectedSpecilations(_ arrofSpecialicatos : NSMutableArray){
        
        arrofSelectedSpecilacations.removeAllObjects()
        arrofSelectedSpecilacations.addObjects(from: arrofSpecialicatos as! [Any])
        
        if arrofSpecialicatos.count > 2 {
            let strofname = getFirst2Specialtionname(arrofSpecialicatos)
            lblofSelectedSpecilations.text = strofname
            self.btnofSpelization.setTitle("", for: .normal)
        }
        else{
            let strofName = getSpecilazionNames(arrofSpecialicatos)
            lblofSelectedSpecilations.text = strofName
            self.btnofSpelization.setTitle("", for: .normal)
        }
    }
}






