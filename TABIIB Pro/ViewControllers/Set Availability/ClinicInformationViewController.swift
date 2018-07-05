//
//  ClinicInformationViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import MaterialTextField
import CoreTelephony
import GooglePlaces


typealias DuplicateClinicResponse = (_ dictofResponse : NSDictionary) -> Void

protocol ClininInfoUpdateDelegate {
    
    func proccedClicked(_ dictOfClinicInfo : NSDictionary)
    
    func backtoAddclinc()
    
    //    func proccedClicked(_ hospitalRef : String)
}



class ClinicInformationViewController: UIViewController,ErrorProtocalDelegate,ClininInfoUpdateDelegate,UITextFieldDelegate {
    
    //    func proccedClicked(_ hospitalRef: String) {
    //
    //    }
    
    func backtoAddclinc(){
        
    }
    
    func proccedClicked(_ dictOfClinicInfo: NSDictionary) {
        
    }
    
    @IBOutlet var scrollofContent : UIScrollView!
    
    @IBOutlet var tfofClinicName: MFTextField!
    @IBOutlet var tfofClinicBranch: MFTextField!
    @IBOutlet var tfofMobileNumber: MFTextField!
    @IBOutlet var tfofEmailId: MFTextField!
    @IBOutlet var tfofAddress: MFTextField!
    @IBOutlet var tfofZipCode: MFTextField!
    @IBOutlet var btnAllDays: UIButton!
    @IBOutlet var btnWeekDays: UIButton!
    @IBOutlet var collectionofWeekDays: UICollectionView!
    @IBOutlet var btnofStartTime: UIButton!
    @IBOutlet var btnofEndTime: UIButton!
    @IBOutlet var viewofTimePicker: UIView!
    @IBOutlet var startTimePicker: UIDatePicker!
    @IBOutlet var endTimePicker: UIDatePicker!
    @IBOutlet var topSpaceFromView: NSLayoutConstraint!
    
    @IBOutlet var viewOfCollection : UIView!
    
    
    //    let BahrainPrefix  = "973"
    //    let DubaiPrefix = "966"
    //    let SoudiPrefix = "971"
    //    let indiaPrefix = "91"
    
    @IBOutlet var btnofPrefix : UIButton!
    @IBOutlet var viewofPrefix : UIView!
    @IBOutlet var prefixPicker: UIPickerView!
    @IBOutlet var dupliActivityIndicator : UIActivityIndicatorView!
    
    @IBOutlet var lblOfIVRInfor : UILabel!
    @IBOutlet var lblofPrefixSelection : UILabel!
    
    var delegate : ClininInfoUpdateDelegate!
    
    var strSeletedPrefix : String = String()
    var strSelectedTime : String! = ""
    var arrofWeekDays : [String] = [String]()
    var arrofRequestWeekDays : NSMutableArray!
    var arrofSelectedDays : NSMutableArray!
    
    var isFromExistingOne : Bool = false
    var dicotfClinincTimings : NSDictionary!
    var arrofOptions : [String] = [String]()
    
    var selectedStartTime : String! = ""
    var selectedEndTime : String! = ""
    var selectedWeekDays : String! = ""
    let clinicSearchApiQueue = DispatchGroup()
    var isRequestingforDupli : Bool = false
    var strofHospitalRef : String! = ""
    
    var ifWecanEdit : Bool = false
    
    var duplicateBool : Bool = false
    var btnAllDaysBool : Bool = false
    var btnWeekDaysBool : Bool = false
    //  var showWeekDaysCollection : Bool = false
    // var isfromExistingBoolValue : Bool = false
    
    let sun = NSLocalizedString("Sun", comment: "")
    let Mon = NSLocalizedString("Mon", comment: "")
    let Tue = NSLocalizedString("Tue", comment: "")
    let Wed = NSLocalizedString("Wed", comment: "")
    let Thu = NSLocalizedString("Thu", comment: "")
    let Fri = NSLocalizedString("Fri", comment: "")
    let Sat = NSLocalizedString("Sat", comment: "")
    
    
    var singltonObj : SingleTonClass!
    
    var minCountryMobileNoLength : NSNumber?
    var dicOfObj = NSDictionary()
    var specialChar : Bool = false
    
    var isAlertShowforClinincName : Bool = false
    
    var tapGestureRecogniser : UITapGestureRecognizer!
    
    var isApiRequested : Bool = false
    var strofCountryName : String! = ""
    
    var strofClinincLatitude : String! = ""
    var strofClinincLongitude : String! = ""
    var isError : String = ""

    var selectedPrefixPicker : String! = String()
    var isPickerSelectionDone : Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singltonObj = SingleTonClass.SharedInstance
        
        lblOfIVRInfor.isHidden = false
        arrofRequestWeekDays = NSMutableArray.init()
        
        arrofWeekDays = [sun,Mon,Tue,Wed,Thu,Fri,Sat]
        
        btnofPrefix.isUserInteractionEnabled = false
        
        //   getcurrentUserisoCode()
        
        strSeletedPrefix = UserDefaultStore.mobilePrefix!
        selectedPrefixPicker = strSeletedPrefix
        
        tapGestureRecogniser = UITapGestureRecognizer.init(target: self, action: #selector(tapOnOutsideofView(_:)))
        tapGestureRecogniser.numberOfTapsRequired = 1
        tapGestureRecogniser.numberOfTouchesRequired = 1
        tapGestureRecogniser.cancelsTouchesInView = false
        scrollofContent.addGestureRecognizer(tapGestureRecogniser)
        
        if UserDefaultStore.selectedLanguage == "1" {
            startTimePicker.locale = NSLocale.init(localeIdentifier: "ar") as Locale
            endTimePicker.locale = NSLocale.init(localeIdentifier: "ar") as Locale
            
        }else{
            startTimePicker.locale = NSLocale.init(localeIdentifier: "en") as Locale
            endTimePicker.locale = NSLocale.init(localeIdentifier: "en") as Locale
        }
        
        
        
        
        viewofTimePicker.isHidden = true
        viewofPrefix.isHidden = true
        dupliActivityIndicator.isHidden = true
        
        lblofPrefixSelection.backgroundColor = Constatns.UnSelectThemeColour()
        
        //for testing
        //        strSeletedPrefix = "91"
        
        //default set Alldays Selected
        viewOfCollection.isHidden = true
        topSpaceFromView.constant = 10
        
        allDaysClicked()
        
        
        tfofAddress.addTarget(self, action: #selector(tfofAddressChanged(_:)), for: UIControlEvents.allEditingEvents)
        
        
        //        tfofAddress.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfofEmailId.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfofZipCode.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfofClinicName.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfofClinicBranch.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfofMobileNumber.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        
        tfofClinicBranch.addTarget(self, action: #selector(tockecinExistingClinic(_:)), for: UIControlEvents.editingChanged)
        tfofClinicName.addTarget(self, action: #selector(tockecinExistingClinicname(_:)), for: UIControlEvents.editingChanged)
        
        
        
        
        callAllTextFieldDelegates()
        toolbaraddedtoKeyboard()
        
        
    }
    
    @objc func tfofAddressChanged(_ text : UITextField){
        
        
        let autoCom = GMSAutocompleteViewController()
        autoCom.delegate = self
        self.present(autoCom, animated: true, completion: nil)
        
    }
    
//    func getcurrentUserisoCode(){
//
//        let networkInfp = CTTelephonyNetworkInfo.init()
//        let carrierIs   = networkInfp.subscriberCellularProvider
//
//        //let arrofCountryCodes : NSArray = NSArray.init(contentsOfFile: NSBundle.mainBundle().pathForResource("CountryCodes", ofType: "plist")!)!
//        if carrierIs != nil{
//
//            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
//
//                let str = countryCode.uppercased()
//                let pre = NSPredicate(format: "\(getCountriesList.APIResponse.ShortName) = %@","\(str)")
//
//                if let loadedArrayObjs = UserDefaults.standard.array(forKey: "countries"){
//
//                    let arrOfmutable = NSMutableArray()
//
//                    for i in 0 ..< loadedArrayObjs.count {
//
//                        let dic = loadedArrayObjs[i] as! NSDictionary
//                        arrOfmutable.add(dic)
//                    }
//
//                    let arr = arrOfmutable.filtered(using: pre)
//
//                    if arr.count > 0{
//
//                        let dicOfObj = arr[0] as! NSDictionary
//
//                        strSeletedPrefix = dicOfObj.TabiibDocObjectForKey(forKey:  getCountriesList.APIResponse.PhoneCode)
//                        btnofPrefix.setTitle("+" + strSeletedPrefix, for: .normal)
//
//                        let strOfmin = dicOfObj.object(forKey: getCountriesList.APIResponse.minNumberLength) as! String
//                        minCountryMobileNoLength = Int(strOfmin)! as NSNumber
//                        tfofMobileNumber.isUserInteractionEnabled = true
//
//                    }else{
//                        Utilities.sharedInstace.showAlertviewWithMessage(NSLocalizedString("Something went to wrong", comment: ""))
//                    }
//                }
//
//            }
//
//        }
//    }
//
    
    @objc func tapOnOutsideofView(_ gesture : UITapGestureRecognizer){
        
        allTextFieldResignResp()
        
    }
    
    
    func callAllTextFieldDelegates(){
        
        tfofClinicBranch.delegate = self
        tfofClinicName.delegate = self
        tfofZipCode.delegate = self
        tfofEmailId.delegate = self
        tfofAddress.delegate = self
        tfofMobileNumber.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let clinBrnach = NSLocalizedString("Clinic Branch Name", comment: "")
        let Address = NSLocalizedString("Address", comment: "")
        let email = NSLocalizedString("Email ID", comment: "")
        let zipcode = NSLocalizedString("Pincode/Zipcode", comment: "")
        let clinName = NSLocalizedString("Clinic Name", comment: "")
        let mobile = NSLocalizedString("Mobile Number", comment: "")
        
        
        tfofClinicBranch.placeholder = clinBrnach
        tfofClinicName.placeholder = clinName
        tfofZipCode.placeholder = zipcode
        tfofEmailId.placeholder = email
        tfofAddress.placeholder = Address
        tfofMobileNumber.placeholder = mobile
        
    }
    
    func toolbaraddedtoKeyboard(){
        let numberToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            
            
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(doneClicked)),
            
        ]
        numberToolbar.sizeToFit()
        tfofMobileNumber.inputAccessoryView = numberToolbar
        
        tfofZipCode.inputAccessoryView = numberToolbar
        
    }
    @objc func doneClicked(){
        if tfofMobileNumber.isFirstResponder{
            tfofMobileNumber.resignFirstResponder()
        }else if tfofZipCode.isFirstResponder{
            tfofZipCode.resignFirstResponder()
        }
    }
    
    func allTextFieldResignResp(){
        
        if tfofAddress.isFirstResponder{
            tfofAddress.resignFirstResponder()
        }else if tfofEmailId.isFirstResponder{
            tfofEmailId.resignFirstResponder()
        }else if tfofZipCode.isFirstResponder{
            tfofZipCode.resignFirstResponder()
        }else if tfofClinicName.isFirstResponder{
            tfofClinicName.resignFirstResponder()
        }else if tfofClinicBranch.isFirstResponder{
            tfofClinicBranch.resignFirstResponder()
        }else if tfofMobileNumber.isFirstResponder{
            tfofMobileNumber.resignFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfofMobileNumber.resignFirstResponder()
        tfofAddress.resignFirstResponder()
        tfofEmailId.resignFirstResponder()
        tfofZipCode.resignFirstResponder()
        tfofClinicName.resignFirstResponder()
        tfofClinicBranch.resignFirstResponder()
        
    }
    
    @objc func tockecinExistingClinicname(_ text : UITextField){
        
        if viewofTimePicker.isHidden == false {
            viewofTimePicker.isHidden = true
        }
        
        if viewofPrefix.isHidden == false {
            viewofPrefix.isHidden = true
        }
        
        if tfofClinicBranch.text!.isEmpty == false {
            
            
            if (tfofClinicName.text!.isEmpty) {
                
                if isAlertShowforClinincName == false {
                    
                    let serv = NSLocalizedString("First Enter Clinic Name", comment: "")
                    
                    Utilities.sharedInstace.showAlertviewWithMessage(serv)
                    
                    isAlertShowforClinincName = true
                    
                }
                
            }else{
                
                
                
                isAlertShowforClinincName = false
                
                if !(text.text!.isEmpty) {
                    
                    isRequestingforDupli = true
                    
                    callforCheckDulicateClinics(success: { (responsedict) in
                        
                        //   print(responsedict)
                        
                        self.isRequestingforDupli = false
                        
                        let responseData = responsedict.object(forKey: checkDuplicateClinic.APIResponse.data) as! NSArray
                        
                        if responseData.count > 0 {
                            
                            // print("clininc already exist ")
                            
                            
                            
                            self.duplicateBool = true
                            
                            
                            
                            var error: Error? = nil
                            
                            let serv = NSLocalizedString("Clinic Already existed,search for it", comment: "")
                            
                            error = self.error(withLocalizedDescription: serv)
                            
                            self.tfofClinicBranch.setError(error, animated: true)
                            
                        }
                            
                        else{
                            
                            self.tfofClinicBranch.setError(nil, animated: true)
                            
                            self.duplicateBool = false
                            
                            
                            
                        }
                        
                    })
                    
                }
                
                
                
            }
            
        }
        
    }
    
    
    @objc func tockecinExistingClinic(_ text : UITextField){
        
        if viewofTimePicker.isHidden == false {
            viewofTimePicker.isHidden = true
        }
        if viewofPrefix.isHidden == false {
            viewofPrefix.isHidden = true
        }
        
        if (tfofClinicName.text!.isEmpty) {
            
            
            if isAlertShowforClinincName == false {
                
                
                self.isAlertShowforClinincName = true
                
                let serv = NSLocalizedString("First Enter Clinic Name", comment: "")
                let objofSweetAlrt = SweetAlerts()
                objofSweetAlrt.isTapGestureReg = false
                _ =  objofSweetAlrt.showAlert(serv, style: .none, buttonTitle: NSLocalizedString("Okay", comment : ""), action: { (okay) in
                    
                    self.isAlertShowforClinincName = false
                    
                })
            }
            
            
        }else{
            
            
            
            if !(text.text!.isEmpty) {
                isRequestingforDupli = true
                callforCheckDulicateClinics(success: { (responsedict) in
                    //  print(responsedict)
                    self.isRequestingforDupli = false
                    let responseData = responsedict.object(forKey: checkDuplicateClinic.APIResponse.data) as! NSArray
                    if responseData.count > 0 {
                        //   print("clininc already exist ")
                        
                        self.duplicateBool = true
                        
                        var error: Error? = nil
                        let serv = NSLocalizedString("Clinic Already existed,search for it", comment: "")
                        error = self.error(withLocalizedDescription: serv)
                        self.tfofClinicBranch.setError(error, animated: true)
                    }
                    else{
                        self.duplicateBool = false
                    }
                })
            }
            
        }
    }
    
    
    @objc func validTxt(_ text : UITextField){
        
        if viewofPrefix.isHidden == false {
            viewofPrefix.isHidden = true
        }
        
        if viewofTimePicker.isHidden == false {
            viewofTimePicker.isHidden = true
        }
        
        
        
        if text == tfofAddress || text == tfofEmailId || text == tfofZipCode || text == tfofClinicName || text == tfofClinicBranch || text == tfofMobileNumber {
            if viewofTimePicker.isHidden == false {
                viewofTimePicker.isHidden = true
            }
            if viewofPrefix.isHidden == false {
                viewofPrefix.isHidden = true
            }
            self.validateTextField1(text: text)
        }
        
    }
    //
    func error(withLocalizedDescription localizedDescription: String) -> Error? {
        let userInfo = [NSLocalizedDescriptionKey: localizedDescription]
        return NSError(domain: MFDemoErrorDomain as? String ?? "", code: Int(MFDemoErrorCode), userInfo: userInfo)
    }
    
    func validateTextField1(text : UITextField) {
        var error: Error? = nil
        
        if text == tfofClinicName{
            if !textField4IsValid() {
                let err = NSLocalizedString("please enter clinic name...", comment: "")
                error = self.error(withLocalizedDescription: err)
            }
            tfofClinicName.setError(error, animated: true)
        }
        else if text == tfofClinicBranch{
            if !textField5IsValid() {
                let err = NSLocalizedString("please enter clinic branch...", comment: "")
                error = self.error(withLocalizedDescription: err)
            }
            
            if specialChar == true {
                let err = NSLocalizedString("please don't enter special characterstics...", comment: "")
                error = self.error(withLocalizedDescription: err)
            }
            tfofClinicBranch.setError(error, animated: true)
        }
        else if text == tfofMobileNumber{
            
            if !textField6IsValid() {
                let err = NSLocalizedString("please enter clinic mobile number...", comment: "")
                error = self.error(withLocalizedDescription: err)
                lblOfIVRInfor.isHidden = true
            }else{
                lblOfIVRInfor.isHidden = false
            }
            
            tfofMobileNumber.setError(error, animated: true)
        }
        else if text == tfofEmailId{
            if !textField2IsValid() {
                let err = NSLocalizedString("please enter clinic email Id...", comment: "")
                error = self.error(withLocalizedDescription: err)
            }
            tfofEmailId.setError(error, animated: true)
        }
        else  if text == tfofAddress{
            if !textField1IsValid() {
                let err = NSLocalizedString("please enter  clinic address...", comment: "")
                error = self.error(withLocalizedDescription: err)
            }
            tfofAddress.setError(error, animated: true)
        }
        //        else if text == tfofZipCode{
        //            if !textField3IsValid() {
        //                let err = NSLocalizedString("please enter valid clinic zipcode...", comment: "")
        //                error = self.error(withLocalizedDescription: err)
        //            }
        //            tfofZipCode.setError(error, animated: true)
        //        }
    }
    
    
    func textField1IsValid() -> Bool {
        return (tfofAddress.text?.count)! > 0
    }
    
    func textField2IsValid() -> Bool {
        let boolValue = Utilities.sharedInstace.validateEmail(emailAddress:tfofEmailId.text!)
        return boolValue
    }
    func textField3IsValid() -> Bool {
        return (tfofZipCode.text?.count)! > 0
    }
    
    func textField4IsValid() -> Bool {
        return (tfofClinicName.text?.count)! > 0
    }
    func textField5IsValid() -> Bool {
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ")
        
        if tfofClinicBranch.text?.rangeOfCharacter(from: characterset.inverted) != nil{
            
            specialChar = true
            
            return specialChar
            
        }else{
            specialChar = false
            return (tfofClinicBranch.text?.count)! > 0
        }
    }
    
    func textField6IsValid() -> Bool {
        
        if (tfofMobileNumber.text?.count)! < Int(truncating: minCountryMobileNoLength!) {
            return false
        }else{
            return true
        }
        
    }
    
    
    
    func loadPrefix(){
        
        let pre = NSPredicate(format: "\(getCountriesList.APIResponse.PhoneCode) = %@","\(strSeletedPrefix)")
        
        
        
        if let loadedArrayObjs = UserDefaults.standard.array(forKey: "countries"){
            let arrOfmutable = NSMutableArray()
            for i in 0 ..< loadedArrayObjs.count {
                let dic = loadedArrayObjs[i] as! NSDictionary
                arrOfmutable.add(dic)
            }
            let arr = arrOfmutable.filtered(using: pre)
            if arr.count > 0{
                
                dicOfObj = arr[0] as! NSDictionary
                
                let strOfmin = dicOfObj.object(forKey: getCountriesList.APIResponse.minNumberLength) as! String
                
                btnofPrefix.setTitle("+" + self.strSeletedPrefix, for: .normal)
                
                strofCountryName = String(describing:dicOfObj.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.CountryName))
                
                minCountryMobileNoLength = Int(strOfmin)! as NSNumber
            }
        }
    }
    
    
    func bindClinicData(){
        
        //      if isfromExistingBoolValue == true{
        //            arrofWeekDays.removeAll()
        //           arrofWeekDays = [sun,Mon,Tue,Wed,Thu,Fri,Sat]
        //        }
        
        tfofAddress.isUserInteractionEnabled = false
        tfofEmailId.isUserInteractionEnabled = false
        tfofZipCode.isUserInteractionEnabled = false
        tfofClinicName.isUserInteractionEnabled = false
        tfofClinicBranch.isUserInteractionEnabled = false
        tfofMobileNumber.isUserInteractionEnabled = false
        btnofPrefix.isUserInteractionEnabled = false
        
        strofHospitalRef = String(describing:dicotfClinincTimings.TabiibDocObjectForKey(forKey: getClinicinfo.APIResponse.hospRef))
        strSeletedPrefix = String(describing:dicotfClinincTimings.TabiibDocObjectForKey(forKey: getClinicinfo.APIResponse.phonePrefix))
        selectedPrefixPicker = strSeletedPrefix
        btnofPrefix.setTitle("+" + String(describing:dicotfClinincTimings.TabiibDocObjectForKey(forKey: getClinicinfo.APIResponse.phonePrefix)), for: .normal)
        
        tfofAddress.text = String(describing:dicotfClinincTimings.TabiibDocObjectForKey(forKey: getClinicinfo.APIResponse.hospitalAddress))
        
        tfofEmailId.text = String(describing: dicotfClinincTimings.TabiibDocObjectForKey(forKey: getClinicinfo.APIResponse.hospitalEmailAddress))
        
        tfofZipCode.text = String(describing:dicotfClinincTimings.TabiibDocObjectForKey(forKey: getClinicinfo.APIResponse.hospitalPinCode))
        
        tfofClinicName.text = String(describing:dicotfClinincTimings.TabiibDocObjectForKey(forKey: getClinicinfo.APIResponse.hospitalName))
        tfofClinicBranch.text = String(describing:dicotfClinincTimings.TabiibDocObjectForKey(forKey: getClinicinfo.APIResponse.hospitalBranchName))
        
        tfofMobileNumber.text =  String(describing:dicotfClinincTimings.TabiibDocObjectForKey(forKey: getClinicinfo.APIResponse.hospitalPhone))
        
        let strofClinicDays = String(describing:dicotfClinincTimings.TabiibDocObjectForKey(forKey: getClinicinfo.APIResponse.clinicAvailableDays))
        
        let arrofClincicDays = strofClinicDays.components(separatedBy: ",")
        
        arrofRequestWeekDays.removeAllObjects()
        
        for i in 0 ..< arrofWeekDays.count {
            
            let strObj : String = arrofWeekDays[i]
            
            if arrofClincicDays.contains(strObj){
                
                arrofRequestWeekDays.add(i)
                
            }
            
        }
        
        if arrofClincicDays.count == 0 {
            //            ifWecanEdit = true
        }else{
            if arrofClincicDays.count == arrofWeekDays.count {
                //   btnAllDaysBool = false
                //btnAllDays.isSelected = true
                
                btnAllDays.setBackgroundImage(UIImage.init(named: "btn_backgrund"), for: .normal)
                btnWeekDays.setBackgroundImage(UIImage.init(named: ""), for: .normal)
                
                btnAllDays.layer.borderColor = UIColor.clear.cgColor
                btnWeekDays.layer.borderColor = Constatns.WeekDaysColour().cgColor
                
                btnAllDays.setTitleColor(UIColor.white, for: .normal)
                btnWeekDays.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
                
                viewOfCollection.isHidden = true
                topSpaceFromView.constant = 10
                
                btnAllDaysBool = false
                btnWeekDaysBool = true
                
                //  showWeekDaysCollection = false
                
                collectionofWeekDays.isHidden = true
                // collectionofWeekDays.reloadData()
                
            }else{
                //btnWeekDaysBool = false
                //btnWeekDays.isSelected = true
                
                btnWeekDays.setBackgroundImage(UIImage.init(named: "btn_backgrund"), for: .normal)
                btnAllDays.setBackgroundImage(UIImage.init(named: ""), for: .normal)
                
                btnWeekDays.layer.borderColor = UIColor.clear.cgColor
                btnAllDays.layer.borderColor = Constatns.WeekDaysColour().cgColor
                
                btnWeekDays.setTitleColor(UIColor.white, for: .normal)
                btnAllDays.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
                
                
                
                viewOfCollection.isHidden = false
                topSpaceFromView.constant = 120
                
                btnAllDaysBool = true
                btnWeekDaysBool = false
                
                // showWeekDaysCollection = true
                
                collectionofWeekDays.isHidden = false
                collectionofWeekDays.reloadData()
                
            }
            
            
        }
        
        let strofmrgStratTime = String(describing:dicotfClinincTimings.TabiibDocObjectForKey(forKey: getClinicinfo.APIResponse.clinicMorningTimeFrom))
        
        
        btnofStartTime.setTitle(strofmrgStratTime, for: .normal)
        selectedStartTime = strofmrgStratTime
        
        let strofmrgEndTime = String(describing:dicotfClinincTimings.TabiibDocObjectForKey(forKey: getClinicinfo.APIResponse.clinicMorningTimeTo))
        
        //        if strofmrgEndTime != "" {
        btnofEndTime.setTitle(strofmrgEndTime, for: .normal)
        selectedEndTime = strofmrgEndTime
        //        }else{
        //            ifWecanEdit = true
        //        }
        
        //default set Alldays Selected
        //        viewOfCollection.isHidden = true
        //        topSpaceFromView.constant = 10
        //
        //        btnAllDaysBool = false
        //        btnWeekDaysBool = true
        
        //        btnAllDays.isSelected = true
        //        btnWeekDays.isSelected = false
        //        collectionofWeekDays.isHidden = true
        
        if isFromExistingOne == true {
            collectionofWeekDays.isUserInteractionEnabled = false
            btnofStartTime.isUserInteractionEnabled = false
            btnofEndTime.isUserInteractionEnabled = false
            btnWeekDays.isUserInteractionEnabled = false
            btnAllDays.isUserInteractionEnabled = false
            
        }else{
            
            collectionofWeekDays.reloadData()
            collectionofWeekDays.isUserInteractionEnabled = true
            btnofStartTime.isUserInteractionEnabled = true
            btnofEndTime.isUserInteractionEnabled = true
            btnWeekDays.isUserInteractionEnabled = true
            btnAllDays.isUserInteractionEnabled = true
            
        }
        
        loadPrefix()
        
    }
    
    @IBAction func pickerDoneClicked(_ sender : Any){
        
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
                
                strSeletedPrefix = dicOfObj.TabiibDocObjectForKey(forKey:  getCountriesList.APIResponse.PhoneCode)
                btnofPrefix.setTitle("+" + strSeletedPrefix, for: .normal)
                strofCountryName = String(describing: dicOfObj.TabiibDocObjectForKey(forKey:  getCountriesList.APIResponse.CountryName))
                let strOfmin = dicOfObj.object(forKey: getCountriesList.APIResponse.minNumberLength) as! String
                minCountryMobileNoLength = Int(strOfmin)! as NSNumber
                
            }
        }
        
        lblofPrefixSelection.backgroundColor = Constatns.UnSelectThemeColour()
        btnofPrefix.setTitle("+" + self.strSeletedPrefix, for: .normal)
        viewofPrefix.isHidden = true
    }
    
    @IBAction func pickerCancelClicked(_ sender : Any){
        
        viewofPrefix.isHidden = true
    }
    
    
    
    @IBAction func btnPrefixClicked(_ sender : Any){
        
        allTextFieldResignResp()
        
        arrofOptions.removeAll()
        
        if let loadedArrayObjs = UserDefaults.standard.array(forKey: "countries")  {
            
            for item in 0 ..< loadedArrayObjs.count {
                
                let dic = loadedArrayObjs[item] as! NSDictionary
                
                let strOfPhoneCode = dic.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.PhoneCode)
                
                arrofOptions.append(strOfPhoneCode)
                
            }
        }
        
        
        
        lblofPrefixSelection.backgroundColor = Constatns.ThemeColour()
        prefixPicker.reloadAllComponents()
        viewofPrefix.isHidden = false
        
        
    }
    
    @IBAction func btnPickerCancelClicked(_ sender: Any) {
        viewofTimePicker.isHidden = true
    }
    
    
    @IBAction func btnPickerDoneClicked(_ sender: Any) {
        
        if strSelectedTime == "S" {
            //  print(startTimePicker.date)
            selectedStartTime = startTimePicker.date.getServerDateFormat()
            //            var strDatetoRepresent = startTimePicker.date.getServerDateFormat()
            btnofStartTime.setTitle(startTimePicker.date.getServerDateFormat(), for: .normal)
            
            if selectedEndTime != nil && selectedEndTime.isEmpty == false {
                if selectedEndTime.getStringTimeToDate().compare(startTimePicker.date) != ComparisonResult.orderedDescending {
                    selectedEndTime = ""
                    Utilities.sharedInstace.showAlertviewWithMessage("Please Select Endtime")
                    btnofEndTime.setTitle("End Time", for: .normal)
                    
                }
            }
            
        }
        else{
            //  print(endTimePicker.date)
            selectedEndTime = endTimePicker.date.getServerDateFormat()
            btnofEndTime.setTitle(endTimePicker.date.getServerDateFormat(), for: .normal)
            
            //added --- for clininc timings logic
            if selectedStartTime != nil && selectedStartTime.isEmpty == false {
                if selectedStartTime.getStringTimeToDate().compare(endTimePicker.date) != ComparisonResult.orderedAscending {
                    selectedStartTime = ""
                    Utilities.sharedInstace.showAlertviewWithMessage("Please Select Starttime")
                    btnofStartTime.setTitle("Start Time", for: .normal)
                }
            }
            
        }
        //
        //        if startTimePicker.date >= endTimePicker.date.addingTimeInterval(-59.0 * 60.0) {
        //            selectedEndTime = ""
        //            Utilities.sharedInstace.showAlertviewWithMessage("Please Select minimum one hour")
        //            btnofEndTime.setTitle("End Time", for: .normal)
        //        }
        
        viewofTimePicker.isHidden = true
        
    }
    
    
    //
    
    @IBAction func btnofEndTimeClicked(_ sender: Any) {
        
        
        allTextFieldResignResp()
        
        strSelectedTime = "E"
        endTimePicker.minimumDate = startTimePicker.date.addingTimeInterval(3 * 60 * 60)
        //        if endTimePicker.date < startTimePicker.date {
        //          //  endTimePicker.date = startTimePicker.date.addingTimeInterval(60.0 * 60.0)
        //            endTimePicker.minimumDate = startTimePicker.date.addingTimeInterval(3 * 60 * 60)
        //        }
        
        
        viewofTimePicker.isHidden = false
        startTimePicker.isHidden = true
        endTimePicker.isHidden = false
    }
    
    
    @IBAction func btnStartTimeClicked(_ sender: Any) {
        
        
        allTextFieldResignResp()
        strSelectedTime = "S"
//        if startTimePicker.date < endTimePicker.date {
//            startTimePicker.date = endTimePicker.date.addingTimeInterval(-3 * 60 * 60)
//        }
        
        viewofTimePicker.isHidden = false
        startTimePicker.isHidden = false
        endTimePicker.isHidden = true
        
    }
    
    
    
    
    @IBAction func btnWeekDaysClicked(_ sender: Any) {
        
        allTextFieldResignResp()
        
        btnWeekDays.setBackgroundImage(UIImage.init(named: "btn_backgrund"), for: .normal)
        btnAllDays.setBackgroundImage(UIImage.init(named: ""), for: .normal)
        
        btnWeekDays.layer.borderColor = UIColor.clear.cgColor
        btnAllDays.layer.borderColor = Constatns.WeekDaysColour().cgColor
        
        btnAllDays.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
        btnWeekDays.setTitleColor(UIColor.white, for: .normal)
        
        //default set Alldays Selected
        viewOfCollection.isHidden = false
        topSpaceFromView.constant = 120
        
        btnAllDaysBool = true
        btnWeekDaysBool = false
        
        //        btnAllDays.isSelected = false
        //        btnWeekDays.isSelected = true
        collectionofWeekDays.isHidden = false
        
    }
    
    func allDaysClicked(){
        
        btnAllDays.setBackgroundImage(UIImage.init(named: "btn_backgrund"), for: .normal)
        btnWeekDays.setBackgroundImage(UIImage.init(named: ""), for: .normal)
        
        btnAllDays.layer.borderColor = UIColor.clear.cgColor
        btnWeekDays.layer.borderColor = Constatns.WeekDaysColour().cgColor
        
        btnAllDays.setTitleColor(UIColor.white, for: .normal)
        btnWeekDays.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
        
        //default set Alldays Selected
        viewOfCollection.isHidden = true
        topSpaceFromView.constant = 10
        
        btnAllDaysBool = false
        btnWeekDaysBool = true
        
        //        btnAllDays.isSelected = true
        //        btnWeekDays.isSelected = false
        collectionofWeekDays.isHidden = true
        
    }
    
    
    @IBAction func btnAllDaysClicked(_ sender: Any) {
        
        allTextFieldResignResp()
        allDaysClicked()
        
    }
    
    
    
    func callforCheckDulicateClinics(success : @escaping DuplicateClinicResponse) {
        
        dupliActivityIndicator.isHidden = false
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      checkDuplicateClinic.APIRequest.clinicName : tfofClinicName.text!,
                                      checkDuplicateClinic.APIRequest.clinicBranch : tfofClinicBranch.text!]
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.checkDuplicateClinic, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            //  print(response)
            
            self.dupliActivityIndicator.isHidden = true
            
            let dictofResonse = response as! NSDictionary
            
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                success(dictofResonse)
                
                
            }
            else{
                
                Utilities.sharedInstace.showAlertviewWithMessage(String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.error_message)))
                
            }
            
            
        }) { (networkErr, messag) in
            
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
        
        if self.isError == "cinicbasicinfo"{
            callforAddBasicClinicInfoAPI()
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tfofMobileNumber {
            
            let currentCharacterCount = textField.text?.count ?? 0
            
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            
            return newLength <= Int(truncating: minCountryMobileNoLength!)
            
        }
        
        if textField == tfofZipCode {
            
            let currentCharacterCount = textField.text?.count ?? 0
            
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            
            return newLength <= Int(truncating: 6)
            
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
    
    
    
    func callforAddBasicClinicInfoAPI(){
        
        if viewofTimePicker.isHidden == false {
            viewofTimePicker.isHidden = true
        }
        
        if viewofPrefix.isHidden == false {
            viewofPrefix.isHidden = true
        }
        
      //  APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        let param : [String : Any] = [
            APIRequestKeys.ApiKey : UserDefaultStore.ApiKey!,
            APIRequestKeys.userRef : UserDefaultStore.userRef!,
            AddClinicBasicProfile.APIRequest.userType : userType,
            AddClinicBasicProfile.APIRequest.clinicprefix : strSeletedPrefix,
            AddClinicBasicProfile.APIRequest.clinicName : tfofClinicName.text!,
            AddClinicBasicProfile.APIRequest.clinicBranch : tfofClinicBranch.text!,
            AddClinicBasicProfile.APIRequest.clinicnumber : tfofMobileNumber.text!,
            AddClinicBasicProfile.APIRequest.clinicAddress : tfofAddress.text!,
            AddClinicBasicProfile.APIRequest.pincode : tfofZipCode.text!,
            AddClinicBasicProfile.APIRequest.city : "",
            AddClinicBasicProfile.APIRequest.clinicLatitude : strofClinincLatitude,
            AddClinicBasicProfile.APIRequest.clinicLongitude : strofClinincLongitude,
            AddClinicBasicProfile.APIRequest.clinicAvailableDays : selectedWeekDays!,
            AddClinicBasicProfile.APIRequest.clinicFromTime : selectedStartTime!,
            AddClinicBasicProfile.APIRequest.docemailId : tfofEmailId.text!,
            AddClinicBasicProfile.APIRequest.clinicToTime : selectedEndTime!,
            AddClinicBasicProfile.APIRequest.CountryName : strofCountryName]
        
        
        //  print(param)
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.addClinicBasicProfile, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            // print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                let strofHospitalRef = String(describing:dictofResonse.TabiibDocObjectForKey(forKey: AddClinicBasicProfile.APIResponse.hospitalUserRef))
                
                self.isApiRequested = true
                
                self.strofHospitalRef = strofHospitalRef
                self.isFromExistingOne = true
                
                if let delegateObj = self.delegate {
                    
                    //                    delegateObj.proccedClicked(strofHospitalRef)
                    
                    delegateObj.proccedClicked(dictofResonse)
                }
                
//                self.tfofClinicName.isUserInteractionEnabled = false
//                self.tfofClinicBranch.isUserInteractionEnabled = false
//                self.tfofMobileNumber.isUserInteractionEnabled = false
//                self.tfofAddress.isUserInteractionEnabled = false
//                self.tfofEmailId.isUserInteractionEnabled = false
//                self.tfofZipCode.isUserInteractionEnabled = false
//                self.btnAllDays.isUserInteractionEnabled = false
//                self.btnWeekDays.isUserInteractionEnabled = false
//                self.btnofStartTime.isUserInteractionEnabled = false
//                self.btnofEndTime.isUserInteractionEnabled = false

                self.userInteractionmethods()
                
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
                self.isError = "cinicbasicinfo"
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    func selectedWeekDays23() -> String{
        
        var selectedDays : String! = ""
        
        for case let Index as Int in arrofRequestWeekDays {
            selectedDays.append(arrofWeekDays[Index])
            selectedDays.append(",")
        }
        let arr = selectedDays.components(separatedBy: ",")
        let arrOfObj = NSMutableArray()
        
        if arr.contains("Sun"){
            arrOfObj.add("Sun")
        }
        if arr.contains("Mon"){
            arrOfObj.add("Mon")
        }
        
        if arr.contains("Tue"){
            arrOfObj.add("Tue")
        }
        
        if arr.contains("Wed"){
            arrOfObj.add("Wed")
        }
        
        if arr.contains("Thu"){
            arrOfObj.add("Thu")
        }
        
        if arr.contains("Fri"){
            arrOfObj.add("Fri")
        }
        
        if arr.contains("Sat"){
            arrOfObj.add("Sat")
        }
        
        selectedDays.removeAll()
        
        for i in 0..<arrOfObj.count{
            let str : String = arrOfObj[i] as! String
            selectedDays.append(str)
            selectedDays.append(",")
            
        }
        
        let finalDays = String(selectedDays.dropLast())
        
        return finalDays
    }
    
    func getAllDays() -> String{
        
        var selectedDays : String! = ""
        
        for  strobj  in arrofWeekDays {
            selectedDays.append(strobj)
            selectedDays.append(",")
        }
        
        let finalDays = String(selectedDays.dropLast())
        
        return finalDays
    }
    
    
    
    
    func validateInputFields() -> Bool{
        
        var ifAllSuccess : Bool = true
        
        var error: Error? = nil
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ")
        
        let tfOfClinic = self.tfofClinicName.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfOfBranch = self.tfofClinicBranch.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfOfMobileNo = self.tfofMobileNumber.text?.trimmingCharacters(in: CharacterSet.whitespaces)

        
        if tfOfClinic?.count == 0 {

            
            let err = NSLocalizedString("please enter clinic name...", comment: "")
            error = self.error(withLocalizedDescription: err)
            tfofClinicName.setError(error, animated: true)
            ifAllSuccess = false
        }
        else if tfOfBranch?.count == 0 {

            let err = NSLocalizedString("please enter clinic branch...", comment: "")
            error = self.error(withLocalizedDescription: err)
            
            
            tfofClinicBranch.setError(error, animated: true)
            ifAllSuccess = false
        }
         else if tfOfMobileNo?.count == 0 {
            
            lblOfIVRInfor.isHidden = true
            
            let err = NSLocalizedString("please enter clinic mobile number...", comment: "")
            error = self.error(withLocalizedDescription: err)
            
            
            tfofMobileNumber.setError(error, animated: true)
            ifAllSuccess = false
        }else if (tfOfMobileNo?.count == 0) == false {

            
            var error: Error? = nil
            if !textField6IsValid() {
                ifAllSuccess = false
                let errStr = NSLocalizedString("please enter mobile number...", comment: "")
                error = self.error(withLocalizedDescription: errStr)
                lblOfIVRInfor.isHidden = true
                tfofMobileNumber.setError(error, animated: true)
            }else{
                
                if strSeletedPrefix == "" {
                    
                    let err = NSLocalizedString("please enter valid clinic mobile number...", comment: "")
                    error = self.error(withLocalizedDescription: err)
                    
                    
                    tfofMobileNumber.setError(error, animated: true)
                    ifAllSuccess = false
                }
                else if tfofEmailId.text!.isEmpty {
                    let err = NSLocalizedString("please enter clinic email Id...", comment: "")
                    error = self.error(withLocalizedDescription: err)
                    
                    
                    tfofEmailId.setError(error, animated: true)
                    ifAllSuccess = false
                }
                else if !Utilities.sharedInstace.validateEmail(emailAddress: tfofEmailId.text!){
                    let err = NSLocalizedString("please enter valid clinic email Id...", comment: "")
                    error = self.error(withLocalizedDescription: err)
                    
                    
                    tfofEmailId.setError(error, animated: true)
                    ifAllSuccess = false
                }
                else if tfofAddress.text!.isEmpty {
                    let err = NSLocalizedString("please enter  clinic address...", comment: "")
                    error = self.error(withLocalizedDescription: err)
                    
                    
                    tfofAddress.setError(error, animated: true)
                    ifAllSuccess = false
                }
                    //        else if tfofZipCode.text!.isEmpty {
                    //            let err = NSLocalizedString("please enter valid clinic zipcode...", comment: "")
                    //            error = self.error(withLocalizedDescription: err)
                    //
                    //
                    //            tfofZipCode.setError(error, animated: true)
                    //            ifAllSuccess = false
                    //        }
                else if duplicateBool == true{
                    
                    let err = NSLocalizedString("Already clinic exist at particular branch...", comment: "")
                    error = self.error(withLocalizedDescription: err)
                    tfofClinicBranch.setError(error, animated: true)
                    ifAllSuccess = false
                    
                }
                else if tfofClinicBranch.text?.rangeOfCharacter(from: characterset.inverted) != nil {
                    
                    Utilities.sharedInstace.showAlertviewWithMessage(NSLocalizedString("please don't enter special characters", comment: ""))
                    ifAllSuccess = false
                }
            }
        }
        
        return ifAllSuccess
        
    }
    
    func userInteractionmethods(){
        
        tfofAddress.isUserInteractionEnabled = false
        tfofEmailId.isUserInteractionEnabled = false
        tfofZipCode.isUserInteractionEnabled = false
        tfofClinicName.isUserInteractionEnabled = false
        tfofClinicBranch.isUserInteractionEnabled = false
        tfofMobileNumber.isUserInteractionEnabled = false
        btnofStartTime.isUserInteractionEnabled = false
        btnofEndTime.isUserInteractionEnabled = false
        btnWeekDays.isUserInteractionEnabled = false
        btnAllDays.isUserInteractionEnabled = false
        collectionofWeekDays.isUserInteractionEnabled = false
    }
    
    
    @IBAction func btnProceedClicked(_ sender: Any) {
        
        allTextFieldResignResp()
        
        if isFromExistingOne {//strofHospitalRef
            
            if let delegateObj = self.delegate {
                
                if  isApiRequested == true
                {
                    delegateObj.backtoAddclinc()
                }else{
                    delegateObj.proccedClicked(dicotfClinincTimings)
                    // delegateObj.proccedClicked(strofHospitalRef)
                }
            }
            
        }else{
            
            if validateInputFields() {
                
                //validations
                if isRequestingforDupli == false {
                    if btnWeekDaysBool == false {
                        
                        if selectedStartTime == "" || selectedEndTime == "" {
                            let serv = NSLocalizedString("Select Timings", comment: "")
                            Utilities.sharedInstace.showAlertviewWithMessage(serv)
                        }else if arrofRequestWeekDays.count == 0 {
                            let serv = NSLocalizedString("Select atleast one week day", comment: "")
                            Utilities.sharedInstace.showAlertviewWithMessage(serv)
                            
                        }else if startTimePicker.date > endTimePicker.date{
                            let serv = NSLocalizedString("Please enter end time is greater than start time", comment: "")
                            Utilities.sharedInstace.showAlertviewWithMessage(serv)
                        }
                        else if strofClinincLongitude == "" {
                            let err = NSLocalizedString("please enter  clinic address...", comment: "")
                            let  error = self.error(withLocalizedDescription: err)
                            tfofAddress.setError(error, animated: true)
                            Utilities.sharedInstace.showAlertviewWithMessage(err)
                        }
                        else{
                            selectedWeekDays = selectedWeekDays23()
                            callforAddBasicClinicInfoAPI()
                        }
                        
                    }else if btnAllDaysBool == false{
                        selectedWeekDays = getAllDays()
                        
                        if selectedStartTime == "" || selectedEndTime == "" {
                            let serv = NSLocalizedString("Select Timings", comment: "")
                            Utilities.sharedInstace.showAlertviewWithMessage(serv)
                        }else if startTimePicker.date > endTimePicker.date{
                            let serv = NSLocalizedString("Please enter end time is greater than start time", comment: "")
                            Utilities.sharedInstace.showAlertviewWithMessage(serv)
                        }
                        else if strofClinincLongitude == "" {
                            let err = NSLocalizedString("please enter  clinic address...", comment: "")
                            let  error = self.error(withLocalizedDescription: err)
                            tfofAddress.setError(error, animated: true)
                            Utilities.sharedInstace.showAlertviewWithMessage(err)
                        }
                        else{
                            callforAddBasicClinicInfoAPI()
                        }
                    }
                    else{
                        Utilities.sharedInstace.showAlertviewWithMessage(NSLocalizedString("Select Clinic Timings", comment: ""))
                    }
                }
                
            }else{
                
                // Utilities.sharedInstace.showAlertviewWithMessage("please enter valid details")
                
            }
            
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension ClinicInformationViewController : GMSAutocompleteViewControllerDelegate
{
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //        print("Place name: \(place.name)")
        //        print("Place address: \(String(describing: place.formattedAddress))")
        //        print("Place attributions: \(String(describing: place.attributions))")
        //        print("Place coordinates: \(String(describing: place.coordinate))")
        //
        
        strofClinincLatitude = String(describing:place.coordinate.latitude)
        strofClinincLongitude = String(describing:place.coordinate.longitude)
        
        tfofAddress.text = String(describing:place.formattedAddress!)
        
        dismiss(animated: true, completion: nil)
        
        if Int((tfofAddress.text?.count)!) > 0{
            let error: Error? = nil
            tfofAddress.setError(error, animated: true)
        }
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        
        dismiss(animated: true, completion: nil)
        
        if Int((tfofAddress.text?.count)!) > 0{
            let error: Error? = nil
            tfofAddress.setError(error, animated: true)
        }
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension ClinicInformationViewController : UIPickerViewDataSource,UIPickerViewDelegate
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = arrofOptions[row]
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Lato", size: 20.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
        
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        isPickerSelectionDone = true
        self.selectedPrefixPicker = arrofOptions[row]
       // self.strSeletedPrefix = arrofOptions[row]
        // btnofPrefix.setTitle(strSeletedPrefix, for: .normal)
        
    }
}

extension ClinicInformationViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrofWeekDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let weekdayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekdayCollectionViewCell", for: indexPath) as! WeekdayCollectionViewCell
        
        weekdayCell.lblofWeekDays.text = String(describing:arrofWeekDays[indexPath.row]).capitalized + "     "
        
        
        if arrofRequestWeekDays.contains(indexPath.row) {
            weekdayCell.imgofBg.isHidden = false
            weekdayCell.lblofWeekDays.textColor = UIColor.white
            weekdayCell.lblofWeekDays.layer.borderColor = UIColor.clear.cgColor
        }
        else{
            weekdayCell.imgofBg.isHidden = true
            weekdayCell.lblofWeekDays.textColor = Constatns.WeekDaysColour()
            weekdayCell.lblofWeekDays.layer.cornerRadius = 18
            weekdayCell.lblofWeekDays.layer.borderColor = Constatns.WeekDaysColour().cgColor
            weekdayCell.lblofWeekDays.layer.borderWidth = 1
            
        }
        
        weekdayCell.lblofWeekDays.textAlignment = .center
        
        return weekdayCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if viewofPrefix.isHidden == false {
            viewofPrefix.isHidden = true
        }
        
        if viewofTimePicker.isHidden == false {
            viewofTimePicker.isHidden = true
        }
        
        
        if arrofRequestWeekDays.contains(indexPath.row) {
            arrofRequestWeekDays.remove(indexPath.row)
        }
        else{
            arrofRequestWeekDays.add(indexPath.row)
        }
        
        collectionofWeekDays.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CGSize(width: self.view.frame.size.width/4, height: 40)
        }
        else if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: self.view.frame.size.width/5, height: 50)
        }
        return CGSize(width: self.view.frame.size.width/4, height: 40)
    }
    
    
}



