//
//  ProPersonalViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import MaterialTextField
import CoreData

protocol PersonalDetailsContinueDelegate {
    func continueClicked()
}

class ProPersonalViewController: UIViewController,ErrorProtocalDelegate,PersonalDetailsContinueDelegate,UITextFieldDelegate {
    
    func continueClicked() {
        
    }
    
    @IBOutlet var scrollofContent: UIScrollView!
    @IBOutlet var btnofGender: UIButton!
    @IBOutlet var lblofGenderSelection: UILabel!
    @IBOutlet var tfofName: MFTextField!
    @IBOutlet var tfofEmail: MFTextField!
    
    @IBOutlet var btnofPrefix: UIButton!
    @IBOutlet var lblofPrefixSelection: UILabel!
    @IBOutlet var tfofMobileNumber: MFTextField!
    
    @IBOutlet var btnofSpeciality: UIButton!
    
    @IBOutlet var btnofYears: UIButton!
    @IBOutlet var btnofMonth: UIButton!
    
    
    @IBOutlet var tvofInformation: UITextView!
    
    @IBOutlet var viewofPicker : UIView!
    @IBOutlet var pickerofData : UIPickerView!
    
    @IBOutlet var tfOfMonth : UITextField!
    @IBOutlet var tfOfYear : UITextField!
    
    var isPickerSelection : String!
    var arrofPickerData : [String] = [String]()
    
    var arrofOptions : [String] = [String]()
    
    var delegate : PersonalDetailsContinueDelegate!
    var singtonObj : SingleTonClass!
    
    //constatns
    let Gender = "Gender"
    let Speciality = "Speciality"
    let ExpYear =  "ExpYear"
    let ExpMonth = "ExpMonth"
    
    let strMr = NSLocalizedString("Mr.", comment: "")
    let strMiss = NSLocalizedString("Ms.", comment: "")
    let strMrs = NSLocalizedString("Mrs.", comment: "")
    
    //    let namePlaceHolder = NSLocalizedString("Your Name", comment: "")
    //    let emailPlaceHolder = NSLocalizedString("Your Email", comment: "")
    //    let mobilePlaceHolder = NSLocalizedString("Your MobileNumber", comment: "")
    //    let specialityDefaulttext = NSLocalizedString("Speciality", comment: "")
    //    let yearsofExp = NSLocalizedString("Exp Years", comment: "")
    //    let monthsofExp = NSLocalizedString("Exp Months", comment: "")
    //    let informationTest = NSLocalizedString("Information", comment: "")
    
    var strofNamePrefix : String! = "Mr."
    var strofExpYears : String! = "0"
    var strofExpMonths : String! = "1"
    var strPrefix : String! = "91"
    
    var arrofSelectedSpecilacations : NSMutableArray!
    var istoSendApiRequest : Bool = false
    
  
    
    @IBOutlet var btnofArrowIs : UIButton!
    var isError : String = ""
    //    var arrofPrefix : NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnofPrefix.isUserInteractionEnabled = false
        arrofSelectedSpecilacations = NSMutableArray.init()
        arrofOptions = [strMr,strMiss,strMrs]
        
        
        viewofPicker.isHidden = true
        isPickerSelection = ""
        singtonObj = SingleTonClass.SharedInstance
        
        tfofName.delegate = self
        tfofEmail.delegate = self
        tfofMobileNumber.delegate = self
        
        tfofName.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfofEmail.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfofMobileNumber.isUserInteractionEnabled = false
        
        if UserDefaultStore.selectedLanguage == "1" {
            //arabic
            btnofArrowIs.setImage(UIImage.init(named: "Back"), for: .normal)
        }else{
            //english
            // btnofArrowIs.setImage(UIImage.init(named: "Back"), for: .normal)
            
        }
        //  tfofMobileNumber.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        
//        if Connectivity.isCheckForNewwork() == false {
//            fetchData()
//        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let name = NSLocalizedString("Name", comment: "")
        let email = NSLocalizedString("Email ID", comment: "")
        let mobile = NSLocalizedString("Mobile Number", comment: "")
        
        tfofMobileNumber.placeholder = mobile
        tfofEmail.placeholder = email
        tfofName.placeholder = name
       
//        if Connectivity.isCheckForNewwork() == false {
//            fetchData()
//        }
    }
    
    func allTextFieldResignResp(){
        
        if tfofMobileNumber.isFirstResponder{
            tfofMobileNumber.resignFirstResponder()
        }else if tfofName.isFirstResponder{
            tfofName.resignFirstResponder()
        }else if tfofEmail.isFirstResponder{
            tfofEmail.resignFirstResponder()
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfofName.resignFirstResponder()
        tfofEmail.resignFirstResponder()
        tfofMobileNumber.resignFirstResponder()
    }
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        animateViewMoving(up: true, moveValue: 100)
    //    }
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //        animateViewMoving(up: false, moveValue: 100)
    //    }
    
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
    
    
    
    func textField1IsValid() -> Bool {
        
        let boolValue = Utilities.sharedInstace.validateEmail(emailAddress:tfofEmail.text!)
        return boolValue
    }
    
    func textField2IsValid() -> Bool {
        return (tfofName.text?.count)! > 0
    }
    
    //    func textField3IsValid() -> Bool {
    //
    //        if strPrefix == "91"{
    //            return (tfofMobileNumber.text?.count)! < 10
    //        }else if strPrefix == "971"{
    //            return (tfofMobileNumber.text?.count)! < 10
    //        }else if strPrefix == "966"{
    //            return (tfofMobileNumber.text?.count)! < 10
    //        }else{
    //            return (tfofMobileNumber.text?.count)! < 10
    //        }
    //    }
    
    func error(withLocalizedDescription localizedDescription: String) -> Error? {
        let userInfo = [NSLocalizedDescriptionKey: localizedDescription]
        return NSError(domain: MFDemoErrorDomain as? String ?? "", code: Int(MFDemoErrorCode), userInfo: userInfo)
    }
    
    @objc func validTxt(_ text : UITextField){
        
        var error: Error? = nil
        
        if text == tfofName{
            if !textField2IsValid() {
                let server = NSLocalizedString("please enter Name...", comment: "")
                
                error = self.error(withLocalizedDescription: server)
            }
            tfofName.setError(error, animated: true)
        }
        else if text == tfofEmail{
            if !textField1IsValid() {
                let server = NSLocalizedString("please enter valid Email id...", comment: "")
                error = self.error(withLocalizedDescription: server)
                
            }
            tfofEmail.setError(error, animated: true)
        }
        
        istoSendApiRequest = true
        
        //        else if text == tfofMobileNumber{
        //            if !textField3IsValid() {
        //                error = self.error(withLocalizedDescription: "please enter MobileNumber...")
        //            }
        //            tfofMobileNumber.setError(error, animated: true)
        //        }
    }
    
    
  
    
    public func bindProfileData(){
        
        strofNamePrefix = singtonObj.UserObjct.NamePrefix
        strofExpYears = singtonObj.UserObjct.ExpYear
        strofExpMonths  = singtonObj.UserObjct.ExpMonth
        let strofNamePRefix = singtonObj.UserObjct.NamePrefix
        tfofName.text = singtonObj.UserObjct.Name
        btnofGender.setTitle(NSLocalizedString(strofNamePRefix!, comment: ""), for: .normal)
        tfofEmail.text = singtonObj.UserObjct.EmailId
        btnofPrefix.setTitle("+" + singtonObj.UserObjct.MobileNumeberPrefix, for: .normal)
        strPrefix = singtonObj.UserObjct.MobileNumeberPrefix
        tfofMobileNumber.text = singtonObj.UserObjct.MobileNumeber
        tfOfYear.text = singtonObj.UserObjct.ExpYear + " " + NSLocalizedString("Years", comment: "")
        tfOfMonth.text = singtonObj.UserObjct.ExpMonth + " " + NSLocalizedString("Months", comment: "")
        tvofInformation.text = singtonObj.UserObjct.Information
         if singtonObj.arrofSpecilazations.count > 0 {
            bindSpecilazions()
        }
        
    }
    
    public func loadUserProfileData(){
        
        strofNamePrefix = singtonObj.UserObjct.NamePrefix
        strofExpYears = singtonObj.UserObjct.ExpYear
        strofExpMonths  = singtonObj.UserObjct.ExpMonth
        let strofNamePRefix = singtonObj.UserObjct.NamePrefix
        tfofName.text = singtonObj.UserObjct.Name
        btnofGender.setTitle(NSLocalizedString(strofNamePRefix!, comment: ""), for: .normal)
        tfofEmail.text = singtonObj.UserObjct.EmailId
        btnofPrefix.setTitle("+" + singtonObj.UserObjct.MobileNumeberPrefix, for: .normal)
        strPrefix = singtonObj.UserObjct.MobileNumeberPrefix
        tfofMobileNumber.text = singtonObj.UserObjct.MobileNumeber
        //btnofSpeciality.setTitle(singtonObj.UserObjct.Speciality, for: .normal)
        //  btnofYears.setTitle(singtonObj.UserObjct.ExpYear, for: .normal)
        tfOfYear.text = singtonObj.UserObjct.ExpYear + " " + NSLocalizedString("Years", comment: "")
        // btnofMonth.setTitle(singtonObj.UserObjct.ExpMonth, for: .normal)
        tfOfMonth.text = singtonObj.UserObjct.ExpMonth + " " + NSLocalizedString("Months", comment: "")
        tvofInformation.text = singtonObj.UserObjct.Information
        
        
        //check if specilations exist
        if singtonObj.arrofSpecilazations.count == 0 {
            docSpecialisationAPI()
        }
        else{
            bindSpecilazions()
        }
        
        
        
    }
    
    func getParticulrSpelization(_ strSpeId : String) -> NSDictionary? {
        
        for case let dictofObj as NSDictionary in self.singtonObj.arrofSpecilazations
        {
            if String(describing:dictofObj.TabiibDocObjectForKey(forKey: DocSpecialisations.APIResponse.spId)) == strSpeId {
                return dictofObj
            }
        }
        return nil
    }
    
//
//    func saveSpecializationInCoreData(arr : NSArray) {
//
//        let dictofSpecializations = arr
//
//        let app = UIApplication.shared.delegate as! AppDelegate
//        let context = app.persistentContainer.viewContext
//
//
//            let newUser = NSEntityDescription.entity(forEntityName: SpecializationDetailsCoreDataList.EntityName.Specialization, in: context)!
//            let object = NSManagedObject(entity: newUser, insertInto: context)
//            let encodedObject : Data = NSKeyedArchiver.archivedData(withRootObject: dictofSpecializations)
//
//            object.setValue(encodedObject, forKey:  SpecializationDetailsCoreDataList.Attributes.specialization)
//
//
//            do {
//                try context.save()
//            } catch {
//                print("Failed saving")
//            }
//
//
//
//    }
//
//    func fetchData() {
//
//       var strofnSpecioaltions : String! = ""
//
//        let app = UIApplication.shared.delegate as! AppDelegate
//        let context = app.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SpecializationDetailsCoreDataList.EntityName.Specialization)
//        do {
//            let results = try context.fetch(fetchRequest)
//            print(results)
//
//
//            if results.count != 0 {
//
//                for result in results {
//
//                    let data = (result as AnyObject).value(forKey: SpecializationDetailsCoreDataList.Attributes.specialization) as! NSData
//                    let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:data as Data)
//                    let arrayObject = unarchiveObject  as! NSArray
//                    print(arrayObject)
//                    if arrayObject.count > 0 {
//
//                        // for  dictofOb  in arrayObject {
//                        for i in 0...1 {
//                            let dicotfObj = arrayObject[i] as! NSDictionary
//                           let values = (dicotfObj as AnyObject).value(forKey: DocSpecialisations.APIResponse.spName) as! String
//                            strofnSpecioaltions.append(values)
//                            strofnSpecioaltions.append(",")
//                        }
//
////                        let finalStrng = String(strofnSpecioaltions.dropLast())
////                        let remainingString = String.init(format: "  %d more", strofnSpecioaltions.count - 2)
////
////                        strofnSpecioaltions.append(finalStrng)
////                        strofnSpecioaltions.append(" ")
////                        strofnSpecioaltions.append(remainingString)
//                        btnofSpeciality.setTitle(strofnSpecioaltions, for: .normal)
//
//                        break
//                    }
//
//                }
//
//            }
//
//
//
//        } catch {
//            let fetchError = error as NSError
//            print(fetchError)
//        }
//
//    }
    
    func fetchSpecializationData() {
         var strofnSpecioaltions : String! = ""
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ProfileDetailsCoreDataList.EntityName.ProfileDetails)
        
        do {
            let results = try context.fetch(fetchRequest)
            print(results)
            
            
            if results.count != 0 {
                
                for result in results {
                    
                    let data = (result as AnyObject).value(forKey: ProfileDetailsCoreDataList.Attributes.personalDetails) as! NSData
                    let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:data as Data)
                    let arrayObject = unarchiveObject  as! NSDictionary
                    if arrayObject.count > 0 {
                        
                        
                        let arrofSpelizations = arrayObject.object(forKey: UserProfile.APIResponse.special) as! NSArray
                            
                            for i in 0...1 {
                                let dicotfObj = arrofSpelizations[i] as! NSDictionary
                                let values = (dicotfObj as AnyObject).value(forKey: DocSpecialisations.APIResponse.spName) as! String
                                strofnSpecioaltions.append(values)
                                strofnSpecioaltions.append(",")
                            }
                        
                     
                            btnofSpeciality.setTitle(strofnSpecioaltions, for: .normal)
                        
                        
                        break
                    }
                    
                }
                
            }
            
            
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    
    
    
    func bindSpecilazions(){
        
        // let arrofSelectedSpecilizations = NSMutableArray.init()
        
        for case let dicofObj as NSDictionary in singtonObj.UserObjct.arrofSpelizations {
            
            let strofSpeliId = String(describing:dicofObj.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.sepcialId))
            let dictofObj = getParticulrSpelization(strofSpeliId)
            
            
            if !arrofSelectedSpecilacations.contains(dictofObj) {
                arrofSelectedSpecilacations.add(dictofObj!)
                
            }
            
        }
        
        if arrofSelectedSpecilacations.count > 2 {
            let strofname = getFirst2Specialtionname(arrofSelectedSpecilacations)
            self.btnofSpeciality.setTitle(strofname, for: .normal)
        }
        else{
            let strofName = getSpecilazionNames(arrofSelectedSpecilacations)
            self.btnofSpeciality.setTitle(strofName, for: .normal)
        }
    }
    
    @IBAction func btnCancelPickerClicked(_ sender : Any){
        viewofPicker.isHidden = true
    }
    
    @IBAction func btnDoneinPickerClicked(_ sender : Any) {
        
        viewofPicker.isHidden = true
        istoSendApiRequest = true
        
        if isPickerSelection == Gender {
            singtonObj.UserObjct.NamePrefix = strofNamePrefix
            btnofGender.setTitle(NSLocalizedString(strofNamePrefix, comment: ""), for: .normal)
            lblofGenderSelection.backgroundColor = Constatns.profileColor()
        }
            //        else if isPickerSelection == Speciality {
            //            singtonObj.UserObjct.Speciality = (btnofSpeciality.titleLabel?.text)!
            //        }
        else if isPickerSelection == ExpYear {
            singtonObj.UserObjct.ExpYear = strofExpYears
            tfOfYear.text = strofExpYears + " " +  NSLocalizedString("Years", comment: "")
            //btnofYears.setTitle(strofExpYears, for: .normal)
        }
        else if isPickerSelection == ExpMonth {
            singtonObj.UserObjct.ExpMonth = strofExpMonths
            tfOfMonth.text = strofExpMonths + " " + NSLocalizedString("Months", comment: "")
            // btnofMonth.setTitle(strofExpMonths, for: .normal)
        }
        
    }
    
    @IBAction func btnofGenderClicked(_ sender : Any){
        allTextFieldResignResp()
        isPickerSelection = Gender
        arrofPickerData.removeAll()
        arrofPickerData = [strMr,strMiss,strMrs]
        pickerofData.reloadAllComponents()
        viewofPicker.isHidden = false
        lblofGenderSelection.backgroundColor = Constatns.ThemeColour()
    }
   
  
    
    //MARK:- Doctor Specialization api
    func docSpecialisationAPI()
        
    {
        
      //  APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.docSpecialization, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //   print(response)
            
            // let success = (JSONDictionary as AnyObject).value(forKey:"success") as! String
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                let arrofSpelicartions = dictofResonse.object(forKey: DocSpecialisations.APIResponse.data) as! NSArray
                
                self.singtonObj.arrofSpecilazations = NSMutableArray.init(array: arrofSpelicartions)
                
     
                
                self.bindSpecilazions()
                
                
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
    
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        if self.isError == "docspec"{
            docSpecialisationAPI()
        }else{
            callforUpdateProfile()
        }
        
    }
    
    @IBAction func btnofSpecialityClicked(_ sender: Any) {
        allTextFieldResignResp()
        let spelicationVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "SpelizationSelectionViewController") as! SpelizationSelectionViewController
        if arrofSelectedSpecilacations.count > 0 {
            spelicationVc.arrofCopyofSelctedSpeci  = arrofSelectedSpecilacations
        }
        spelicationVc.isFromUpdateProfile = true
        spelicationVc.delegate = self
        self.navigationController?.pushViewController(spelicationVc, animated: true)
        
    }
    
    @IBAction func btnofYearClicked(_ sender: Any) {
        allTextFieldResignResp()
        isPickerSelection = ExpYear
        //        let cal = NSCalendar.current
        //        let date = Date()
        //        let year = cal.component(.year, from: date)
        var arrofYears = [String]()
        //        print(year)
        //        for i in 1...30 {
        //            arrofYears.append(String(Int(year - i)))
        //        }
        
        for i in 1...30 {
            arrofYears.append(String(Int(i)))
        }
        
        pickerofData.selectRow(0, inComponent: 0, animated: true)
        
        strofExpYears = String(describing:arrofYears[0])
        arrofPickerData.removeAll()
        arrofPickerData = arrofYears
        pickerofData.reloadAllComponents()
        viewofPicker.isHidden = false
        
    }
    
    
    @IBAction func btnofMonthClicked(_ sender: Any) {
        allTextFieldResignResp()
        isPickerSelection = ExpMonth
        var arrofMonths = [String]()
        
        for i in 1...11 {
            arrofMonths.append(String(Int(i)))
        }
        strofExpMonths = String(describing:arrofMonths[0])
        arrofPickerData.removeAll()
        arrofPickerData = arrofMonths
        
        pickerofData.selectRow(0, inComponent: 0, animated: true)
        
        pickerofData.reloadAllComponents()
        viewofPicker.isHidden = false
        
    }
    
  /*
    func fetchData() {
      
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ProfileDetailsCoreDataList.EntityName.ProfileDetails)
      //  let entityDescription = NSEntityDescription.entity(forEntityName:ProfileDetailsCoreDataList.EntityName.ProfileDetails, in: context)
       // fetchRequest.entity = entityDescription
        
        
        do {
            let results = try context.fetch(fetchRequest)
            print(results)
            
            
            if results.count != 0 {
                
               for result in results {
//                    let resultvalue = result as! NSDictionary
                let data = (result as AnyObject).value(forKey: ProfileDetailsCoreDataList.Attributes.personalDetails) as! NSData
                let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:data as Data)
                  //  let arrayObject = unarchiveObject as! NSArray

                    let arrayObject = unarchiveObject  as! NSDictionary
                  //  let resultOfPro = arrayObject[1]
                    if arrayObject.count > 0 {

                    let resultOfPro = arrayObject.value(forKey: "data") as! NSArray
                    let values = resultOfPro[0] as! NSDictionary

                    let EmailId =  values.value(forKey:UpdateBasicProfile.APIRequest.emailId)
                        print(EmailId as Any)
                    let namePrefix =  values.value(forKey:UpdateBasicProfile.APIRequest.namePrefix)
                    let Name =  values.value(forKey:UpdateBasicProfile.APIRequest.Name)
                    let year =  values.value(forKey:UpdateBasicProfile.APIRequest.year)
                    let month =  values.value(forKey:UpdateBasicProfile.APIRequest.month)
                    let docInformation = values.value(forKey:UpdateBasicProfile.APIRequest.docInformation)
                    let mobileNumber = values.value(forKey: "mobileNumber")
                    let mobilePrefix = values.value(forKey: "mobilePrefix")
                        


                        tfofName.text = Name as? String
                        btnofGender.setTitle(NSLocalizedString(namePrefix as! String, comment: ""), for: .normal)
                        tfofEmail.text = EmailId as? String
                        btnofPrefix.setTitle("+" + (mobilePrefix as! String), for: .normal)
                        strPrefix = mobilePrefix as! String
                        tfofMobileNumber.text = mobileNumber as? String
                        tfOfYear.text? = year as! String + " " + NSLocalizedString("Years", comment: "")
                        tfOfMonth.text? = month as! String + " " + NSLocalizedString("Months", comment: "")
                        tvofInformation.text = docInformation as! String

                        break
                    }
                
                }
                
            }
            
            
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
      
    }
   */
    
    func callforUpdateProfile(){
        /*{"ApiKey":"SKZHTiNhgR6G9TSl","userRef":"QmalxZn4UQEWfSq6","namePrefix":"Mrs.","Name":"",emailId":","sepcialId":[{"sepcialId":"1"}{"sepcialId":"2"}],"year":"2","month":"7","docInformation":"testttttt"}*/
        
    //    APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
    
        var strNamePrefix2 = "Mr."
        if strofNamePrefix == arrofOptions[0] {
            strNamePrefix2 = "Mr."
        }else if strofNamePrefix == arrofOptions[1] {
            strNamePrefix2 = "Ms."
        }else if strofNamePrefix == arrofOptions[2] {
            strNamePrefix2 = "Mrs."
        }
        
        let param : [String : Any] = [  APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                        APIRequestKeys.userRef : UserDefaultStore.userRef,
                                        UpdateBasicProfile.APIRequest.namePrefix :strNamePrefix2,
                                        UpdateBasicProfile.APIRequest.Name : tfofName.text!,
                                        UpdateBasicProfile.APIRequest.sepcialId : self.getRequestSpecilaztions(arrofSelectedSpecilacations),
                                        UpdateBasicProfile.APIRequest.year : strofExpYears!,
                                        UpdateBasicProfile.APIRequest.month : strofExpMonths!,
                                        UpdateBasicProfile.APIRequest.docInformation : tvofInformation.text!,
                                        UpdateBasicProfile.APIRequest.emailId :
                                            tfofEmail.text!]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.updateBasicProfile, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //    print(response)
            
            
            if Connectivity.isCheckForNewwork() == true {
              let dictofResonse = response as! NSDictionary

            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                self.singtonObj.UserObjct.isPersonalDataFilled = "1"
                
                if let delegate = self.delegate {
                    delegate.continueClicked()
                }
             
            }
            else{
                
                Utilities.sharedInstace.showAlertviewWithMessage(String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.error_message)))
                
            }
            }
        
            
        }) { (networkErr, messag) in
            APIServices.SharedInstance.hideProgress()
//            if Connectivity.isCheckForNewwork() == false {
//                self.fetchData()
//            }
            
//            if messag == unauthorised {
//
//                let unauth = NSLocalizedString("UnAuthorisedUser", comment: "")
//
//                let objofSweetAlrt = SweetAlerts()
//                objofSweetAlrt.isTapGestureReg = false
//                _ =  objofSweetAlrt.showAlert(unauth, style: .none, buttonTitle: NSLocalizedString("Okay", comment : ""), action: { (okay) in
//                    objofSweetAlrt.isTapGestureReg = false
//
//
//                    let loginVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                    UserDefaultStore.isLogined = "0"
//                    self.navigationController?.pushViewController(loginVC, animated: true)
//
//
//                })
//
//            }else{
//
//                let OopsVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
//
//                OopsVC.errorDelegate = self
//                self.isError = "updateprof"
//                if messag == NetworkErrorIssue{
//                    OopsVC.errorType = NetworkError
//                }
//                self.present(OopsVC, animated: true, completion: nil)
//            }
         }
    }
    
    
    
    
    @IBAction func btnContinueClicked(_ sender: Any) {
        
        if istoSendApiRequest == true {
            allTextFieldResignResp()
            callforUpdateProfile()
        }else{
            if let delegate = self.delegate {
                delegate.continueClicked()
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

extension ProPersonalViewController : SpelicilationsSelected {
    
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
            let remainingString = String.init(format: "  %d more", arrofSelectedOnces.count - 2)
            
            strofSelecteOnces.append(finalStrng)
            strofSelecteOnces.append(" ")
            strofSelecteOnces.append(remainingString)
           
            
        }
        
        
        return strofSelecteOnces
        
    }
    
    
    func selectedSpecilations(_ arrofSpecialicatos : NSMutableArray){
        
        //    print("selected specialization : \(arrofSpecialicatos)")
        
        arrofSelectedSpecilacations = arrofSpecialicatos
     //   self.saveSpecializationInCoreData(arr: arrofSelectedSpecilacations)
        
        if arrofSpecialicatos.count > 2 {
            let strofname = getFirst2Specialtionname(arrofSpecialicatos)
            self.btnofSpeciality.setTitle(strofname, for: .normal)
        }
        else{
            let strofName = getSpecilazionNames(arrofSpecialicatos)
            self.btnofSpeciality.setTitle(strofName, for: .normal)
        }
        
        istoSendApiRequest = true
    }
}

extension ProPersonalViewController : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        istoSendApiRequest = true
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tfofName {
            
            let currentCharacterCount = textField.text?.count ?? 0
            
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            
            return newLength <= Int(truncating: 25)
        }
        return true
    }
    
}

extension ProPersonalViewController : UIPickerViewDataSource,UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrofPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrofPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if isPickerSelection == Gender {
            strofNamePrefix = arrofPickerData[row]
            
        }
        else if isPickerSelection == ExpYear {
            strofExpYears = arrofPickerData[row]
            // btnofYears.setTitle(arrofPickerData[row], for: .normal)
        }
        else if isPickerSelection == ExpMonth {
            strofExpMonths = arrofPickerData[row]
            // btnofMonth.setTitle(arrofPickerData[row], for: .normal)
        }
        
    }
    
    
}




















