//
//  ProEducationalViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import MaterialTextField
import CoreData

protocol EductionalDetailsContinueDelegate {
    func continueEduClicked()
}

class ProEducationalViewController: UIViewController,ErrorProtocalDelegate,EductionalDetailsContinueDelegate,UITextFieldDelegate {
    
    func continueEduClicked() {
    }
    
    @IBOutlet var scrollofContent: UIScrollView!
    @IBOutlet var tfofHighestEducation: MFTextField!
    @IBOutlet var tfofSecondEducation: MFTextField!
    @IBOutlet var tfofUniversity: MFTextField!
    @IBOutlet var tfofMedicalRegistration: MFTextField!
    @IBOutlet var tfofMedicalRegisCouncilno: MFTextField!
    @IBOutlet var tfofRegistrationYear: MFTextField!
    
    var delegate : EductionalDetailsContinueDelegate!
    
    
    var istoSendApiRequest : Bool = false
    
    var strofRegistrationYear : String! = ""
    var singleTonObj : SingleTonClass!
    
    var isErrorOccur : Bool = false
    
    var yearShow : NSMutableArray!
    var strYear : String!
    
    @IBOutlet var viewOfPicker : UIView!
    @IBOutlet var yearPicker : UIPickerView!
    var isError : String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        singleTonObj = SingleTonClass.SharedInstance
        yearShow = NSMutableArray.init()
        
        let date = Date()
        let strOfYear = date.getYearName()
        let integ = Int(strOfYear)!
        
        for i in 1960 ..< integ{
            let str = String(i)
            yearShow.add(str)
        }
        
        let arrofRever = Array(yearShow.reversed())
        yearShow.removeAllObjects()
        yearShow.addObjects(from: arrofRever as [Any])
        strYear = String(describing:yearShow.object(at: 0))
        
        
        viewOfPicker.isHidden = true
        
        AllTextFieldDelegates()
        
        tfofHighestEducation.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfofSecondEducation.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfofUniversity.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfofMedicalRegistration.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfofMedicalRegisCouncilno.addTarget(self, action: #selector(validTxt(_:)), for: UIControlEvents.editingChanged)
        tfofRegistrationYear.addTarget(self, action: #selector(viewRepresentaion(_:)), for: UIControlEvents.editingDidBegin)
        // tfofRegistrationYear.addTarget(self, action: #selector(viewRepresentaion(_:)), for: UIControlEvents.editingDidEnd)
        
        
        //  toolbaraddedtoKeyboard()
//        if Connectivity.isCheckForNewwork() == false {
//            self.fetchData()
//        }
        
    }
    
    @objc func viewRepresentaion(_ text : UITextField){
        
        text.resignFirstResponder()
        viewOfPicker.isHidden = false
    }
    
    @IBAction func pickerDoneClicked(_ sender : Any){
        tfofRegistrationYear.text = strYear
        viewOfPicker.isHidden = true
        istoSendApiRequest = true
        
        var error: Error? = nil
        error = self.error(withLocalizedDescription: "")
        tfofRegistrationYear.setError(error, animated: true)
        
        
    }
    
    @IBAction func pickerCancelClicked(_ sender : Any){
        viewOfPicker.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let hdq = NSLocalizedString("Highest Educational Qualifcation", comment: "")
        let oeq = NSLocalizedString("Other Educational Qualification (Optional)", comment: "")
        let un = NSLocalizedString("University Name", comment: "")
        let mrn = NSLocalizedString("Medical Registration Number", comment: "")
        let mrc = NSLocalizedString("Medical Registration Council", comment: "")
        let ry = NSLocalizedString("Registration Year", comment: "")
        
        tfofHighestEducation.placeholder = hdq
        tfofSecondEducation.placeholder = oeq
        tfofUniversity.placeholder = un
        tfofMedicalRegistration.placeholder = mrn
        tfofMedicalRegisCouncilno.placeholder = mrc
        tfofRegistrationYear.placeholder = ry
//        if Connectivity.isCheckForNewwork() == false {
//            self.fetchData()
//        }
    }
    
    func AllTextFieldDelegates(){
        tfofHighestEducation.delegate = self
        tfofSecondEducation.delegate = self
        tfofUniversity.delegate = self
        tfofMedicalRegistration.delegate = self
        tfofMedicalRegisCouncilno.delegate = self
        tfofRegistrationYear.delegate = self
    }
    
    
    func allTextFieldResignResp(){
        
        if tfofUniversity.isFirstResponder{
            tfofUniversity.resignFirstResponder()
        }else if tfofSecondEducation.isFirstResponder{
            tfofSecondEducation.resignFirstResponder()
        }else if tfofHighestEducation.isFirstResponder{
            tfofHighestEducation.resignFirstResponder()
        }else if tfofRegistrationYear.isFirstResponder{
            tfofRegistrationYear.resignFirstResponder()
        }else if tfofMedicalRegistration.isFirstResponder{
            tfofMedicalRegistration.resignFirstResponder()
        }else if tfofMedicalRegisCouncilno.isFirstResponder{
            tfofMedicalRegisCouncilno.resignFirstResponder()
        }
        
        
    }
    func toolbaraddedtoKeyboard(){
        let numberToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            
            
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
             UIBarButtonItem.init(title: NSLocalizedString("Done", comment : ""), style: .plain, target: self, action: #selector(doneClicked)),
            
        ]
        numberToolbar.sizeToFit()
        tfofRegistrationYear.inputAccessoryView = numberToolbar
        
    }
    @objc func doneClicked(){
        if tfofRegistrationYear.isFirstResponder{
            tfofRegistrationYear.resignFirstResponder()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfofHighestEducation.resignFirstResponder()
        tfofSecondEducation.resignFirstResponder()
        tfofUniversity.resignFirstResponder()
        tfofMedicalRegistration.resignFirstResponder()
        tfofMedicalRegisCouncilno.resignFirstResponder()
        tfofRegistrationYear.resignFirstResponder()
        
        
    }
    
    
    func bindEducationDetails(){
        
        tfofHighestEducation.text = singleTonObj.UserObjct.HighestEducationQualification
        tfofSecondEducation.text = singleTonObj.UserObjct.SecondHighestQualification
        tfofUniversity.text = singleTonObj.UserObjct.UniversityName
        tfofMedicalRegistration.text = singleTonObj.UserObjct.MRNNumber
        tfofMedicalRegisCouncilno.text = singleTonObj.UserObjct.MRNCouncilNumber
        tfofRegistrationYear.text = singleTonObj.UserObjct.RegistrationYear
        
        if tfofHighestEducation.text == "" {
            istoSendApiRequest = true
        }
        else if tfofSecondEducation.text == "" {
            istoSendApiRequest = true
        }else if tfofUniversity.text == "" {
            istoSendApiRequest = true
        }
        else if tfofMedicalRegistration.text == "" {
            istoSendApiRequest = true
        }
        else if tfofMedicalRegisCouncilno.text == "" {
            istoSendApiRequest = true
        }
        else if tfofRegistrationYear.text == "" {
            istoSendApiRequest = true
        }
        
    }
    
    //bug
    //    @objc func validTxt(_ text : UITextField){
    //
    //
    //        if text == tfofHighestEducation || text == tfofSecondEducation || text == tfofUniversity || text == tfofMedicalRegistration || text == tfofMedicalRegisCouncilno || text == tfofRegistrationYear {
    //            self.validateTextField1(text: text)
    //        }
    //
    //    }
    
    
    func textField1IsValid() -> Bool {
        return (tfofHighestEducation.text?.count)! > 0
    }
    
    func textField2IsValid() -> Bool {
        return (tfofSecondEducation.text?.count)! > 0
    }
    
    func textField3IsValid() -> Bool {
        return (tfofUniversity.text?.count)! > 0
    }
    
    func textField4IsValid() -> Bool {
        return (tfofRegistrationYear.text?.count)! > 0
    }
    
    func textField5IsValid() -> Bool {
        return (tfofMedicalRegistration.text?.count)! > 0
    }
    
    func textField6IsValid() -> Bool {
        return (tfofMedicalRegisCouncilno.text?.count)! > 0
    }
    
    func error(withLocalizedDescription localizedDescription: String) -> Error? {
        let userInfo = [NSLocalizedDescriptionKey: localizedDescription]
        return NSError(domain: MFDemoErrorDomain as? String ?? "", code: Int(MFDemoErrorCode), userInfo: userInfo)
    }
    
    
    
    @objc func validTxt(_ text : UITextField){
        
        var error: Error? = nil
        
        if text == tfofHighestEducation{
            if !textField1IsValid() {
                let server = NSLocalizedString("please enter highest education...", comment: "")
                error = self.error(withLocalizedDescription: server)
                isErrorOccur = true
            }
            tfofHighestEducation.setError(error, animated: true)
        }
        else if text == tfofSecondEducation{
            if !textField2IsValid() {
                let server = NSLocalizedString( "please enter second highest education...", comment: "")
                
                error = self.error(withLocalizedDescription:server)
                isErrorOccur = true
            }
            tfofSecondEducation.setError(error, animated: true)
        }
        else if text == tfofUniversity{
            if !textField3IsValid() {
                let server = NSLocalizedString("please enter university...", comment: "")
                error = self.error(withLocalizedDescription: server)
                isErrorOccur = true
            }
            tfofUniversity.setError(error, animated: true)
        }
        else if text == tfofMedicalRegistration{
            if !textField5IsValid() {
                let server = NSLocalizedString("please enter medical registration number...", comment: "")
                error = self.error(withLocalizedDescription: server)
                isErrorOccur = true
            }
            tfofMedicalRegistration.setError(error, animated: true)
        }
        else if text == tfofMedicalRegisCouncilno{
            if !textField6IsValid() {
                let server = NSLocalizedString("please enter medical registration council number..", comment: "")
                error = self.error(withLocalizedDescription:server )
                isErrorOccur = true
            }
            tfofMedicalRegisCouncilno.setError(error, animated: true)
        }
        //        else if text == tfofRegistrationYear{
        //            if !textField4IsValid() {
        //                let server = NSLocalizedString("please enter registration year...", comment: "")
        //                error = self.error(withLocalizedDescription: server)
        //                isErrorOccur = true
        //            }
        //            tfofRegistrationYear.setError(error, animated: true)
        //        }
        
        istoSendApiRequest = true
    }
    
    
    func validateInputs() -> Bool {
        
        var error: Error? = nil
        
        var isErrorOccur = true
        
        let tfOfHighest = self.tfofHighestEducation.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfOfSecond = self.tfofSecondEducation.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfOfUniv = self.tfofUniversity.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfOfReg = self.tfofRegistrationYear.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfOfMedicalReg = self.tfofMedicalRegistration.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let tfOfMedicalRegNo = self.tfofMedicalRegisCouncilno.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if tfOfHighest?.count == 0 {
            isErrorOccur = false
            let server = NSLocalizedString("please enter highest education...", comment: "")
            error = self.error(withLocalizedDescription: server)
            tfofHighestEducation.setError(error, animated: true)
        }
        else if tfOfSecond?.count == 0{
            isErrorOccur = false
            let server = NSLocalizedString( "please enter second highest education...", comment: "")
            
            error = self.error(withLocalizedDescription:server)
            tfofSecondEducation.setError(error, animated: true)
        }
        else if tfOfUniv?.count == 0{
            isErrorOccur = false
            let server = NSLocalizedString("please enter university...", comment: "")
            error = self.error(withLocalizedDescription: server)
            tfofUniversity.setError(error, animated: true)
        }else if tfOfReg?.count == 0{
            isErrorOccur = false
            let server = NSLocalizedString("please enter registration year...", comment: "")
            error = self.error(withLocalizedDescription: server)
            tfofRegistrationYear.setError(error, animated: true)
        }else if tfOfMedicalReg?.count == 0{
            isErrorOccur = false
            let server = NSLocalizedString("please enter medical registration number...", comment: "")
            error = self.error(withLocalizedDescription: server)
            tfofMedicalRegistration.setError(error, animated: true)
        }else if tfOfMedicalRegNo?.count == 0{
            isErrorOccur = false
            let server = NSLocalizedString("please enter medical registration council number..", comment: "")
            error = self.error(withLocalizedDescription:server )
            tfofMedicalRegisCouncilno.setError(error, animated: true)
        }
        
        return isErrorOccur
        
        
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
    
    
    
    //    @IBAction func btnofYearClicked(_ sender: Any) {
    //
    //        let cal = NSCalendar.current
    //        let date = Date()
    //        let year = cal.component(.year, from: date)
    //        var arrofYears = [String]()
    //        print(year)
    //        for i in 1...30 {
    //            arrofYears.append(String(Int(year - i)))
    //        }
    //
    //    }
    
    
    
//    func saveProfileInCoredata(arr : NSDictionary) {
//
//        let dictofProfile = arr
//
//        let app = UIApplication.shared.delegate as! AppDelegate
//        let context = app.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: EducationDetailsCoreDataList.EntityName.Education, in: context)!
//        let object = NSManagedObject(entity: entity, insertInto: context)
//
//        let encodedObject : Data = NSKeyedArchiver.archivedData(withRootObject:   dictofProfile)
//        object.setValue(encodedObject, forKey: EducationDetailsCoreDataList.Attributes.education )
//
//        do {
//            try context.save()
//        } catch {
//            print("Failed saving")
//        }
//
//
//    }
    /*
    func fetchData() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ProfileDetailsCoreDataList.EntityName.ProfileDetails)
        
        
        do {
            let results = try context.fetch(fetchRequest)
            print(results)
            
            
            if results.count != 0 {
                
                for result in results {
                    
                    let data = (result as AnyObject).value(forKey: ProfileDetailsCoreDataList.Attributes.personalDetails) as! NSData
                    let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with: data as Data)
                    //  let arrayObject = unarchiveObject as! NSArray
                    
                    let arrayObject = unarchiveObject  as! NSDictionary
                    //  let resultOfPro = arrayObject[1]
                    if arrayObject.count > 0 {
                        
                        let resultOfPro = arrayObject.value(forKey: "data") as! NSArray
                        let values = resultOfPro[0] as! NSDictionary
                        
                        let eduQualification =  values.value(forKey:UpdateEducationProfile.APIRequest.eduQualification )
                        print(eduQualification as Any)
                        let highestEduQualification =  values.value(forKey:UpdateEducationProfile.APIRequest.highestEduQualification)
                        let medicalRegNo =  values.value(forKey: UpdateEducationProfile.APIRequest.medicalRegNo)
                        let registrationCouncil =  values.value(forKey:UpdateEducationProfile.APIRequest.registrationCouncil)
                        let registrationYear =  values.value(forKey:UpdateEducationProfile.APIRequest.registrationYear)
                        let universityName = values.value(forKey: UpdateEducationProfile.APIRequest.universityName)
                        
                        tfofHighestEducation.text = highestEduQualification as? String
                        tfofSecondEducation.text = eduQualification as? String
                        tfofRegistrationYear.text = registrationYear as? String
                        tfofMedicalRegisCouncilno.text = registrationCouncil as? String
                        tfofMedicalRegistration.text = medicalRegNo as? String
                        tfofUniversity.text = universityName as? String
                       
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
    
    func callforUpdateEducationProfile(){
        
        /*{"ApiKey":"SKZHTiNhgR6G9TSl","userRef":"QmalxZn4UQEWfSq6","highestEduQualification":"b.tech","eduQualification":"","universityName":"","registrationCouncil":"23423432423432","medicalRegNo":"","registrationYear":"2015"}*/
        
        
    //    APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
     
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      UpdateEducationProfile.APIRequest.eduQualification : tfofSecondEducation.text!,
                                      UpdateEducationProfile.APIRequest.highestEduQualification : tfofHighestEducation.text!,
                                      UpdateEducationProfile.APIRequest.medicalRegNo : tfofMedicalRegistration.text!,
                                      UpdateEducationProfile.APIRequest.registrationCouncil : tfofMedicalRegisCouncilno.text!,
                                      UpdateEducationProfile.APIRequest.registrationYear : tfofRegistrationYear.text!,
                                      UpdateEducationProfile.APIRequest.universityName : tfofUniversity.text!]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.updateEduProfile, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            // print(response)
            
             if Connectivity.isCheckForNewwork() == true {
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                
                self.singleTonObj.UserObjct.HighestEducationQualification = self.tfofHighestEducation.text
                self.singleTonObj.UserObjct.SecondHighestQualification = self.tfofSecondEducation.text
                self.singleTonObj.UserObjct.UniversityName = self.tfofUniversity.text
                self.singleTonObj.UserObjct.MRNNumber = self.tfofMedicalRegistration.text
                self.singleTonObj.UserObjct.MRNCouncilNumber = self.tfofMedicalRegisCouncilno.text
                self.singleTonObj.UserObjct.RegistrationYear = self.tfofRegistrationYear.text
            //    self.saveProfileInCoredata(arr : dictofResonse)
                if let delegate = self.delegate {
                    delegate.continueEduClicked()
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
//                self.isError = "updateeduprof"
//                if messag == NetworkErrorIssue{
//                    OopsVC.errorType = NetworkError
//                }
//                self.present(OopsVC, animated: true, completion: nil)
//            }
        }
    }
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        if self.isError == "updateeduprof"{
            callforUpdateEducationProfile()
        }
        
    }
    
    
    @IBAction func btnContinueClicked(_ sender: Any) {
        
        if istoSendApiRequest == true {
            allTextFieldResignResp()
            if validateInputs(){
                callforUpdateEducationProfile()
            }
        }else{
            if let delegate = self.delegate {
                delegate.continueEduClicked()
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
extension ProEducationalViewController : UIPickerViewDataSource,UIPickerViewDelegate

{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearShow.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: yearShow[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        strYear = String(describing: yearShow[row])
        // btnofGender.setTitle(arrofOptions[row], for: .normal)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
