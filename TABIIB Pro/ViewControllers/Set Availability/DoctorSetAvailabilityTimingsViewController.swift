//
//  DoctorSetAvailabilityTimingsViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import MaterialTextField

protocol DoctorAvailabilityUpdateDelegate {
    func submitClicked()
}


class DoctorSetAvailabilityTimingsViewController: UIViewController,ErrorProtocalDelegate,DoctorAvailabilityUpdateDelegate,UITextFieldDelegate {
    func submitClicked() {
        
    }
    
    @IBOutlet var tfofConsulationFee : MFTextField!
    @IBOutlet var btnCurrency: UIButton!
    @IBOutlet var btnAlldays: UIButton!
    @IBOutlet var btnWeekdays: UIButton!
    @IBOutlet var collectionofWeekdays: UICollectionView!
    @IBOutlet var btnStartTime: UIButton!
    @IBOutlet var btnEndtime: UIButton!
    @IBOutlet var btnnoofPersons: UIButton!
    
    @IBOutlet var viewofTimePicker: UIView!
    @IBOutlet var startTimePicker: UIDatePicker!
    @IBOutlet var endTimePicker: UIDatePicker!
    @IBOutlet var topSpaceFromView: NSLayoutConstraint!
    
    @IBOutlet var viewofCurrencyPicker : UIView!
    @IBOutlet var pickerofCurrency : UIPickerView!
    
    @IBOutlet var btnof15Days : UIButton!
    @IBOutlet var btnof45Days : UIButton!
    var selectedNumberofDays : String! = ""
    
    @IBOutlet var lblofContentofSchedule : UILabel!
    @IBOutlet var lblofbtnCurrency : UILabel!
    var strSelectedTime : String! = ""
    var arrofWeekDays : [String] = [String]()
    var arrofRequestWeekDays : NSMutableArray!
    var dictOfClinicInfo : NSDictionary!
    
    var dicotfClinincTimings : NSDictionary!
    var arrofSelectedDays = [Int]()
    
    var delegate : DoctorAvailabilityUpdateDelegate!
    
    //    let BahrainCurrency  = "BHD"
    //    let DubaiCurrency = "AED"
    //    let SoudiCurrency = "AED"
    //    let indiaCurrency = "INR"
    
    let persons1 = "1"
    let persons2 = "2"
    let persons3 = "3"
    let persons4 = "4"
    
    let NoofPersons = "NoofPersons"
    let Currency = "Currency"
    
    var selectedCurrency : String! = ""
    var selectedNoofPers : String! = ""
    
    var isPickerSelectionDone : Bool = false
    var selectedNoofPerPicker : String! = String()

    
    var selectedPicker : String! = ""
    var arrofPickerData : [String]!
    var selectedStartTime : String! = ""
    var selectedEndTime : String! = ""
    var selectedWeekDays : String! = ""
    var strMrgSlotTime : String! = ""
    
    
    var selectedclinicRef : String!
    var isFromExisting : Bool = false
    
    var ifWecanEdit : Bool = false
    
    var btn15DaysBool : Bool = false
    var btn45DaysBool : Bool = false
    var isAlldaysSelected : Bool = false
    
    //    var btnAllDaysBool : Bool = false
    //    var btnWeekDaysBool : Bool = false
    var showWeekDaysBoolColle : Bool = false
    var isexistingFromAvailTimngs : Bool = false
    
    let sun = NSLocalizedString("Sun", comment: "")
    let Mon = NSLocalizedString("Mon", comment: "")
    let Tue = NSLocalizedString("Tue", comment: "")
    let Wed = NSLocalizedString("Wed", comment: "")
    let Thu = NSLocalizedString("Thu", comment: "")
    let Fri = NSLocalizedString("Fri", comment: "")
    let Sat = NSLocalizedString("Sat", comment: "")
    
    var arrOfContainDays : [String] = [String]()
    
    var singObj : SingleTonClass!
    var isError : String = ""
    
    var docStartDate : Date!
    var docEndDate : Date!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblofbtnCurrency.backgroundColor = Constatns.UnSelectThemeColour()
        
        singObj = SingleTonClass.SharedInstance
        
        btnCurrency.isUserInteractionEnabled = false
        
        arrofRequestWeekDays = NSMutableArray()
        arrofPickerData = [String]()
        
        arrofWeekDays = [sun,Mon,Tue,Wed,Thu,Fri,Sat]
        
        viewofTimePicker.isHidden = true
        viewofCurrencyPicker.isHidden = true
        
        
        tfofConsulationFee.delegate = self
        
        
        lblofContentofSchedule.text = NSLocalizedString("Note : Please update the availability after the selected time to ensure your listing stays active", comment: "")
        
        allDaysSlected()
        
        tfofConsulationFee.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        
        
        toolbaraddedtoKeyboard()
        
        bindCurrency()
        
    }
    
    
    func bindCurrency() {
        
        let pre = NSPredicate(format: "\(getCountriesList.APIResponse.PhoneCode) = %@","\(UserDefaultStore.mobilePrefix!)")
        
        var dicOfObj = NSDictionary()
        
        if let loadedArrayObjs = UserDefaults.standard.array(forKey: "countries"){
            let arrOfmutable = NSMutableArray()
            for i in 0 ..< loadedArrayObjs.count {
                let dic = loadedArrayObjs[i] as! NSDictionary
                arrOfmutable.add(dic)
            }
            let arr = arrOfmutable.filtered(using: pre)
            if arr.count > 0{
                
                dicOfObj = arr[0] as! NSDictionary
                
                selectedCurrency = String(describing:dicOfObj.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.Currency))
                btnCurrency.setTitle(selectedCurrency, for: .normal)
                
                
            }
        }
    }
    
    func toolbaraddedtoKeyboard(){
        let numberToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(doneClicked)),
        ]
        numberToolbar.sizeToFit()
        tfofConsulationFee.inputAccessoryView = numberToolbar
        
    }
    @objc func doneClicked(){
        if tfofConsulationFee.isFirstResponder{
            tfofConsulationFee.resignFirstResponder()
        }
    }
    
    
    
    func allDaysSlected(){
        
        btnWeekdays.setBackgroundImage(UIImage.init(named: ""), for: .normal)
        btnAlldays.setBackgroundImage(UIImage.init(named: "btn_backgrund"), for: .normal)
        
        btnAlldays.layer.borderColor = UIColor.clear.cgColor
        btnWeekdays.layer.borderColor = Constatns.WeekDaysColour().cgColor
        
        btnAlldays.setTitleColor(UIColor.white, for: .normal)
        btnWeekdays.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
        
        //default set Alldays Selected
        topSpaceFromView.constant = 10
        
        isAlldaysSelected = true
        
        //        btnAlldays.isSelected = true
        //        btnWeekdays.isSelected = false
        collectionofWeekdays.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let fee = NSLocalizedString("Consultation Fee", comment: "")
        tfofConsulationFee.placeholder = fee
        
    }
    
    func allTextFieldResignResp(){
        if tfofConsulationFee.isFirstResponder{
            tfofConsulationFee.resignFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfofConsulationFee.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func calltoGetDocAvailabilityAPI(){
        
        /*{"userRef":"QmalxZn4UQEWfSq6","ApiKey":"SKZHTiNhgR6G9TSl","hospRef":"uHtORE84ATzJ5oG7"}*/
        
       // APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      getDocTiming.APIRequest.hospRef : selectedclinicRef]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.getDocTiming, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //   print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                let arrofRespoData = dictofResonse.object(forKey: getDocTiming.APIResponse.data) as! NSArray
                
                let strofIsEditing = String(describing:dictofResonse.TabiibDocObjectForKey(forKey: getDocTiming.APIResponse.isEditable))
                
                if strofIsEditing == "1" {
                    self.ifWecanEdit = true
                }
                
                if arrofRespoData.count == 0 {
                    
                    //    print("have to set avalibility timings")
                }else{
                    
                    // print("already available dont't edit")
                    
                    let dictofRecord = arrofRespoData[0] as! NSDictionary
                    
                    self.bindAvalibilityTimings(dictofRecord)
                    
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
                self.isError = "getdocset"
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        if self.isError == "getdocset"{
            calltoGetDocAvailabilityAPI()
        }else{
            callforsetDoctortAvailbilityAPI()
        }
        
    }
    
    func bindAvalibilityTimings(_ dictofResponse : NSDictionary){
        
        
        let strValidityDays = String(describing:dictofResponse.TabiibDocObjectForKey(forKey: getDocTiming.APIResponse.ValidityDays_AvailableTime))
        
        if strValidityDays == "15" {
            
            btn15DaysBool = true
            
            
            //btnof15Days.isSelected = true
            selectedNumberofDays = "15"
            btnof15Days.setBackgroundImage(UIImage.init(named: "btn_backgrund2"), for: .normal)
            btnof15Days.setTitleColor(UIColor.white, for: .normal)
            btnof15Days.layer.borderColor = UIColor.clear.cgColor
            
            btnof45Days.setBackgroundImage(UIImage.init(named: ""), for: .normal)
            btnof45Days.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
            btnof45Days.layer.borderColor = Constatns.WeekDaysColour().cgColor
            
        }
        else if strValidityDays == "30" {
            
            btn45DaysBool = true
            
            // btnof45Days.isSelected = true
            selectedNumberofDays = "30"
            
            btnof45Days.setBackgroundImage(UIImage.init(named: "btn_backgrund2"), for: .normal)
            btnof45Days.setTitleColor(UIColor.white, for: .normal)
            btnof45Days.layer.borderColor = UIColor.clear.cgColor
            
            btnof15Days.setBackgroundImage(UIImage.init(named: ""), for: .normal)
            btnof15Days.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
            btnof15Days.layer.borderColor = Constatns.WeekDaysColour().cgColor
            
        }
        
        let strofCurrency = String(describing:dictofResponse.TabiibDocObjectForKey(forKey: getDocTiming.APIResponse.currency))
        
        
        selectedCurrency = strofCurrency
        btnCurrency.setTitle(strofCurrency, for: .normal)
        
        let strConsultaionFee = String(describing:dictofResponse.TabiibDocObjectForKey(forKey: getDocTiming.APIResponse.consulationFee))
        
        tfofConsulationFee.text = strConsultaionFee
        
        
        let strofSelectedDays = String(describing:dictofResponse.TabiibDocObjectForKey(forKey:getDocTiming.APIResponse.days))
        let arrofSupporteDays = strofSelectedDays.components(separatedBy: ",")
        
        arrofRequestWeekDays.removeAllObjects()
        
        for i in 0 ..< arrofWeekDays.count {
            
            let strObj : String = arrofWeekDays[i]
            
            if arrofSupporteDays.contains(strObj){
                
                arrofRequestWeekDays.add(i)
                
                
                //added -- for clininf timings logic
                arrofSelectedDays.append(i)
                
            }
            
        }
        
        
        if arrofSupporteDays.count == 0 {
            
            
        }else{
            //            arrofRequestWeekDays.removeAllObjects()
            //            arrofRequestWeekDays.addObjects(from: arrofSupporteDays)
            
            if arrofSupporteDays.count == arrofWeekDays.count {
                
                btnAlldays.setBackgroundImage(UIImage.init(named: "btn_backgrund"), for: .normal)
                btnWeekdays.setBackgroundImage(UIImage.init(named: ""), for: .normal)
                
                btnAlldays.setTitleColor(UIColor.white, for: .normal)
                btnWeekdays.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
                
                btnAlldays.layer.borderColor = UIColor.clear.cgColor
                btnWeekdays.layer.borderColor = Constatns.WeekDaysColour().cgColor
                
                isAlldaysSelected = true
                
                //                arrofWeekDays.removeAll()
                //                arrofWeekDays.append(contentsOf: arrofSupporteDays)
                
                showWeekDaysBoolColle = false
                //default set Alldays Selected
                topSpaceFromView.constant = 10
                collectionofWeekdays.isHidden = true
                // btnAlldays.isSelected = true
            }else{
                
                btnWeekdays.setBackgroundImage(UIImage.init(named: "btn_backgrund"), for: .normal)
                btnAlldays.setBackgroundImage(UIImage.init(named: ""), for: .normal)
                
                btnWeekdays.setTitleColor(UIColor.white, for: .normal)
                btnAlldays.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
                
                btnWeekdays.layer.borderColor = UIColor.clear.cgColor
                btnAlldays.layer.borderColor = Constatns.WeekDaysColour().cgColor
                
                isAlldaysSelected = false
                
                showWeekDaysBoolColle = true
                
                arrOfContainDays.append(contentsOf: arrofSupporteDays)
                
                collectionofWeekdays.isHidden = false
                collectionofWeekdays.reloadData()
                
                topSpaceFromView.constant = 120
                
            }
        }
        
        
        let strMrgStratTime = String(describing:dictofResponse.TabiibDocObjectForKey(forKey: getDocTiming.APIResponse.startMorningTime))
        
        
        btnStartTime.setTitle(strMrgStratTime, for: .normal)
        selectedStartTime = strMrgStratTime
        
        
        
        let strMrgEndTime = String(describing:dictofResponse.TabiibDocObjectForKey(forKey: getDocTiming.APIResponse.endMorningTime))
        
        btnEndtime.setTitle(strMrgEndTime, for: .normal)
        selectedEndTime = strMrgEndTime
        
        let strofPersonsperhour = String(describing:dictofResponse.TabiibDocObjectForKey(forKey: getDocTiming.APIResponse.morningPersonPerHour))
        
        let strofperperosnNumber = "\(strofPersonsperhour) " + NSLocalizedString("Persons per hour", comment: "")
        
        btnnoofPersons.setTitle(strofperperosnNumber, for: .normal)
        selectedNoofPers = strofPersonsperhour
        selectedNoofPerPicker = selectedNoofPers
        let strofSlotTime = String(describing:dictofResponse.TabiibDocObjectForKey(forKey: getDocTiming.APIResponse.morningSlotTime))
        
        strMrgSlotTime = strofSlotTime
        
        
        if ifWecanEdit == false {
            
            
            btnof15Days.isUserInteractionEnabled = false
            btnof45Days.isUserInteractionEnabled = false
            collectionofWeekdays.isUserInteractionEnabled = false
            btnnoofPersons.isUserInteractionEnabled = false
            btnEndtime.isUserInteractionEnabled = false
            btnStartTime.isUserInteractionEnabled = false
            btnWeekdays.isUserInteractionEnabled = false
            btnAlldays.isUserInteractionEnabled = false
            
            
            
            //for testing
            //            btnCurrency.isUserInteractionEnabled = true
            //            tfofConsulationFee.isUserInteractionEnabled = true
            
            tfofConsulationFee.isUserInteractionEnabled = false
            btnCurrency.isUserInteractionEnabled = false
            collectionofWeekdays.reloadData()
            
            
            
        }else{
            
            //collectionofWeekdays.isHidden = true
            collectionofWeekdays.isUserInteractionEnabled = true
            btnnoofPersons.isUserInteractionEnabled = true
            btnEndtime.isUserInteractionEnabled = true
            btnStartTime.isUserInteractionEnabled = true
            btnWeekdays.isUserInteractionEnabled = true
           // btnAlldays.isUserInteractionEnabled = true
            tfofConsulationFee.isUserInteractionEnabled = true
            btnCurrency.isUserInteractionEnabled = true
            btnof15Days.isUserInteractionEnabled = true
            btnof45Days.isUserInteractionEnabled = true
            if arrofSupporteDays.count == arrofWeekDays.count {
                btnAlldays.isUserInteractionEnabled = true
            } else {
                btnAlldays.isUserInteractionEnabled = false
            }
        }
        
        
        
    }
    
    
    func loadBindData(){
        
        calltoGetDocAvailabilityAPI()
        
    }
    
    func loadSearchClinincData(){
        //  let arrofResponse = dictOfClinicInfo.object(forKey: AddClinicBasicProfile.APIResponse.data) as! NSDictionary
        /*{
         addOn = "2018-02-23 11:35:27";
         clinicAvailableDays = "Sat,Fri,Thu,Wed,Tue,Mon,Sun";
         clinicEveningTimeFrom = "";
         clinicEveningTimeTo = "";
         clinicMorningTimeFrom = "10:00 am";
         clinicMorningTimeTo = "5:00 pm";
         clinicRegNo = "";
         clinicState = "";
         hospRef = pIw5kjl22dLcw45f;
         hospitalAbout = "";
         hospitalAddress = shjsjsjjs;
         hospitalBranchName = gopi;
         hospitalCity = 22269;
         hospitalEmailAddress = "gopi@gmail.com";
         hospitalFaxNo = "";
         hospitalHelpLinePhone = 9490851731;
         hospitalId = 129;
         hospitalName = "Gopi test";
         hospitalPhone = 9490851731;
         hospitalPinCode = 500032;
         hospitalStatus = 1;
         hospitalWebsite = "";
         latitude = "";
         longitude = "";
         parentUserRef = pl0vR7UHHBZht62q;
         phonePrefix = 91;
         userRef = pIw5kjl22dLcw45f;
         }
         */
        
        // print(dicotfClinincTimings)
        
        
        let startTimingStr = String(describing:dicotfClinincTimings.TabiibDocObjectForKey(forKey: getDocTiming.APIResponse.clinicMorningTimeFrom ))
        let endTimingStr = String(describing:dicotfClinincTimings.TabiibDocObjectForKey(forKey: getDocTiming.APIResponse.clinicMorningTimeTo))
        
        let selectedDaysInfo = String(describing:dicotfClinincTimings.TabiibDocObjectForKey(forKey: getDocTiming.APIResponse.clinicAvailableDays))
        
        
        setUserInteactionsasperClinincTimings(startTimingStr,endTimingStr,selectedDaysInfo)
        
    }
    
    
    
    func ClinicInfoTimingData() {
        
        let arrofResponse = dictOfClinicInfo.object(forKey: AddClinicBasicProfile.APIResponse.data) as! NSDictionary
        let startTimingStr = String(describing:arrofResponse.TabiibDocObjectForKey(forKey: AddClinicBasicProfile.APIRequest.clinicFromTime ))
        let endTimingStr = String(describing:arrofResponse.TabiibDocObjectForKey(forKey: AddClinicBasicProfile.APIRequest.clinicToTime))
        
        let selectedDaysInfo = String(describing:arrofResponse.TabiibDocObjectForKey(forKey: AddClinicBasicProfile.APIRequest.clinicAvailableDays))
        
        setUserInteactionsasperClinincTimings(startTimingStr,endTimingStr,selectedDaysInfo)
        
    }
    
    func setUserInteactionsasperClinincTimings(_ startTimingStr : String, _ endTimingStr : String,_ selectedDaysInfo : String ){
        
        
        
        docStartDate = startTimingStr.getStringTimeToDate()
        docEndDate = endTimingStr.getStringTimeToDate()
       
        startTimePicker.minimumDate = docStartDate
        startTimePicker.maximumDate = docEndDate
        endTimePicker.minimumDate = docStartDate
        endTimePicker.maximumDate = docEndDate
        
        let arrayOfDays = selectedDaysInfo.components(separatedBy: ",")
        
        arrofSelectedDays.removeAll()
        
        for strObj in arrayOfDays {
            if arrofWeekDays.contains(strObj ){
                arrofSelectedDays.append(arrofWeekDays.index(of: strObj)!)
            }
        }
        
        if arrofSelectedDays.count == 7 {
            isAlldaysSelected = true
            allDaysSlected()
            btnAlldays.isUserInteractionEnabled = true
            btnWeekdays.setBackgroundImage(UIImage.init(named: ""), for: .normal)
            btnAlldays.setBackgroundImage(UIImage.init(named: "btn_backgrund"), for: .normal)
            
            btnAlldays.layer.borderColor = UIColor.clear.cgColor
            btnWeekdays.layer.borderColor = Constatns.WeekDaysColour().cgColor
            
            btnAlldays.setTitleColor(UIColor.white, for: .normal)
            btnWeekdays.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
            
        } else {
            
            isAlldaysSelected = false
            
            btnAlldays.isUserInteractionEnabled = false
            btnWeekdays.setBackgroundImage(UIImage.init(named: "btn_backgrund"), for: .normal)
            btnAlldays.setBackgroundImage(UIImage.init(named: ""), for: .normal)
            
            btnWeekdays.layer.borderColor = UIColor.clear.cgColor
            btnAlldays.layer.borderColor = Constatns.WeekDaysColour().cgColor
            
            btnAlldays.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
            btnWeekdays.setTitleColor(UIColor.white, for: .normal)
            
            topSpaceFromView.constant = 120
            collectionofWeekdays.isHidden = false
            collectionofWeekdays.reloadData()
        }
        
    }
    
    
    
    @objc func validTxt(_ text : UITextField){
        
        
        if text == tfofConsulationFee  {
            isFromExisting = false
            self.validateTextField1(text: text)
        }
        
    }
    
    func error(withLocalizedDescription localizedDescription: String) -> Error? {
        let userInfo = [NSLocalizedDescriptionKey: localizedDescription]
        return NSError(domain: MFDemoErrorDomain as? String ?? "", code: Int(MFDemoErrorCode), userInfo: userInfo)
    }
    
    func validateTextField1(text : UITextField) {
        var error: Error? = nil
        
        if text == tfofConsulationFee{
            if !textField4IsValid() {
                let ser = NSLocalizedString("please enter Consultation Fee...", comment: "")
                error = self.error(withLocalizedDescription: ser)
            }
            tfofConsulationFee.setError(error, animated: true)
        }
    }
    
    
    func textField4IsValid() -> Bool {
        return (tfofConsulationFee.text?.count)! > 0
    }
    
    
    
    @IBAction func btnPickerCancelClicked(_ sender: Any) {
        
        viewofTimePicker.isHidden = true
        viewofCurrencyPicker.isHidden = true
    }
    
    @IBAction func btnPickerDoneClicked(_ sender: Any) {
        
        if strSelectedTime == "S" {
            //print(startTimePicker.date)
            selectedStartTime = startTimePicker.date.getServerDateFormat()
            btnStartTime.setTitle(startTimePicker.date.getServerDateFormat(), for: .normal)
            //added --for clinic timings logic
            endTimePicker.minimumDate = startTimePicker.date.addingTimeInterval(60*60)
            if selectedEndTime != nil && selectedEndTime.isEmpty == false {
                if selectedEndTime.getStringTimeToDate().compare(startTimePicker.date) != ComparisonResult.orderedDescending {
                    selectedEndTime = ""
                    Utilities.sharedInstace.showAlertviewWithMessage("Please Select Endtime")
                    btnEndtime.setTitle("End Time", for: .normal)
                    
                }
            }
        }
        else{
            // print(endTimePicker.date)
            selectedEndTime = endTimePicker.date.getServerDateFormat()
            btnEndtime.setTitle(endTimePicker.date.getServerDateFormat(), for: .normal)
            
            //added --- for clininc timings logic
            if selectedStartTime != nil && selectedStartTime.isEmpty == false {
                if selectedStartTime.getStringTimeToDate().compare(endTimePicker.date) != ComparisonResult.orderedAscending {
                    selectedStartTime = ""
                    Utilities.sharedInstace.showAlertviewWithMessage("Please Select Starttime")
                    btnStartTime.setTitle("Start Time", for: .normal)
                }
            }
        }
        if startTimePicker.date >= endTimePicker.date.addingTimeInterval(-59.0 * 60.0) {
            selectedEndTime = ""
            Utilities.sharedInstace.showAlertviewWithMessage("Please Select minimum one hour")
            btnEndtime.setTitle("End Time", for: .normal)
        }
        
        isFromExisting = false
        viewofCurrencyPicker.isHidden = true
        viewofTimePicker.isHidden = true
     }
    
    @IBAction func btn15DaysClicked(_ sender : Any){
        
        allTextFieldResignResp()
        
        viewofCurrencyPicker.isHidden = true
        viewofTimePicker.isHidden = true
        
        if btn45DaysBool == true {
            btn45DaysBool = false
            btnof45Days.setBackgroundImage(UIImage.init(named: ""), for: .normal)
            btnof45Days.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
        }
        
        
        if btn15DaysBool == false {
            btn15DaysBool = true
            btnof15Days.setBackgroundImage(UIImage.init(named: "btn_backgrund2"), for: .normal)
            btnof15Days.setTitleColor(UIColor.white, for: .normal)
            
        }else{
            btn15DaysBool = false
            btnof15Days.setBackgroundImage(UIImage.init(named: ""), for: .normal)
            btnof15Days.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
        }
        
        isFromExisting = false
        selectedNumberofDays = "15"
    }
    
    @IBAction func btn45DaysClicked(_ sender : Any){
        
        allTextFieldResignResp()
        
        viewofCurrencyPicker.isHidden = true
        viewofTimePicker.isHidden = true
        
        if btn15DaysBool == true {
            btn15DaysBool = false
            btnof15Days.setBackgroundImage(UIImage.init(named: ""), for: .normal)
            btnof15Days.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
        }
        
        if btn45DaysBool == false {
            btn45DaysBool = true
            btnof45Days.setBackgroundImage(UIImage.init(named: "btn_backgrund2"), for: .normal)
            btnof45Days.setTitleColor(UIColor.white, for: .normal)
        }else{
            btn45DaysBool = false
            btnof45Days.setBackgroundImage(UIImage.init(named: ""), for: .normal)
            btnof45Days.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
        }
        
        
        
        isFromExisting = false
        selectedNumberofDays = "30"
    }
    
    
    
    @IBAction func btnEndTimeClicked(_ sender: Any) {
        
        allTextFieldResignResp()
        
        endTimePicker.minimumDate = startTimePicker.date.addingTimeInterval(60*60)
        
        strSelectedTime = "E"
        viewofCurrencyPicker.isHidden = true
        viewofTimePicker.isHidden = false
        startTimePicker.isHidden = true
        endTimePicker.isHidden = false
        
        isFromExisting = false
    }
    
    
    @IBAction func btnStartTimeClicked(_ sender: Any) {
        
        allTextFieldResignResp()
        
        if docStartDate == nil{
            docStartDate = Date()
        }
        
        startTimePicker.setDate(docStartDate, animated: true)
        
        strSelectedTime = "S"
        viewofCurrencyPicker.isHidden = true
        viewofTimePicker.isHidden = false
        startTimePicker.isHidden = false
        endTimePicker.isHidden = true
        
        isFromExisting = false
    }
    
    
    
    @IBAction func btnWeekDaysClicked(_ sender: Any) {
        allTextFieldResignResp()
        
        btnWeekdays.setBackgroundImage(UIImage.init(named: "btn_backgrund"), for: .normal)
        btnAlldays.setBackgroundImage(UIImage.init(named: ""), for: .normal)
        
        btnWeekdays.layer.borderColor = UIColor.clear.cgColor
        btnAlldays.layer.borderColor = Constatns.WeekDaysColour().cgColor
        
        btnAlldays.setTitleColor(Constatns.WeekDaysColour(), for: .normal)
        btnWeekdays.setTitleColor(UIColor.white, for: .normal)
        
        topSpaceFromView.constant = 120
        
        isAlldaysSelected = false
        collectionofWeekdays.isHidden = false
        
        isFromExisting = false
        
        collectionofWeekdays.reloadData()
    }
    
    
    @IBAction func btnAlldaysClicked(_ sender: Any) {
        
        allTextFieldResignResp()
        isAlldaysSelected = true
        allDaysSlected()
        
    }
    
    
    
    @IBAction func btnCurrencyPickerDoneClicked(_ sender : Any){
        
        viewofCurrencyPicker.isHidden = true
        viewofTimePicker.isHidden = true
        
        if selectedPicker == NoofPersons{
            
            if isPickerSelectionDone == false {
                selectedNoofPerPicker = arrofPickerData[0]
            }else{
                selectedNoofPerPicker = selectedNoofPers
            }
            
            
            let strofperperosnNumber = "\(selectedNoofPers!) " + NSLocalizedString("Persons per hour", comment: "")
            btnnoofPersons.setTitle(strofperperosnNumber, for: .normal)
        }else{
            btnCurrency.setTitle(selectedCurrency, for: .normal)
        }
        
        lblofbtnCurrency.backgroundColor = Constatns.UnSelectThemeColour()
    }
    
    
    @IBAction func btnCurrencyPickerCancelClicked(_ sender : Any){
        viewofCurrencyPicker.isHidden = true
        viewofTimePicker.isHidden = true
        lblofbtnCurrency.backgroundColor = Constatns.UnSelectThemeColour()
    }
    
    
    @IBAction func btnNoofPersonsClicked(_ sender: Any) {
        allTextFieldResignResp()
        selectedPicker = NoofPersons
        arrofPickerData.removeAll()
        arrofPickerData = [persons1,persons2,persons3,persons4]
        
        selectedNoofPers = arrofPickerData[0]
        
        pickerofCurrency.reloadAllComponents()
        viewofCurrencyPicker.isHidden = false
        
    }
    
    @IBAction func btnCurrencyClicked(_ sender: Any) {
        allTextFieldResignResp()
        
        selectedPicker = Currency
        
        arrofPickerData.removeAll()
        
        if let loadedArrayObjs = UserDefaults.standard.array(forKey: "countries")  {
            
            for item in 0 ..< loadedArrayObjs.count {
                
                let dic = loadedArrayObjs[item] as! NSDictionary
                
                let CountryName = dic.TabiibDocObjectForKey(forKey: getCountriesList.APIResponse.Currency)
                
                arrofPickerData.append(CountryName)
                
                // selectedCurrency = arrofPickerData[0]
                
                
            }
        }
        
        lblofbtnCurrency.backgroundColor = Constatns.ThemeColour()
        
        pickerofCurrency.reloadAllComponents()
        viewofCurrencyPicker.isHidden = false
        viewofTimePicker.isHidden = true
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
    
    
    func callforsetDoctortAvailbilityAPI(){
        
        if viewofTimePicker.isHidden == false {
            viewofTimePicker.isHidden = true
        }
        
        if viewofCurrencyPicker.isHidden == false {
            viewofCurrencyPicker.isHidden = true
        }
        
        
        getNumberofPersmonsperHour()
        
     //   APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      setDocTiming.APIRequest.hospRef : selectedclinicRef,
                                      setDocTiming.APIRequest.days :selectedWeekDays,
                                      setDocTiming.APIRequest.startMorningTime : selectedStartTime,
                                      setDocTiming.APIRequest.endMorningTime : selectedEndTime,
                                      setDocTiming.APIRequest.morningSlotTime : strMrgSlotTime,
                                      setDocTiming.APIRequest.morningPersonPerHour : selectedNoofPerPicker,
                                      setDocTiming.APIRequest.morningStatus : "1",
                                      setDocTiming.APIRequest.currency : selectedCurrency,
                                      setDocTiming.APIRequest.consulationFee : tfofConsulationFee.text!,
                                      setDocTiming.APIRequest.ValidityDays_AvailableTime : selectedNumberofDays]
        
        
        //   print(param)
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.setDocTiming, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //   print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                if let delegateObj = self.delegate {
                    delegateObj.submitClicked()
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
                self.isError = "docavail"
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    
    
    func validateInputFields() -> Bool {
        
        var ifAllSuccess : Bool = true
        
        var error: Error? = nil
        
        if tfofConsulationFee.text!.isEmpty {
            let ser = NSLocalizedString("please enter clinic consulationFee...", comment: "")
            error = self.error(withLocalizedDescription: ser)
            tfofConsulationFee.setError(error, animated: true)
            ifAllSuccess = false
        }
        
        return ifAllSuccess
    }
    
    
    @IBAction func btnSubmitClicked(_ sender: Any){
        allTextFieldResignResp()
        
        
        if isFromExisting == true{
            
            if let delegateObj = self.delegate {
                delegateObj.submitClicked()
            }
            
        }else{
            
            if validateInputFields() {
                
                if isAlldaysSelected == false {
                    
                    if selectedCurrency == ""{
                        let ser = NSLocalizedString("Select currency", comment: "")
                        Utilities.sharedInstace.showAlertviewWithMessage(ser)
                    }else if arrofRequestWeekDays.count == 0 {
                        let ser = NSLocalizedString("Select atleast one week day", comment: "")
                        Utilities.sharedInstace.showAlertviewWithMessage(ser)
                    }
                    else if selectedStartTime == "" || selectedEndTime == "" {
                        let ser = NSLocalizedString("Select Timings", comment: "")
                        Utilities.sharedInstace.showAlertviewWithMessage(ser)
                        
                    }else if startTimePicker.date > endTimePicker.date{
                        let serv = NSLocalizedString("please enter end time is greter than start time", comment: "")
                        Utilities.sharedInstace.showAlertviewWithMessage(serv)
                    }
                    else if selectedNoofPerPicker == "" {
                        let ser = NSLocalizedString("Select no of persons per hour", comment: "")
                        Utilities.sharedInstace.showAlertviewWithMessage(ser)
                    }
                    else if btn15DaysBool == false && btn45DaysBool == false {
                        let ser = NSLocalizedString("Select  no of days configuration", comment: "")
                        Utilities.sharedInstace.showAlertviewWithMessage(ser)
                    }else{
                        
                        selectedWeekDays = selectedWeekDays23()
                        callforsetDoctortAvailbilityAPI()
                    }
                    
                }else{
                    
                    selectedWeekDays = getAllDays()
                    if selectedCurrency == ""{
                        let ser = NSLocalizedString("Select currency", comment: "")
                        Utilities.sharedInstace.showAlertviewWithMessage(ser)
                    }
                    else if selectedStartTime == "" || selectedEndTime == "" {
                        let ser = NSLocalizedString("Select Timings", comment: "")
                        Utilities.sharedInstace.showAlertviewWithMessage(ser)
                        
                    }else if startTimePicker.date > endTimePicker.date{
                        let serv = NSLocalizedString("please enter end time is greter than start time", comment: "")
                        Utilities.sharedInstace.showAlertviewWithMessage(serv)
                    }
                    else if selectedNoofPerPicker == "" {
                        let ser = NSLocalizedString("Select no of persons per hour", comment: "")
                        Utilities.sharedInstace.showAlertviewWithMessage(ser)
                    }
                    else if btn15DaysBool == false && btn45DaysBool == false {
                        let ser = NSLocalizedString("Select  no of days configuration", comment: "")
                        Utilities.sharedInstace.showAlertviewWithMessage(ser)
                    }
                    else{
                        
                        callforsetDoctortAvailbilityAPI()
                    }
                }
                
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

extension DoctorSetAvailabilityTimingsViewController : UIPickerViewDataSource,UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrofPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrofPickerData[row]
    }
    
    //    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    //
    //        let titleData = arrofPickerData[row]
    //
    //        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Lato", size: 20.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
    //
    //        return myTitle
    //    }
    
    func getNumberofPersmonsperHour(){
        
        if selectedNoofPers == "1" {
            strMrgSlotTime  = "00:60"
        }
        else if selectedNoofPers == "2" {
            strMrgSlotTime  = "00:30"
        }
        else if selectedNoofPers == "3" {
            strMrgSlotTime  = "00:20"
        }
        else if selectedNoofPers == "4" {
            strMrgSlotTime  = "00:15"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if selectedPicker == Currency {
            selectedCurrency = arrofPickerData[row]
        }
        else{
            isPickerSelectionDone = true
            selectedNoofPers = arrofPickerData[row]
        }
        
        
        
    }
}


extension DoctorSetAvailabilityTimingsViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrofWeekDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let weekdayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekdayCollectionViewCell", for: indexPath) as! WeekdayCollectionViewCell
        weekdayCell.lblofWeekDays.text = String(describing:arrofWeekDays[indexPath.row])
        weekdayCell.contentView.tag = indexPath.row
        weekdayCell.lblofWeekDays.tag = indexPath.row
        weekdayCell.imgofBg.tag = indexPath.row
        weekdayCell.lblofWeekDays.tag = indexPath.row
        
   
         //for clinic timings logic
         if arrofSelectedDays.contains(indexPath.row) == false {
         weekdayCell.lblofWeekDays.backgroundColor = UIColor.lightGray
         
         } else {
         weekdayCell.lblofWeekDays.backgroundColor = UIColor.clear
         }
        
        
        if arrofRequestWeekDays.contains(indexPath.row) {
            //for clinic tiings logic
            weekdayCell.lblofWeekDays.backgroundColor = UIColor.clear
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
        
        return weekdayCell
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       
         //for clininc timings logic
         if arrofSelectedDays.contains(indexPath.item) == false {
         Utilities.sharedInstace.showAlertviewWithMessage("Clininc is not available for this day.")
         return
         }
        
        
        if arrofRequestWeekDays.contains(indexPath.row) {
            arrofRequestWeekDays.remove(indexPath.row)
        }
        else{
            arrofRequestWeekDays.add(indexPath.row)
        }
        
        collectionofWeekdays.reloadData()
        
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





