//
//  ProfileViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import CoreData



public class Profile  : NSObject {
    
    var profilePic : String! = ""
    
    var Name : String! = ""
    var NamePrefix : String! = ""
    var EmailId : String! = ""
    var MobileNumeber : String! = ""
    var MobileNumeberPrefix : String! = ""
    var Speciality : String! = ""
    var ExpYear : String! = ""
    var ExpMonth : String! = ""
    var Information : String! = ""
    var isPersonalDataFilled : String! = ""
    var arrofSpelizations : NSMutableArray! = NSMutableArray.init()
    
    var HighestEducationQualification : String! = ""
    var SecondHighestQualification : String! = ""
    var UniversityName : String! = ""
    var MRNNumber : String! = ""
    var MRNCouncilNumber : String! = ""
    var RegistrationYear : String! = ""
    var isEducationDataFilled : String! = ""
    
    var isMRNNumberVerifiedOrNot : String! = ""
    
    var isMedicalProofAdded : Bool! = false
    var isQualificationProofAdded : Bool! = false
    var isDocumentsFilled : String! = ""
    var registrproof_1 : String! = ""
    var registrproof_2 : String! = ""
    var registrproof_3 : String! = ""
    var educationproof_1 : String! = ""
    var educationproof_2 : String! = ""
    var educationproof_3 : String! = ""
    
    
}

class Colors {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor(red: 50 / 255.0, green: 184 / 255.0, blue: 152 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 8 / 255.0, green: 146 / 255.0, blue: 189 / 255.0, alpha: 1.0).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}




class ProfileViewController: CommonViewController,ErrorProtocalDelegate {
    
    @IBOutlet var imgofUser: UIImageView!
    @IBOutlet var lblofUserName: UILabel!
    @IBOutlet var lblofUserEmail: UILabel!
    @IBOutlet var profileProgress: UIProgressView!
    @IBOutlet var lblofProfilePercentage: UILabel!
    
    @IBOutlet var btnPersonal: UIButton!
    @IBOutlet var lblofPersonalSelected: UILabel!
    
    @IBOutlet var btnEducation: UIButton!
    @IBOutlet var lblofEducationSelected: UILabel!
    
    @IBOutlet var btnofUploadDoc: UIButton!
    @IBOutlet var lblofUploadDocsSelected: UILabel!
    
    @IBOutlet var containerofPersonalView: UIView!
    @IBOutlet var containerofEducationView: UIView!
    @IBOutlet var containerofUploadDocs: UIView!
    
    var personalDetailsVc  : ProPersonalViewController!
    var educationDetailsVc : ProEducationalViewController!
    var uploadDetailsVc : ProUploadDocumentsViewController!
    var myPickerController = UIImagePickerController()
    
    var selectedImage : UIImage!
    
    var singleTonObj : SingleTonClass!
    var isCameraPermissonAlertShown = false
    var isPhotolibPermisAlertshown = false
    var strOfProfilePic = ""
    
    var valueofProgreessBar : Float! = 00.0
    
    var arrofSpecilazions : NSArray!
    
    @IBOutlet var viewofDocument : UIView!
    @IBOutlet var selectedImageView : UIImageView!
    
    var singObj : SingleTonClass!
    
    let gradColor = Colors()
    
    var isError : String = ""
    var resultOfProfile = [Any]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = Constatns.ThemeColour()
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
        
        
        singleTonObj = SingleTonClass.SharedInstance
        singleTonObj.singIdentifier = "ProfileViewController"
        
        
        containerofUploadDocs.isHidden = true
        containerofEducationView.isHidden = true
        
        imgofUser.layer.cornerRadius = imgofUser.frame.size.height/2
        imgofUser.layer.masksToBounds = true
        
        
        
        profileProgress.transform = profileProgress.transform.scaledBy(x: 1, y: 5)
        profileProgress.layer.cornerRadius = 5
        profileProgress.layer.masksToBounds = true
        profileProgress.backgroundColor = UIColor.clear
        let backgroundLayer = gradColor.gl
        backgroundLayer?.frame = profileProgress.frame
        profileProgress.layer.insertSublayer(backgroundLayer!, at: 0)
        
        
        
        viewofDocument.isHidden = true
        selectedImage = UIImage()
        selectedImage = nil
        myPickerController.delegate = self
        
        getUserProfile()
        
        if Connectivity.isCheckForNewwork() == false {
        fetchData()
        }
        
        
    }
    
    func getProgressUpdate(){
        
        
        self.valueofProgreessBar = 0.0
        
        if singleTonObj.UserObjct.EmailId != nil{
            self.valueofProgreessBar = self.valueofProgreessBar + 10
        }
        //        if singleTonObj.UserObjct.MobileNumeber != nil{
        //             self.valueofProgreessBar = self.valueofProgreessBar + 10
        //        }
        if singleTonObj.UserObjct.Name != nil{
            self.valueofProgreessBar = self.valueofProgreessBar + 10
        }
        if singleTonObj.UserObjct.HighestEducationQualification != "" {
            self.valueofProgreessBar = self.valueofProgreessBar + 10
        }
        //        if singleTonObj.UserObjct.SecondHighestQualification != "" {
        //            self.valueofProgreessBar = self.valueofProgreessBar + 10
        //        }
        //        if singleTonObj.UserObjct.RegistrationYear != ""  {
        //            self.valueofProgreessBar = self.valueofProgreessBar + 5
        //        }
        if singleTonObj.UserObjct.UniversityName != ""  {
            self.valueofProgreessBar = self.valueofProgreessBar + 10
        }
        if singleTonObj.UserObjct.MRNCouncilNumber != ""  {
            self.valueofProgreessBar = self.valueofProgreessBar + 10
        }
        //        if singleTonObj.UserObjct.MRNNumber != ""  {
        //            self.valueofProgreessBar = self.valueofProgreessBar + 10
        //        }
        if singleTonObj.UserObjct.profilePic != ""  {
            self.valueofProgreessBar = self.valueofProgreessBar + 10
        }
        
        if singleTonObj.UserObjct.isMedicalProofAdded {
            self.valueofProgreessBar = self.valueofProgreessBar + 10
        }
        
        if singleTonObj.UserObjct.isQualificationProofAdded {
            self.valueofProgreessBar = self.valueofProgreessBar + 10
        }
        
        if singleTonObj.UserObjct.isMRNNumberVerifiedOrNot == "1" {
            self.valueofProgreessBar = self.valueofProgreessBar + 10
        }
        if singleTonObj.UserObjct.ExpYear != "" {
            self.valueofProgreessBar = self.valueofProgreessBar + 5
        }
        if singleTonObj.UserObjct.ExpMonth != "" {
            self.valueofProgreessBar = self.valueofProgreessBar + 5
        }
        
        if valueofProgreessBar > 100 {
            
            profileProgress.progress = 1
            lblofProfilePercentage.text = "\(self.valueofProgreessBar!)%"
            
        }else{
            profileProgress.progress = self.valueofProgreessBar/100
            lblofProfilePercentage.text = "\(self.valueofProgreessBar!)%"
        }
        
        
        
    }
    
    
    func saveProfileInCoredata(arr : NSDictionary ) {
        
        let dictofProfile = arr
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: ProfileDetailsCoreDataList.EntityName.ProfileDetails, in: context)!
        let object = NSManagedObject(entity: entity, insertInto: context)
        
        let encodedObject : Data = NSKeyedArchiver.archivedData(withRootObject:   dictofProfile)
        
        object.setValue(encodedObject, forKey:  ProfileDetailsCoreDataList.Attributes.personalDetails)
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        
    }
    
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
                    let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:data as Data)
                    let arrayObject = unarchiveObject  as! NSDictionary
                    if arrayObject.count > 0 {
                        
                        let resultOfPro = arrayObject.value(forKey: UserProfile.APIResponse.docInfo) as! NSArray
                        let arrofSpelizations = arrayObject.object(forKey: UserProfile.APIResponse.special) as! NSArray
                        
                        singleTonObj.arrofSpecilazations.addObjects(from: arrofSpelizations as! [Any])
                        
                        
                        let values = resultOfPro[0] as! NSDictionary
                        
                        self.selectionOptions(0)
                        self.bindProfileDetailsSaveInCoreData(values)
                        

                        
                        break
                    }
                    
                }
                
            }
            
            
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    
    
    func bindProfileDetailsSaveInCoreData(_ docBasicInfo : NSDictionary) {
       
        singleTonObj.UserObjct.EmailId = docBasicInfo.value(forKey:UpdateBasicProfile.APIRequest.emailId) as! String
      singleTonObj.UserObjct.ExpMonth = docBasicInfo.value(forKey:UpdateBasicProfile.APIRequest.month) as! String
      singleTonObj.UserObjct.ExpYear = docBasicInfo.value(forKey:UpdateBasicProfile.APIRequest.year) as! String
      singleTonObj.UserObjct.HighestEducationQualification = docBasicInfo.value(forKey:UserProfile.APIResponse.highestEduQualification) as! String
      singleTonObj.UserObjct.Information = docBasicInfo.value(forKey:UserProfile.APIResponse.docInformation) as! String
      singleTonObj.UserObjct.isMRNNumberVerifiedOrNot = docBasicInfo.value(forKey:UserProfile.APIResponse.isMRNVerified) as! String
     singleTonObj.UserObjct.MobileNumeber = docBasicInfo.value(forKey:UserProfile.APIResponse.mobileNumber) as! String
     singleTonObj.UserObjct.MobileNumeberPrefix = docBasicInfo.value(forKey:UserProfile.APIResponse.mobilePrefix) as! String
     singleTonObj.UserObjct.MRNCouncilNumber = docBasicInfo.value(forKey:UserProfile.APIResponse.registrationCouncil) as! String
     singleTonObj.UserObjct.MRNNumber = docBasicInfo.value(forKey:UserProfile.APIResponse.medicalRegNo) as! String
     singleTonObj.UserObjct.Name = docBasicInfo.value(forKey:UserProfile.APIResponse.Name) as! String
     singleTonObj.UserObjct.NamePrefix = docBasicInfo.value(forKey:UserProfile.APIResponse.namePrefix) as! String
     singleTonObj.UserObjct.RegistrationYear = docBasicInfo.value(forKey:UserProfile.APIResponse.registrationYear) as! String
    singleTonObj.UserObjct.SecondHighestQualification = docBasicInfo.value(forKey:UserProfile.APIResponse.eduQualification) as! String
    singleTonObj.UserObjct.UniversityName = docBasicInfo.value(forKey:UserProfile.APIResponse.universityName) as! String
    singleTonObj.UserObjct.profilePic = docBasicInfo.value(forKey:UserProfile.APIResponse.profilePic) as! String
    singleTonObj.UserObjct.educationproof_1 = docBasicInfo.value(forKey:UserProfile.APIResponse.eduQualProof) as! String
    singleTonObj.UserObjct.educationproof_2 = docBasicInfo.value(forKey:UserProfile.APIResponse.eduQualProof_1) as! String
    singleTonObj.UserObjct.educationproof_3 = docBasicInfo.value(forKey:UserProfile.APIResponse.eduQualProof_2) as! String
    singleTonObj.UserObjct.registrproof_1 = docBasicInfo.value(forKey:UserProfile.APIResponse.regProof) as! String
    singleTonObj.UserObjct.registrproof_2 = docBasicInfo.value(forKey:UserProfile.APIResponse.regProof_1) as! String
    singleTonObj.UserObjct.registrproof_3 = docBasicInfo.value(forKey:UserProfile.APIResponse.regProof_2) as! String
        if singleTonObj.UserObjct.registrproof_1 != "" || singleTonObj.UserObjct.registrproof_2 != "" || singleTonObj.UserObjct.registrproof_3 != "" {
            singleTonObj.UserObjct.isMedicalProofAdded = true
        }
        
        
        if singleTonObj.UserObjct.educationproof_1 != "" || singleTonObj.UserObjct.educationproof_2 != "" || singleTonObj.UserObjct.educationproof_3 != "" {
            singleTonObj.UserObjct.isQualificationProofAdded = true
        }
        
        lblofUserName.text = singleTonObj.UserObjct.NamePrefix + " " + singleTonObj.UserObjct.Name
        lblofUserEmail.text = singleTonObj.UserObjct.EmailId
        
        imgofUser.imageFromURL(urlString: singleTonObj.UserObjct.profilePic,true)
        
        getProgressUpdate()
    }
    
    
    
    func bindProfileData(_ docBasicInfo : NSDictionary){
        
        
        singleTonObj.UserObjct.EmailId = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.emailId))
        singleTonObj.UserObjct.ExpMonth = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.month))
        singleTonObj.UserObjct.ExpYear = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.year))
        singleTonObj.UserObjct.HighestEducationQualification = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.highestEduQualification))
        singleTonObj.UserObjct.Information = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.docInformation))
        
        singleTonObj.UserObjct.isMRNNumberVerifiedOrNot = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.isMRNVerified))
        
        singleTonObj.UserObjct.MobileNumeber = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.mobileNumber))
        singleTonObj.UserObjct.MobileNumeberPrefix = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.mobilePrefix))
        singleTonObj.UserObjct.MRNCouncilNumber = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.registrationCouncil))
        singleTonObj.UserObjct.MRNNumber = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.medicalRegNo))
        singleTonObj.UserObjct.Name = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.Name))
        singleTonObj.UserObjct.NamePrefix = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.namePrefix))
        singleTonObj.UserObjct.RegistrationYear = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.registrationYear))
        singleTonObj.UserObjct.SecondHighestQualification = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.eduQualification))
        
        //        singleTonObj.UserObjct.Speciality = "ABC"
        singleTonObj.UserObjct.UniversityName = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.universityName))
        
        singleTonObj.UserObjct.profilePic = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.profilePic))
        
        singleTonObj.UserObjct.educationproof_1 = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.eduQualProof))
        singleTonObj.UserObjct.educationproof_2 = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.eduQualProof_1))
        singleTonObj.UserObjct.educationproof_3 = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.eduQualProof_2))
        
        singleTonObj.UserObjct.registrproof_1 = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.regProof))
        singleTonObj.UserObjct.registrproof_2 = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.regProof_1))
        singleTonObj.UserObjct.registrproof_3 = String(describing:docBasicInfo.TabiibDocObjectForKey(forKey: UserProfile.APIResponse.regProof_2))
        
        
        if singleTonObj.UserObjct.registrproof_1 != "" || singleTonObj.UserObjct.registrproof_2 != "" || singleTonObj.UserObjct.registrproof_3 != "" {
            singleTonObj.UserObjct.isMedicalProofAdded = true
        }
        
        
        if singleTonObj.UserObjct.educationproof_1 != "" || singleTonObj.UserObjct.educationproof_2 != "" || singleTonObj.UserObjct.educationproof_3 != "" {
            singleTonObj.UserObjct.isQualificationProofAdded = true
        }
        
        lblofUserName.text = singleTonObj.UserObjct.NamePrefix + " " + singleTonObj.UserObjct.Name
        lblofUserEmail.text = singleTonObj.UserObjct.EmailId
        
        imgofUser.imageFromURL(urlString: singleTonObj.UserObjct.profilePic,true)
        
        getProgressUpdate()
        
    }
    
    
   
    
 
    
    func getUserProfile(){
        /*{"ApiKey":"OIxv03jBrOUGAKg8","userRef":"UspJ0gzXZkTdHpOL","userType":"2"}*/
        
        self.showActivityIndicator()
       
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      UserProfile.APIRequest.userType : userType]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.userProfile, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            
            self.hideActivityIndicator()
            
            //  print(response)
            
            self.selectionOptions(0)
            
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                let docBasicInfoarr = dictofResonse.object(forKey: UserProfile.APIResponse.docInfo) as! NSArray
                
                self.saveProfileInCoredata(arr: dictofResonse)
                
                if docBasicInfoarr.count > 0{
                    
                    let docBasicInfo = docBasicInfoarr[0] as! NSDictionary
                    
                    self.bindProfileData(docBasicInfo)
                    
                    let arrofSpelizations = dictofResonse.object(forKey: UserProfile.APIResponse.special) as! NSArray
                    
                    self.singleTonObj.UserObjct.arrofSpelizations.addObjects(from: arrofSpelizations as! [Any])
                    
                    
                    self.arrofSpecilazions = dictofResonse.object(forKey: UserProfile.APIResponse.special) as! NSArray
                    
                    
                    self.personalDetailsVc.loadUserProfileData()
                    
             //       self.saveProfileInCoredata(arr: arrofSpelizations)
                    
                }
            }
            else{
                Utilities.sharedInstace.showAlertviewWithMessage(String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.error_message)))
                
            }
            
            
        }) { (networkErr, messag) in
            self.hideActivityIndicator()
            self.fetchData()
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
//                self.isError = "userProf"
//                if messag == NetworkErrorIssue{
//                    OopsVC.errorType = NetworkError
//                }
//                self.present(OopsVC, animated: true, completion: nil)
//            }
        }
    }
    
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        if self.isError == "userProf"{
            getUserProfile()
        }else{
            callforUpdateProfilePicture()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
    }
    
    
    
    
    
    func checkCameraAceess() -> Bool{
        var isHaveAcces = false
        if Utilities.sharedInstace.checkCameraRuntimePermission() {
            isHaveAcces = true
        }
        else{
            showAlertforcameraPermisson()
        }
        
        return isHaveAcces
    }
    
    
    func checkPhotosAccess() -> Bool {
        var isHaveAcces = false
        if Utilities.sharedInstace.checkPhotosRuntimePermisson() {
            isHaveAcces = true
        }
        else{
            showAlertForPhotoLibrary()
        }
        
        return isHaveAcces
    }
    
    
    
    func showAlertForPhotoLibrary(){
        
        let photoperm = NSLocalizedString("Photos permission", comment : "")
        let okay = NSLocalizedString("Okay", comment : "")
        
        let objofSweetAlrt = SweetAlerts()
        objofSweetAlrt.isTapGestureReg = false
        if isPhotolibPermisAlertshown == false {
            _ =  objofSweetAlrt.showAlert(photoperm, style: .none, buttonTitle: okay, action: { (clciked) in
                Utilities.sharedInstace.openAppPermissions()
            })
            isPhotolibPermisAlertshown = true
        }
    }
    
    func showAlertforcameraPermisson(){
        
        let camperm = NSLocalizedString("Camera permissions", comment : "")
        let okay = NSLocalizedString("Okay", comment : "")
        
        let objofSweetAlrt = SweetAlerts()
        objofSweetAlrt.isTapGestureReg = false
        if isCameraPermissonAlertShown == false {
            _ =  objofSweetAlrt.showAlert(camperm, style: .none, buttonTitle: okay, action: { (clciked) in
                Utilities.sharedInstace.openAppPermissions()
            })
            isCameraPermissonAlertShown = true
        }
    }
    
    
    
    
    func selectionOptions(_ index : Int){
        switch index {
            
        case 0:
            
            if Connectivity.isCheckForNewwork() == false {
            self.personalDetailsVc.bindProfileData()
            self.personalDetailsVc.fetchSpecializationData()
              
            }
            
            UIView.animate(withDuration: 0.5) {
                
                self.containerofPersonalView.frame = CGRect(x: -self.containerofPersonalView.frame.width, y: self.containerofPersonalView.frame.origin.y, width: self.containerofPersonalView.frame.width, height: self.containerofPersonalView.frame.height)
                self.containerofPersonalView.frame = CGRect(x: 0, y: self.containerofPersonalView.frame.origin.y, width: self.containerofPersonalView.frame.width, height: self.containerofPersonalView.frame.height)
                
            }
            
            //default in personal
            containerofPersonalView.isHidden = false
            containerofEducationView.isHidden = true
            containerofUploadDocs.isHidden = true
            
            //by default personal is selected
            lblofPersonalSelected.backgroundColor = Constatns.ThemeColour()
            lblofEducationSelected.backgroundColor = UIColor.clear
            lblofUploadDocsSelected.backgroundColor = UIColor.clear
            
            btnPersonal.setTitleColor(Constatns.ThemeColour(), for: .normal)
            btnEducation.setTitleColor(Constatns.profileColor(), for: .normal)
            btnofUploadDoc.setTitleColor(Constatns.profileColor(), for: .normal)
           
            if UIDevice.current.userInterfaceIdiom == .phone {
                btnPersonal.titleLabel?.font = Constatns.Lato_Bold(14)
                btnEducation.titleLabel?.font = Constatns.Lato_Medium(14)
                btnofUploadDoc.titleLabel?.font = Constatns.Lato_Medium(14)
            }
            else if UIDevice.current.userInterfaceIdiom == .pad {
                btnPersonal.titleLabel?.font = Constatns.Lato_Bold(24)
                btnEducation.titleLabel?.font = Constatns.Lato_Medium(24)
                btnofUploadDoc.titleLabel?.font = Constatns.Lato_Medium(24)
            }
            
            break
            
        case 1:
            
            self.containerofEducationView.isHidden = true
            
            self.educationDetailsVc.bindEducationDetails()
            
            
            UIView.animate(withDuration: 0.5) {
                
                self.containerofEducationView.frame = CGRect(x: self.view.frame.width, y: self.containerofEducationView.frame.origin.y, width: self.containerofEducationView.frame.width, height: self.containerofEducationView.frame.height)
                self.containerofEducationView.frame = CGRect(x: 0, y: self.containerofEducationView.frame.origin.y, width: self.containerofEducationView.frame.width, height: self.containerofEducationView.frame.height)
                
            }
            
            
            //default in personal
            containerofPersonalView.isHidden = true
            containerofEducationView.isHidden = false
            containerofUploadDocs.isHidden = true
            
            //by default personal is selected
            lblofPersonalSelected.backgroundColor = UIColor.clear
            lblofEducationSelected.backgroundColor = Constatns.ThemeColour()
            lblofUploadDocsSelected.backgroundColor = UIColor.clear
            
            
            
            btnEducation.setTitleColor(Constatns.ThemeColour(), for: .normal)
            btnPersonal.setTitleColor(Constatns.profileColor(), for: .normal)
            btnofUploadDoc.setTitleColor(Constatns.profileColor(), for: .normal)
           
            if UIDevice.current.userInterfaceIdiom == .phone {
                btnPersonal.titleLabel?.font = Constatns.Lato_Bold(14)
                btnEducation.titleLabel?.font = Constatns.Lato_Medium(14)
                btnofUploadDoc.titleLabel?.font = Constatns.Lato_Medium(14)
            }
            else if UIDevice.current.userInterfaceIdiom == .pad {
                btnPersonal.titleLabel?.font = Constatns.Lato_Bold(24)
                btnEducation.titleLabel?.font = Constatns.Lato_Medium(24)
                btnofUploadDoc.titleLabel?.font = Constatns.Lato_Medium(24)
            }

            break
            
        case 2:
            
            self.getProgressUpdate()
            
            self.containerofUploadDocs.isHidden = false
            
            self.uploadDetailsVc.bindDocuments()
            
            //move personal to education
            UIView.animate(withDuration: 0.5) {
                
                self.containerofUploadDocs.frame = CGRect(x: self.view.frame.width, y: self.containerofUploadDocs.frame.origin.y, width: self.containerofUploadDocs.frame.width, height: self.containerofUploadDocs.frame.height)
                self.containerofUploadDocs.frame = CGRect(x: 0, y: self.containerofUploadDocs.frame.origin.y, width: self.containerofUploadDocs.frame.width, height: self.containerofUploadDocs.frame.height)
                
            }
            
            //default in personal
            containerofPersonalView.isHidden = true
            containerofEducationView.isHidden = true
            containerofUploadDocs.isHidden = false
            
            //by default personal is selected
            lblofPersonalSelected.backgroundColor = UIColor.clear
            lblofEducationSelected.backgroundColor = UIColor.clear
            lblofUploadDocsSelected.backgroundColor = Constatns.ThemeColour()
            
            
            btnofUploadDoc.setTitleColor(Constatns.ThemeColour(), for: .normal)
            btnPersonal.setTitleColor(Constatns.profileColor(), for: .normal)
            btnEducation.setTitleColor(Constatns.profileColor(), for: .normal)
            
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                btnPersonal.titleLabel?.font = Constatns.Lato_Bold(14)
                btnEducation.titleLabel?.font = Constatns.Lato_Medium(14)
                btnofUploadDoc.titleLabel?.font = Constatns.Lato_Medium(14)
            }
            else if UIDevice.current.userInterfaceIdiom == .pad {
                btnPersonal.titleLabel?.font = Constatns.Lato_Bold(24)
                btnEducation.titleLabel?.font = Constatns.Lato_Medium(24)
                btnofUploadDoc.titleLabel?.font = Constatns.Lato_Medium(24)
            }

            
            break
            
        default:
            
            break
        }
    }
    
    func camera()
    {
        myPickerController.sourceType = .camera
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func photoLibrary()
    {
        
        myPickerController.sourceType = .photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    
    func showActionSheet() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let Camera = NSLocalizedString("Camera", comment: "")
        let Gallery = NSLocalizedString("Gallery", comment: "")
        let Cancel = NSLocalizedString("Cancel", comment: "")
        
        actionSheet.addAction(UIAlertAction(title: Camera, style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            
            if self.checkCameraAceess(){
                self.camera()
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: Gallery, style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            
            if self.checkPhotosAccess(){
                self.photoLibrary()
            }
            
        }))
        
        //        if UserDefaultStore.profilePicImg != nil && UserDefaultStore.profilePicImg != ""{
        //
        //            actionSheet.addAction(UIAlertAction(title: "Remove Profile Picture", style: .default, handler: {
        //                action in
        //                self.selectedImage = nil
        //                //self.updateProfilePicApi()
        //                self.strOfPicUpdate = "1"
        //                UserDefaultStore.profilePicImg = ""
        //                self.profileTableView.reloadData()
        //
        //            }))
        //        }
        
        actionSheet.addAction(UIAlertAction(title: Cancel, style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func btnCloseImageview(_ sender :Any){
        viewofDocument.isHidden = true
    }
    
    @IBAction func btnUploadDocsClicked(_ sender: Any) {
        selectionOptions(2)
//        if Connectivity.isCheckForNewwork() == false {
//            uploadDetailsVc.fetchData()
//        }
    }
    
    @IBAction func btnEducationClicked(_ sender: Any) {
        selectionOptions(1)
//        if Connectivity.isCheckForNewwork() == false {
//           educationDetailsVc.fetchData()
//        }
        
    }
    
    @IBAction func btnPictureEditClicked(_ sender: Any) {
        showActionSheet()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        
        //        self.backBtnAction()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPersonalClicked(_ sender: Any) {
        
        selectionOptions(0)
//        if Connectivity.isCheckForNewwork() == false {
//            personalDetailsVc.fetchData()
//        }
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ProPersonalViewController") {
            self.personalDetailsVc = segue.destination as! ProPersonalViewController
            self.personalDetailsVc.delegate = self
        }
        else if(segue.identifier == "ProEducationalViewController"){
            self.educationDetailsVc = segue.destination as! ProEducationalViewController
            self.educationDetailsVc.delegate = self
        }
        else if(segue.identifier == "ProUploadDocumentsViewController") {
            self.uploadDetailsVc = segue.destination as! ProUploadDocumentsViewController
            self.uploadDetailsVc.delegate = self
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

extension ProfileViewController : TOCropViewControllerDelegate
{
    
    func callforUpdateProfilePicture(){
        
        /*{"ApiKey":"OIxv03jBrOUGAKg8","userRef":"wZ9LQaj5naFGZS2t","profilePic":" http://staging.tabiib.com/assets/docProfPic/img.jpg","userType":"2"}*/
        
    //    APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
       
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      UpdateProfilePic.APIRequest.userType : userType,
                                      UpdateProfilePic.APIRequest.profilePic : strOfProfilePic]
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.updateProfilePic, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                self.imgofUser.image = self.selectedImage
                
            }
            else{
                
                Utilities.sharedInstace.showAlertviewWithMessage(String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.error_message)))
                
            }
            
            
        }) { (networkErr, messag) in
            APIServices.SharedInstance.hideProgress()
         
            
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
    
    
    
    
    func cropViewController(_ cropViewController: TOCropViewController!, didCropTo image: UIImage!, with cropRect: CGRect, angle: Int) {
        
        //imgofProfilePic.image = image
        selectedImage = image
        
        let imageData: Data = UIImageJPEGRepresentation(image, 0.1)!
        
        strOfProfilePic = (imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) as NSString) as String
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        dismiss(animated: true) {
            
            
            
            self.callforUpdateProfilePicture()
        }
    }
    
    
}

extension ProfileViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let imageData: Data = UIImageJPEGRepresentation(chosenImage, 0.1)!
        
        strOfProfilePic = (imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) as NSString) as String
        
        
        let cropController = TOCropViewController.init(croppingStyle: .default, image: chosenImage) as TOCropViewController
        
        cropController.delegate = self
        
        
        dismiss(animated: true) {
            self.present(cropController, animated: true, completion: nil)
        }
        
        
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        selectedImage = nil
        strOfProfilePic = ""
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension ProfileViewController : PersonalDetailsContinueDelegate {
    
    func continueClicked() {
        //move personal to education
        selectionOptions(1)
        
    }
}


extension ProfileViewController : EductionalDetailsContinueDelegate {
    
    func continueEduClicked() {
        selectionOptions(2)
    }
    
}


extension ProfileViewController : UploadDocumentsDetailsContinueDelegate {
    
    func viewDocumentClicked(_ documentObj: DoctorIdentificationProof) {
        
        viewofDocument.isHidden = false
        selectedImageView.image = nil
        if documentObj.isServerimagePath != "" {
            selectedImageView.imageFromURL(urlString: documentObj.isServerimagePath,true)
        }
        else{
            selectedImageView.image = documentObj.selectedImage
        }
        
    }
    
    func continueUploadClicked() {
        
        //push to home view controller
        self.navigationController?.popViewController(animated: true)
    }
}







