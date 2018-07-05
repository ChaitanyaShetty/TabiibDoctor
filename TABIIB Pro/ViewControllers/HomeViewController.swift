//
//  HomeViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import CoreData


let unauthorised = "unauthorised"
let NetworkErrorIssue = "NetworkErrorIssue"
let geterror = "geterror"


let iOSAppLink = "https://itunes.apple.com/app/tabiib-pro/id1360992776?ls=1&mt=8"


class HomeViewController: UIViewController,ErrorProtocalDelegate {
    
    let Profile = NSLocalizedString("Profile", comment: "")
    let Clinics = NSLocalizedString("Clinics", comment: "")
    let Appointments = NSLocalizedString("Appointments", comment: "")
    let Payments = NSLocalizedString("Payments", comment: "")
    let Language = NSLocalizedString("Language", comment: "")
    //     let Reports = NSLocalizedString("Reports", comment: "")
    //     let WebAccess = NSLocalizedString("Web Access", comment: "")
    let Support = NSLocalizedString("Support", comment: "")
    
    @IBOutlet var colleOfOptions: UICollectionView!
    
    var arrofOptions : NSMutableArray!
    var arrofFilleCount : NSMutableArray!
    var arrofimages : NSMutableArray!
     var resultData = [Any]()
    
    var strofClinicCount : String! = "0"
    var singObj : SingleTonClass!
    
    @IBOutlet weak var btnofNotifications : UIButton!
    
    
    var isAlertisVisible : Bool = false
    
    var isError : String = ""
    
    var networkFunctionality : Int!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        singObj = SingleTonClass.SharedInstance
        singObj.singIdentifier = "HomeViewController"
        
        
        UserDefaultStore.isLogined = "1"
        
        //Home1
        arrofOptions = NSMutableArray.init()
        arrofOptions.add(Profile)
        arrofOptions.add(Clinics)
        arrofOptions.add(Appointments)
        arrofOptions.add(Payments)
        arrofOptions.add(Language)
        //        arrofOptions.add(Reports)
        //        arrofOptions.add(WebAccess)
        arrofOptions.add(Support)
        
        arrofimages = NSMutableArray.init()
        arrofimages.add("Home5")
        arrofimages.add("Home2")
        arrofimages.add("Home1")
        arrofimages.add("Home4")
        arrofimages.add("Home3")
        //        arrofimages.add("Home6")
        //        arrofimages.add("Home8")
        arrofimages.add("Home7")
        
        arrofFilleCount = NSMutableArray.init()
        arrofFilleCount.add("1")
        arrofFilleCount.add("1")
        arrofFilleCount.add("1")
        arrofFilleCount.add("1")
        arrofFilleCount.add("1")
        arrofFilleCount.add("1")
        arrofFilleCount.add("1")
        arrofFilleCount.add("1")
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        APIServices.SharedInstance.hideProgress()
        getDocSettingsAPIReqiest()
        if networkFunctionality == 1 {
            self.fetchData()
        }
            
    }
    
    @objc func  viewAppointmentsClickedObj(_ notif : Notification){
        let appDeleg = Constatns.Appdelegate
        
        let appointmetnsVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "AppointmetnsViewController") as! AppointmetnsViewController
        
        if let navigationController = appDeleg?.window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(appointmetnsVc, animated: true)
        }
    }
    @objc func  viewPaymentsClickedObj(_ notif : Notification){
        let appDeleg = Constatns.Appdelegate
        
        let appointmetnsVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "PaymentsViewController") as! PaymentsViewController
        
        if let navigationController = appDeleg?.window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(appointmetnsVc, animated: true)
        }
    }
    @objc func  viewClinicsClicked(_ notif : Notification){
        let appDeleg = Constatns.Appdelegate
        
        let appointmetnsVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "ListOfClinicsViewController") as! ListOfClinicsViewController
        
        if let navigationController = appDeleg?.window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(appointmetnsVc, animated: true)
        }
    }
    
    
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewAppointmentsClickedObj(_:)), name: NSNotification.Name(rawValue: "ViewAppointments"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPaymentsClickedObj(_:)), name:NSNotification.Name(rawValue: "ViewPayments"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewClinicsClicked(_:)), name:NSNotification.Name(rawValue: "ViewClinics"), object: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSettingsClicked(_ sender: Any) {
        
        let settingsVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.navigationController?.pushViewController(settingsVC, animated: true)
        
    }
    
    @IBAction func btnNotificationsClicked(_ sender: Any) {
        
        let notificationVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(notificationVc, animated: true)
    }
    
    
    func getDocSettingsAPIReqiest(){
        
        
      //  APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        networkFunctionality = 0
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      DocMenuUpdates.APIRequest.userType : userType]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.DocMenuUpdates, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //    print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
          
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True || String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == " true" {
                
                let strofProfileFill = String(describing:dictofResonse.TabiibDocObjectForKey(forKey: DocMenuUpdates.APIResponse.profilefilling))
                if strofProfileFill == "complete" {
                    self.arrofFilleCount.replaceObject(at: 0, with: "1")
                }else{
                    self.arrofFilleCount.replaceObject(at: 0, with: "0")
                }
                
                
                self.strofClinicCount = String(describing:dictofResonse.TabiibDocObjectForKey(forKey: DocMenuUpdates.APIResponse.clinic_count))
                
                if self.strofClinicCount != "" {
                    self.arrofFilleCount.replaceObject(at: 1, with: "\(self.strofClinicCount)")
                }
                
                
                
                let strofnotifiCount = String(describing:dictofResonse.TabiibDocObjectForKey(forKey: DocMenuUpdates.APIResponse.notificationCount))
                if strofnotifiCount != "" && strofnotifiCount != "0" {
                    self.btnofNotifications.setImage(UIImage.init(named: "Notifications_sele"), for: .normal)
                }else{
                    self.btnofNotifications.setImage(UIImage.init(named: "Notifications"), for: .normal)
                }
                
                let strofAppointPending = String(describing:dictofResonse.TabiibDocObjectForKey(forKey: DocMenuUpdates.APIResponse.pendingApprovals))
                
                if strofAppointPending != "" {
                    self.arrofFilleCount.replaceObject(at: 2, with: "\(strofAppointPending)")
                }
                
                
                
                let strConfrimAppointmentAll = String(describing:dictofResonse.TabiibDocObjectForKey(forKey: DocMenuUpdates.APIResponse.ConfirmAllApp))
                if strConfrimAppointmentAll != "" {
                    UserDefaultStore.isAutoConfirmAppointment = strConfrimAppointmentAll
                }else{
                    UserDefaultStore.isAutoConfirmAppointment = "1"
                }
                
                
                UserDefaultStore.contact_EmailID = String(describing:dictofResonse.TabiibDocObjectForKey(forKey: DocMenuUpdates.APIResponse.contact_EmailID))
                
                UserDefaultStore.contact_Mobileno = String(describing:dictofResonse.TabiibDocObjectForKey(forKey: DocMenuUpdates.APIResponse.contact_Mobileno))
                
                
                UserDefaultStore.UpdatedAppVersionIs = String(describing: dictofResonse.TabiibDocObjectForKey(forKey: DocMenuUpdates.APIResponse.iOSAppVersion))
                
                UserDefaultStore.isIsForcibleUpdate = String(describing: dictofResonse.TabiibDocObjectForKey(forKey: DocMenuUpdates.APIResponse.isForcable))
                
                self.askforCameraPermission()
                
                self.toCheckServerapplicationVersion()
                
                let app = UIApplication.shared.delegate as! AppDelegate
                let context = app.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: settingsCoreDataList.EntityName.Settings, in: context)!
                let object = NSManagedObject(entity: entity, insertInto: context)
                
                object.setValue(self.strofClinicCount, forKey: settingsCoreDataList.Attributes.clinic_count)
                object.setValue(strofnotifiCount, forKey: settingsCoreDataList.Attributes.notificationCount)
                object.setValue(strofAppointPending, forKey: settingsCoreDataList.Attributes.pendingApprovals)
                object.setValue(strConfrimAppointmentAll, forKey: settingsCoreDataList.Attributes.confirmAllApp)
                object.setValue( UserDefaultStore.contact_EmailID, forKey: settingsCoreDataList.Attributes.contact_EmailID)
                object.setValue( UserDefaultStore.contact_Mobileno, forKey: settingsCoreDataList.Attributes.contact_Mobileno)
                object.setValue( UserDefaultStore.UpdatedAppVersionIs, forKey: settingsCoreDataList.Attributes.iOSAppVersion)
                object.setValue(  UserDefaultStore.isIsForcibleUpdate, forKey: settingsCoreDataList.Attributes.isForcable)
                object.setValue(  UserDefaultStore.isIsForcibleUpdate, forKey: settingsCoreDataList.Attributes.profilefilling)
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
                
           
                
            }
            else{
                
                self.askforCameraPermission()
                Utilities.sharedInstace.showAlertviewWithMessage(String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.error_message)))
                
            }
            
            
        }) { (networkErr, messag) in
            
            APIServices.SharedInstance.hideProgress()
            self.networkFunctionality = 1
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
//
//                self.isError = "Home"
//
//                if messag == NetworkErrorIssue{
//                    OopsVC.errorType = NetworkError
//                }
//                self.present(OopsVC, animated: true, completion: nil)
//            }
        }
    }
    
    func fetchData() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName:settingsCoreDataList.EntityName.Settings, in: context)
        fetchRequest.entity = entityDescription
        
        do {
            resultData = try context.fetch(fetchRequest) as [Any]
            print(resultData)
            
            
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
        print(resultData)
        for result in resultData {
//            var dict = (result as AnyObject).value(forKey: "clinic_count")
//            dict = (result as AnyObject).value(forKey: "notificationCount")
//            dict = (result as AnyObject).value(forKey: "pendingApprovals")
//            dict = (result as AnyObject).value(forKey: "confirmAllApp")
//            dict = (result as AnyObject).value(forKey: "contact_EmailID")
//            dict = (result as AnyObject).value(forKey: "contact_Mobileno")
//            dict = (result as AnyObject).value(forKey: "iOSAppVersion")
//            dict = (result as AnyObject).value(forKey: "isForcable")
//            dict = (result as AnyObject).value(forKey: "profilefilling")
//
            
            
            let strofProfileFill =  String(describing:(result as AnyObject).value(forKey: settingsCoreDataList.Attributes.profilefilling))
            if strofProfileFill == "complete" {
                self.arrofFilleCount.replaceObject(at: 0, with: "1")
            }else{
                self.arrofFilleCount.replaceObject(at: 0, with: "0")
            }
            
            
            self.strofClinicCount =  String(describing:(result as AnyObject).value(forKey: settingsCoreDataList.Attributes.clinic_count))
            if self.strofClinicCount != "" {
                self.arrofFilleCount.replaceObject(at: 1, with: "\(self.strofClinicCount)")
            }
            
            
            
            let strofnotifiCount =  String(describing:(result as AnyObject).value(forKey: settingsCoreDataList.Attributes.notificationCount))
            if strofnotifiCount != "" && strofnotifiCount != "0" {
                self.btnofNotifications.setImage(UIImage.init(named: "Notifications_sele"), for: .normal)
            }else{
                self.btnofNotifications.setImage(UIImage.init(named: "Notifications"), for: .normal)
            }
            
            let strofAppointPending =  String(describing:(result as AnyObject).value(forKey: settingsCoreDataList.Attributes.pendingApprovals))
            
            if strofAppointPending != "" {
                self.arrofFilleCount.replaceObject(at: 2, with: "\(strofAppointPending)")
            }
            
            
            
            let strConfrimAppointmentAll =  String(describing:(result as AnyObject).value(forKey: settingsCoreDataList.Attributes.confirmAllApp))
            if strConfrimAppointmentAll != "" {
                UserDefaultStore.isAutoConfirmAppointment = strConfrimAppointmentAll
            }else{
                UserDefaultStore.isAutoConfirmAppointment = "1"
            }
            
            
            UserDefaultStore.contact_EmailID = String(describing:(result as AnyObject).value(forKey: settingsCoreDataList.Attributes.contact_EmailID))
            
            UserDefaultStore.contact_Mobileno = String(describing:(result as AnyObject).value(forKey: settingsCoreDataList.Attributes.contact_Mobileno))
            
            
            UserDefaultStore.UpdatedAppVersionIs = String(describing:(result as AnyObject).value(forKey: settingsCoreDataList.Attributes.iOSAppVersion))
            
            UserDefaultStore.isIsForcibleUpdate = String(describing:(result as AnyObject).value(forKey: settingsCoreDataList.Attributes.isForcable))
            
            self.askforCameraPermission()
            
           // self.toCheckServerapplicationVersion()
        }
        
        
    }
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        if self.isError == "Home"{
            getDocSettingsAPIReqiest()
        }
        
    }
    
    
    
    func checkVersionUpdateOrNot(){
        
        if isAlertisVisible == false {
            _ = SweetAlerts().showAlert2(NSLocalizedString("New Update is Available!", comment: ""), style: .none, buttonTitle: NSLocalizedString("Update", comment: ""), buttonColor: Constatns.ThemeColour(), otherButtonTitle: NSLocalizedString("Not Now", comment: ""), otherbuttonColor: Constatns.ThemeColour(), action: { (clciekdpr) in
                //                print("proceed")
                self.isAlertisVisible = false
                
                //                if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL.init(string: iOSAppLink)!, options: [:], completionHandler: nil)
                //                } else {
                //                    // Fallback on earlier versions
                //                    UIApplication.shared.openURL(URL.init(string: iOSAppLink)!)
                //                }
            }, action2: { (clickOk) in
                //                print("okay")
                self.isAlertisVisible = false
            })
            isAlertisVisible = true
            
        }
        
    }
    
    func checkVersionUpdateForcable(){
        let delegateApp = Constatns.Appdelegate
        if isAlertisVisible == false {
            _  = SweetAlerts().showAlert(NSLocalizedString("New Update is Available!", comment: ""), style: .none, buttonTitle: NSLocalizedString("Proceed", comment: ""), action: { (clciked) in
                delegateApp?.isAlertVisible = false
                self.isAlertisVisible = false
                
                //                if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL.init(string: iOSAppLink)!, options: [:], completionHandler: nil)
                //                } else {
                //                    // Fallback on earlier versions
                //                    UIApplication.shared.openURL(URL.init(string: iOSAppLink)!)
                //                }
            })
            
            delegateApp?.isAlertVisible = true
            isAlertisVisible = true
        }
        
    }
    
    
    func toCheckServerapplicationVersion(){
        let strofCurrAppVersion = Utilities.sharedInstace.getVersion()
        if strofCurrAppVersion != UserDefaultStore.UpdatedAppVersionIs! {
            if UserDefaultStore.isIsForcibleUpdate == "0" {
            //    self.checkVersionUpdateOrNot()
            }
            else{
                self.checkVersionUpdateForcable()
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.applicationVersionUpdataion(notifiobj:)), name: NSNotification.Name(rawValue: "AppisFromBackground"), object: nil)
        }
        
    }
    
    
    @objc func applicationVersionUpdataion(notifiobj : NSNotification){
        toCheckServerapplicationVersion()
    }
    
    
    
    func askforCameraPermission(){
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                
                if response == true {
                }
                else{
                    //self.showAlertforcameraPermisson()
                }
                
                self.askforPhotosPermission()
            }
        }
        
    }
    
    func askforPhotosPermission() {
        
        if PHPhotoLibrary.authorizationStatus() == .
            notDetermined {
            
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    
                }
                else {
                    // self.showAlertForPhotoLibrary()
                    
                }
                }
            )}
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

extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrofOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let optionsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        optionsCell.lblofOption.text = String(describing: arrofOptions[indexPath.row])
        optionsCell.imgOfOption.image = UIImage.init(named: String(describing:arrofimages[indexPath.row]))
        optionsCell.lblofOption.textAlignment = .center
        
        return optionsCell
        
    }
    
    fileprivate func navigateToParticularVC(_ index : Int) {
        
        switch index {
        case 0:
            //profile
            
            DispatchQueue.main.async {
                let profileVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                self.navigationController?.pushViewController(profileVc, animated: true)
                
            }
            break
        case 1:
            //clinics
            
            if strofClinicCount == "0" && strofClinicCount != "" {
                
                let addnewClinicVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "AddClinicsViewController") as! AddClinicsViewController
                self.navigationController?.pushViewController(addnewClinicVC, animated: true)
                
            }else{
                
                //need to check if user already have clinics
                let clinicListVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "ListOfClinicsViewController") as! ListOfClinicsViewController
                self.navigationController?.pushViewController(clinicListVc, animated: true)
                
            }
            
            break
        case 2:
            //appointments
            
            let appointsVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "AppointmetnsViewController") as! AppointmetnsViewController
            self.navigationController?.pushViewController(appointsVc, animated: true)
            
            break
        case 3:
            //payments
            
         //   let server = NSLocalizedString("Coming Soon...", comment: "")
         //   Utilities.sharedInstace.showAlertviewWithMessage(server)
            
                        let paymentsVc  = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "PaymentsViewController") as! PaymentsViewController
                        self.navigationController?.pushViewController(paymentsVc, animated: true)
            
            break
        case 4:
            //language
            
            let languSeleVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
            self.navigationController?.pushViewController(languSeleVc, animated: true)
            
            break
        case 5:
            //reports
            
            let supportVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
            self.navigationController?.pushViewController(supportVc, animated: true)
            
            
            
            break
        case 6:
            //webaccess
            
            let supportVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
            self.navigationController?.pushViewController(supportVc, animated: true)
            
            
            
            break
        case 7:
            //support
            
            let supportVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
            self.navigationController?.pushViewController(supportVc, animated: true)
            
            break
        default:
            break
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToParticularVC(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CGSize(width: (self.view.frame.size.width/3), height: 145)
        }
        else if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: (self.view.frame.size.width/3), height: 250)
        }
        return CGSize(width: (self.view.frame.size.width/3), height: 145)
    }
    
    
}

