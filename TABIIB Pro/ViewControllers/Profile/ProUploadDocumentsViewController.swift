//
//  ProUploadDocumentsViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary
import AVFoundation
import Photos
import CoreData

protocol UploadDocumentsDetailsContinueDelegate {
    
    func continueUploadClicked()
    func viewDocumentClicked(_ documentObj : DoctorIdentificationProof)
}

public class DoctorIdentificationProof {
    
    var strofBase64 : String! = ""
    var strFileName : String! = ""
    var isDataUpdated : String! = "0"
    var selectedImage : UIImage? = UIImage.init()
    var isServerimagePath : String! = ""
    var serverIndex : Int! = 0
}



class ProUploadDocumentsViewController: UIViewController,ErrorProtocalDelegate,UploadDocumentsDetailsContinueDelegate {
    
    func viewDocumentClicked(_ documentObj: DoctorIdentificationProof) {
        
    }
    
    func continueUploadClicked() {
        
    }
    
    @IBOutlet var scrollofContent: UIScrollView!
    @IBOutlet var tbofDocuments: UITableView!
    var delegate : UploadDocumentsDetailsContinueDelegate!
    var arrofTitles : [String] = [String]()
    var arrofMedicalProofs : NSMutableArray!
    var arrofEducationProofs : NSMutableArray!
    
    var netofMedicalProofs : NSMutableArray!
    var netofEducationProofs : NSMutableArray!
    
    var myPickerController = UIImagePickerController()
    
    var singleTonObj : SingleTonClass!
    var isCameraPermissonAlertShown = false
    var isPhotolibPermisAlertshown = false
    
    var selectedSection : Int! = 0
    
    
    var strofRegisProof1_f : String = "0"
    var strofRegisProof2_f : String = "0"
    var strofRegisProof3_f : String = "0"
    
    var strofEdiucationProof1_f : String = "0"
    var strofEdiucationProof2_f : String = "0"
    var strofEdiucationProof3_f : String = "0"
    
    var istoSendRequest : Bool = false
    var isError : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrofTitles = [NSLocalizedString("Proof of Medical Registration", comment: ""),NSLocalizedString("Proofs of Qualification", comment: "")]
        
        arrofMedicalProofs = NSMutableArray.init()
        arrofEducationProofs = NSMutableArray.init()
        
        singleTonObj = SingleTonClass.SharedInstance
        
        myPickerController.delegate = self
        
        askforCameraPermission()
        askforPhotosPermission()
        
//        if Connectivity.isCheckForNewwork() == false {
//            fetchData()
//        }
        
    }
    
    
    func askforCameraPermission(){
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                
                if response == true {
                }
                else{
                    //self.showAlertforcameraPermisson()
                }
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
    
    
    func checkCameraAceess() -> Bool{
        var isHaveAcces = false
        if Utilities.sharedInstace.checkCameraRuntimePermission() {
            isHaveAcces = true
        }
        else{
            // showAlertforcameraPermisson()
        }
        
        return isHaveAcces
    }
    
    
    func checkPhotosAccess() -> Bool {
        var isHaveAcces = false
        if Utilities.sharedInstace.checkPhotosRuntimePermisson() {
            isHaveAcces = true
        }
        else{
            // showAlertForPhotoLibrary()
        }
        
        return isHaveAcces
    }
    
    
    
    func showAlertForPhotoLibrary(){
        
        let photoperm = NSLocalizedString("Photos permission", comment : "")
        let okay = NSLocalizedString("Okay", comment : "")
        
        let objofSweetAlrt = SweetAlerts()
        objofSweetAlrt.isTapGestureReg = false
        //        if isPhotolibPermisAlertshown == false {
        _ =  objofSweetAlrt.showAlert(photoperm, style: .none, buttonTitle: okay, action: { (clciked) in
            Utilities.sharedInstace.openAppPermissions()
        })
        //            isPhotolibPermisAlertshown = true
        //        }
    }
    
    func showAlertforcameraPermisson(){
        
        let camperm = NSLocalizedString("Camera permissions", comment : "")
        let okay = NSLocalizedString("Okay", comment : "")
        
        let objofSweetAlrt = SweetAlerts()
        objofSweetAlrt.isTapGestureReg = false
        //        if isCameraPermissonAlertShown == false {
        _ =  objofSweetAlrt.showAlert(camperm, style: .none, buttonTitle: okay, action: { (clciked) in
            Utilities.sharedInstace.openAppPermissions()
        })
        //            isCameraPermissonAlertShown = true
        //        }
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
    func showActionSheetForIpad(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            
            if self.checkCameraAceess(){
                self.camera()
            }else{
                if self.selectedSection == 0 {
                    self.arrofMedicalProofs.removeObject(at: 0)
                }
                else{
                    self.arrofEducationProofs.removeObject(at: 0)
                }
                self.showAlertforcameraPermisson()
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Gallery", comment: ""), style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            
            if self.checkPhotosAccess(){
                self.photoLibrary()
            }else{
                if self.selectedSection == 0 {
                    self.arrofMedicalProofs.removeObject(at: 0)
                }
                else{
                    self.arrofEducationProofs.removeObject(at: 0)
                }
                self.showAlertForPhotoLibrary()
            }
            
        }))
        
        
        //           actionSheet.addAction(UIAlertAction(title: "Add Document", style: .default, handler: {
        //                        action in
        //
        //
        //                   self.openfileUploadClicked()
        //
        //           }))
        //
        
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: { (alert:UIAlertAction!) -> Void in
            
            if self.selectedSection == 0 {
                self.arrofMedicalProofs.removeObject(at: 0)
            }
            else{
                self.arrofEducationProofs.removeObject(at: 0)
            }
            self.tbofDocuments.reloadData()
            
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func showActionSheet() {
        
         let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            
            if self.checkCameraAceess(){
                self.camera()
            }else{
                if self.selectedSection == 0 {
                    self.arrofMedicalProofs.removeObject(at: 0)
                }
                else{
                    self.arrofEducationProofs.removeObject(at: 0)
                }
                self.showAlertforcameraPermisson()
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Gallery", comment: ""), style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            
            if self.checkPhotosAccess(){
                self.photoLibrary()
            }else{
                if self.selectedSection == 0 {
                    self.arrofMedicalProofs.removeObject(at: 0)
                }
                else{
                    self.arrofEducationProofs.removeObject(at: 0)
                }
                self.showAlertForPhotoLibrary()
            }
            
        }))
        
        
        //           actionSheet.addAction(UIAlertAction(title: "Add Document", style: .default, handler: {
        //                        action in
        //
        //
        //                   self.openfileUploadClicked()
        //
        //           }))
        //
        
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: { (alert:UIAlertAction!) -> Void in
            
            if self.selectedSection == 0 {
                self.arrofMedicalProofs.removeObject(at: 0)
            }
            else{
                self.arrofEducationProofs.removeObject(at: 0)
            }
            self.tbofDocuments.reloadData()
            
        }))

        self.present(actionSheet, animated: true, completion: nil)
       
    }
    
    func bindDocuments(){
        
        // let newmedicalProof = DoctorIdentificationProof.init()
        //        arrofMedicalProofs.add(newmedicalProof)
        
        
        arrofEducationProofs.removeAllObjects()
        arrofMedicalProofs.removeAllObjects()
        //check if any documents are empty
        
        if singleTonObj.UserObjct.educationproof_1 != ""{
            let neweducationProof = DoctorIdentificationProof.init()
            neweducationProof.isDataUpdated = "0"
            neweducationProof.isServerimagePath = singleTonObj.UserObjct.educationproof_1
            strofEdiucationProof1_f = "0"
            neweducationProof.strFileName = "Education Proof_1"
            neweducationProof.serverIndex = 0
            arrofEducationProofs.add(neweducationProof)
        }
        if singleTonObj.UserObjct.educationproof_2 != "" {
            let neweducationProof = DoctorIdentificationProof.init()
            neweducationProof.isDataUpdated = "0"
            neweducationProof.isServerimagePath = singleTonObj.UserObjct.educationproof_2
            strofEdiucationProof2_f = "0"
            neweducationProof.strFileName = "Education Proof_2"
            neweducationProof.serverIndex = 1
            arrofEducationProofs.add(neweducationProof)
        }
        if singleTonObj.UserObjct.educationproof_3 != "" {
            let neweducationProof = DoctorIdentificationProof.init()
            neweducationProof.isDataUpdated = "0"
            neweducationProof.isServerimagePath = singleTonObj.UserObjct.educationproof_3
            strofEdiucationProof3_f = "0"
            neweducationProof.serverIndex = 2
            neweducationProof.strFileName = "Education Proof_"
            arrofEducationProofs.add(neweducationProof)
        }
        
        if singleTonObj.UserObjct.registrproof_1 != "" {
            let newregistraProof = DoctorIdentificationProof.init()
            newregistraProof.isDataUpdated = "0"
            newregistraProof.isServerimagePath = singleTonObj.UserObjct.registrproof_1
            strofRegisProof1_f = "0"
            newregistraProof.serverIndex = 0
            newregistraProof.strFileName = "Medical Proof_1"
            newregistraProof.strofBase64 = ""
            arrofMedicalProofs.add(newregistraProof)
        }
        if singleTonObj.UserObjct.registrproof_2 != "" {
            let newregistraProof = DoctorIdentificationProof.init()
            newregistraProof.isDataUpdated = "0"
            newregistraProof.isServerimagePath = singleTonObj.UserObjct.registrproof_2
            strofRegisProof2_f = "1"
            newregistraProof.serverIndex = 1
            newregistraProof.strFileName = "Medical Proof_2"
            newregistraProof.strofBase64 = ""
            
            arrofMedicalProofs.add(newregistraProof)
        }
        if singleTonObj.UserObjct.registrproof_3 != "" {
            let newregistraProof = DoctorIdentificationProof.init()
            newregistraProof.isDataUpdated = "0"
            newregistraProof.isServerimagePath = singleTonObj.UserObjct.registrproof_3
            strofEdiucationProof3_f = "1"
            newregistraProof.serverIndex = 2
            newregistraProof.strFileName = "Medical Proof_3"
            newregistraProof.strofBase64 = ""
            
            arrofMedicalProofs.add(newregistraProof)
        }
        
        tbofDocuments.reloadData()
        
    }
    
    
    
    func getReqParameters() -> NSMutableDictionary {
        
        let dicotfRequestformat = NSMutableDictionary.init()
        dicotfRequestformat.setValue(UserDefaultStore.ApiKey, forKey: APIRequestKeys.ApiKey)
        dicotfRequestformat.setValue(UserDefaultStore.userRef, forKey: APIRequestKeys.userRef)
        
        var strofRegisProof1 : String = String(describing:"")
        var strofRegisProof2 : String = String(describing:"")
        var strofRegisProof3 : String = String(describing:"")
        
        var strofEdiucationProof1 : String = String(describing:"")
        var strofEdiucationProof2 : String = String(describing:"")
        var strofEdiucationProof3 : String = String(describing:"")
        
        
        
        if arrofMedicalProofs.count > 0 {
            
            let documetObj1 = arrofMedicalProofs[0] as! DoctorIdentificationProof
            
            if documetObj1.serverIndex == 0 {
                strofRegisProof1_f = documetObj1.isDataUpdated
                strofRegisProof1 = documetObj1.strofBase64
            }else if documetObj1.serverIndex == 1 {
                strofRegisProof2_f = documetObj1.isDataUpdated
                strofRegisProof2 = documetObj1.strofBase64
            }
            else if documetObj1.serverIndex == 2 {
                strofRegisProof3_f = documetObj1.isDataUpdated
                strofRegisProof3 = documetObj1.strofBase64
            }
            
            if arrofMedicalProofs.count > 1 {
                
                let documetObj2 = arrofMedicalProofs[1] as! DoctorIdentificationProof
                
                if documetObj2.serverIndex == 0 {
                    strofRegisProof1_f = documetObj2.isDataUpdated
                    strofRegisProof1 = documetObj2.strofBase64
                }else if documetObj2.serverIndex == 1 {
                    strofRegisProof2_f = documetObj2.isDataUpdated
                    strofRegisProof2 = documetObj2.strofBase64
                }
                else if documetObj2.serverIndex == 2 {
                    strofRegisProof3_f = documetObj2.isDataUpdated
                    strofRegisProof3 = documetObj2.strofBase64
                }
                
                
                if arrofMedicalProofs.count > 2 {
                    
                    let documetObj3 = arrofMedicalProofs[2] as! DoctorIdentificationProof
                    if documetObj3.serverIndex == 0 {
                        strofRegisProof1_f = documetObj3.isDataUpdated
                        strofRegisProof1 = documetObj3.strofBase64
                    }else if documetObj3.serverIndex == 1 {
                        strofRegisProof2_f = documetObj3.isDataUpdated
                        strofRegisProof2 = documetObj3.strofBase64
                    }
                    else if documetObj3.serverIndex == 2 {
                        strofRegisProof3_f = documetObj3.isDataUpdated
                        strofRegisProof3 = documetObj3.strofBase64
                    }
                    
                }
                
            }
            
        }
        
        
        
        if arrofEducationProofs.count > 0 {
            
            let documetObj1 = arrofEducationProofs[0] as! DoctorIdentificationProof
            if documetObj1.serverIndex == 0 {
                strofEdiucationProof1_f = documetObj1.isDataUpdated
                strofEdiucationProof1 = documetObj1.strofBase64
            }else if documetObj1.serverIndex == 1 {
                strofEdiucationProof2_f = documetObj1.isDataUpdated
                strofEdiucationProof2 = documetObj1.strofBase64
            }
            else if documetObj1.serverIndex == 2 {
                strofEdiucationProof3_f = documetObj1.isDataUpdated
                strofEdiucationProof3 = documetObj1.strofBase64
            }
            
            if arrofEducationProofs.count > 1 {
                
                let documetObj2 = arrofEducationProofs[1] as! DoctorIdentificationProof
                if documetObj2.serverIndex == 0 {
                    strofEdiucationProof1_f = documetObj2.isDataUpdated
                    strofEdiucationProof1 = documetObj2.strofBase64
                }else if documetObj2.serverIndex == 1 {
                    strofEdiucationProof2_f = documetObj2.isDataUpdated
                    strofEdiucationProof2 = documetObj2.strofBase64
                }
                else if documetObj2.serverIndex == 2 {
                    strofEdiucationProof3_f = documetObj2.isDataUpdated
                    strofEdiucationProof3 = documetObj2.strofBase64
                }
                
                if arrofEducationProofs.count > 2 {
                    
                    let documetObj3 = arrofEducationProofs[2] as! DoctorIdentificationProof
                    if documetObj3.serverIndex == 0 {
                        strofEdiucationProof1_f = documetObj3.isDataUpdated
                        strofEdiucationProof1 = documetObj3.strofBase64
                    }else if documetObj3.serverIndex == 1 {
                        strofEdiucationProof2_f = documetObj3.isDataUpdated
                        strofEdiucationProof2 = documetObj3.strofBase64
                    }
                    else if documetObj3.serverIndex == 2 {
                        strofEdiucationProof3_f = documetObj3.isDataUpdated
                        strofEdiucationProof3 = documetObj3.strofBase64
                    }
                    
                }
                
            }
            
            
            
        }
        
        
        
        dicotfRequestformat.setValue(strofRegisProof1, forKey: UpdateEducationProofDocuments.APIRequest.regProof)
        dicotfRequestformat.setValue(strofRegisProof2, forKey: UpdateEducationProofDocuments.APIRequest.regProof_1)
        dicotfRequestformat.setValue(strofRegisProof3, forKey: UpdateEducationProofDocuments.APIRequest.regProof_2)
        
        dicotfRequestformat.setValue(strofRegisProof1_f, forKey: UpdateEducationProofDocuments.APIRequest.regProof_Flag)
        dicotfRequestformat.setValue(strofRegisProof2_f, forKey: UpdateEducationProofDocuments.APIRequest.regProof_1_Flag)
        dicotfRequestformat.setValue(strofRegisProof3_f, forKey: UpdateEducationProofDocuments.APIRequest.regProof_2_Flag)
        
        
        
        dicotfRequestformat.setValue(strofEdiucationProof1, forKey: UpdateEducationProofDocuments.APIRequest.eduQualProof)
        dicotfRequestformat.setValue(strofEdiucationProof2, forKey: UpdateEducationProofDocuments.APIRequest.eduQualProof_1)
        dicotfRequestformat.setValue(strofEdiucationProof3, forKey: UpdateEducationProofDocuments.APIRequest.eduQualProof_2)
        
        dicotfRequestformat.setValue(strofEdiucationProof1_f, forKey: UpdateEducationProofDocuments.APIRequest.eduQualProof_Flag)
        dicotfRequestformat.setValue(strofEdiucationProof2_f, forKey: UpdateEducationProofDocuments.APIRequest.eduQualProof_1_Flag)
        dicotfRequestformat.setValue(strofEdiucationProof3_f, forKey: UpdateEducationProofDocuments.APIRequest.eduQualProof_2_Flag)
        
        
        return dicotfRequestformat
        
    }
    
//    func fetchData() {
//
//        let app = UIApplication.shared.delegate as! AppDelegate
//        let context = app.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ProfileDetailsCoreDataList.EntityName.ProfileDetails)
//
//        do {
//            let results = try context.fetch(fetchRequest)
//            print(results)
//
//
//            if results.count != 0 {
//
//                for result in results {
//
//                    let data = (result as AnyObject).value(forKey: ProfileDetailsCoreDataList.Attributes.personalDetails) as! NSData
//                    let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:data as Data)
//                    let arrayObject = unarchiveObject  as! NSDictionary
//                    if arrayObject.count > 0 {
//
//                        let resultOfPro = arrayObject.value(forKey: "data") as! NSArray
//                        var values = resultOfPro[0] as! NSDictionary
//
//                        let regProof =  String(describing:values.value(forKey:UpdateEducationProofDocuments.APIRequest.regProof))
//                        print(regProof as Any)
//                        let regProof_1 =  String(describing:values.value(forKey:UpdateEducationProofDocuments.APIRequest.regProof_1))
//                        let regProof_2 =  String(describing:values.value(forKey:UpdateEducationProofDocuments.APIRequest.regProof_2))
//                       let regProof_Flag =  String(describing:values.value(forKey:UpdateEducationProofDocuments.APIRequest.regProof_Flag))
//                       let regProof_1_Flag =  String(describing:values.value(forKey:UpdateEducationProofDocuments.APIRequest.regProof_1_Flag))
//                     let regProof_2_Flag =  String(describing:values.value(forKey:UpdateEducationProofDocuments.APIRequest.regProof_2_Flag))
//                      let eduQualProof =  String(describing:values.value(forKey:UpdateEducationProofDocuments.APIRequest.eduQualProof))
//                      let eduQualProof_1 =  String(describing:values.value(forKey:UpdateEducationProofDocuments.APIRequest.eduQualProof_1))
//                      let eduQualProof_2 =  String(describing:values.value(forKey:UpdateEducationProofDocuments.APIRequest.eduQualProof_2))
//                      let eduQualProof_Flag =  String(describing:values.value(forKey:UpdateEducationProofDocuments.APIRequest.eduQualProof_Flag))
//                      let eduQualProof_1_Flag =  String(describing:values.value(forKey:UpdateEducationProofDocuments.APIRequest.eduQualProof_1_Flag))
//                      let eduQualProof_2_Flag =  String(describing:values.value(forKey:UpdateEducationProofDocuments.APIRequest.eduQualProof_2_Flag))
//                       values = getReqParameters()
//                       arrofMedicalProofs.add(regProof)
//                       arrofMedicalProofs.add(regProof_1)
//                       arrofMedicalProofs.add(regProof_2)
//                       arrofMedicalProofs.add(regProof_Flag)
//                       arrofMedicalProofs.add(regProof_1_Flag)
//                       arrofMedicalProofs.add(regProof_2_Flag)
//                       arrofEducationProofs.add(eduQualProof)
//                       arrofEducationProofs.add(eduQualProof_1)
//                       arrofEducationProofs.add(eduQualProof_2)
//                       arrofEducationProofs.add(eduQualProof_Flag)
//                       arrofEducationProofs.add(eduQualProof_1_Flag)
//                       arrofEducationProofs.add(eduQualProof_2_Flag)
//
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
//
//
    
    
    func callforUploadEduProofs(){
        
        /*{"ApiKey":"SKZHTiNhgR6G9TSl","userRef":"QmalxZn4UQEWfSq6","regProof":"gbfsdhgdf","regProof_1":"gbfsdhgdf","regProof_2":"gbfsdhgdf","eduQualProof":"fghgd","eduQualProof_1":"fghgd","eduQualProof_2":"fghgd"}*/
        
        
        APIServices.SharedInstance.MbProgress(view: self.view, Message: "Loading...")
        
        let param : [String : Any] = getReqParameters() as! [String : Any]
        
        //   print(param)
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.updateEduProofs, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                
                if let delegate = self.delegate {
                    delegate.continueUploadClicked()
                }
                
            }
            else{
                
                Utilities.sharedInstace.showAlertviewWithMessage(NSLocalizedString("Something went to wrong", comment: ""))
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
                self.isError = "updateproof"
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        if self.isError == "updateproof"{
            callforUploadEduProofs()
        }
        
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        
        if arrofMedicalProofs.count == 0{
            Utilities.sharedInstace.showAlertviewWithMessage(NSLocalizedString("please select at least one Medical proof", comment: ""))
        }else if arrofEducationProofs.count == 0{
            Utilities.sharedInstace.showAlertviewWithMessage(NSLocalizedString("please select at least one Educational proof", comment: ""))
        }else{
            if istoSendRequest == true {
                callforUploadEduProofs()
            }else{
                if let delegate = self.delegate {
                    delegate.continueUploadClicked()
                }
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openfileUploadClicked(){
        
        var documentpicker : UIDocumentPickerViewController!
        documentpicker = UIDocumentPickerViewController.init(documentTypes: [String(kUTTypeItem)], in: .import)
        documentpicker.delegate = self
        documentpicker.modalPresentationStyle = .formSheet
        self.present(documentpicker, animated: true, completion: nil)
        
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

extension ProUploadDocumentsViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        var strOfFile : String! = ""
        
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
            
            strOfFile = asset?.value(forKey: "filename") as! String
            //  print(asset?.value(forKey: "filename") as Any)
        }
        
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let imageData: Data = UIImageJPEGRepresentation(chosenImage, 0.1)!
        
        let  strOfProfilePic = (imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) as NSString) as String
        
        if selectedSection == 0 {
            let documentObj = arrofMedicalProofs.firstObject as! DoctorIdentificationProof
            documentObj.strofBase64 = strOfProfilePic
            documentObj.selectedImage = chosenImage
            documentObj.strFileName = strOfFile
            documentObj.isDataUpdated = "1"
        }
        else{
            let documentObj = arrofEducationProofs.firstObject as! DoctorIdentificationProof
            documentObj.strofBase64 = strOfProfilePic
            documentObj.selectedImage = chosenImage
            documentObj.strFileName = strOfFile
            documentObj.isDataUpdated = "1"
        }
        
        istoSendRequest = true
        self.dismiss(animated: true, completion: nil)
        
        self.tbofDocuments.reloadData()
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        //        selectedImage = nil
        //        strOfProfilePic = ""
        if selectedSection == 0 {
            arrofMedicalProofs.removeObject(at: 0)
        }
        else{
            arrofEducationProofs.removeObject(at: 0)
        }
        self.dismiss(animated: true, completion: nil)
        self.tbofDocuments.reloadData()
    }
    
}
extension ProUploadDocumentsViewController : UIDocumentPickerDelegate{
    
    func getSelectedFileName(_ filePath : String) -> String {
        
        var strofString = ""
        
        let arrofObjects = filePath.components(separatedBy: "/")
        
        if arrofObjects.count > 0 {
            strofString = arrofObjects.last!
        }
        
        
        return strofString
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let cico = url as URL
        //        print("The Url is : \(cico)")
        var base64StringofData = ""
        do {
            let fileData = try Data.init(contentsOf: cico)
            base64StringofData = fileData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        }catch {
            print("error at convert to base 64 string")
        }
        
        //  print(selectedIndex)
        
        let strofFilename = self.getSelectedFileName(cico.path)
        
        if selectedSection == 0 {
            let documentObj = arrofMedicalProofs.firstObject as! DoctorIdentificationProof
            documentObj.strofBase64 = base64StringofData
            documentObj.selectedImage = nil
            documentObj.strFileName = "\(strofFilename) \(selectedSection) \(arrofMedicalProofs.count)"
            documentObj.isDataUpdated = "1"
        }
        else{
            let documentObj = arrofEducationProofs.firstObject as! DoctorIdentificationProof
            documentObj.strofBase64 = base64StringofData
            documentObj.selectedImage = nil
            documentObj.strFileName = "\(strofFilename) \(selectedSection) \(arrofEducationProofs.count)"
            documentObj.isDataUpdated = "1"
        }
        istoSendRequest = true
        //        arrofSelectedfileNames.replaceObject(at: selectedIndex, with: strofFilename)
        //
        //        let dictofObj = arrofUpdateObjects[selectedIndex] as! NSMutableDictionary
        //
        //        dictofObj.setValue(base64StringofData, forKey: "Data")
        //
        self.tbofDocuments.reloadData()
    }
    
    public func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
        
    }
    
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        //  print("we cancelled")
        
        if selectedSection == 0 {
            arrofMedicalProofs.removeObject(at: 0)
        }
        else{
            arrofEducationProofs.removeObject(at: 0)
        }
        self.dismiss(animated: true, completion: nil)
        self.tbofDocuments.reloadData()
        
    }
    
}

extension ProUploadDocumentsViewController : UITableViewDelegate,UITableViewDataSource,DocumentUploadCellDelegate{
    
    
    
    
    func viewDocClicked(_ cell: UploadDocsAttachmentTableViewCell) {
        
        guard let indexPath = self.tbofDocuments.indexPath(for: cell) else {
            // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
            return
        }
        
        //        print(indexPath.section)
        //        print(indexPath.row)
        //
        if indexPath.section == 1 {
            
            let selectedDocuemnt = arrofMedicalProofs[indexPath.row] as! DoctorIdentificationProof
            if let delegateObj = self.delegate {
                delegateObj.viewDocumentClicked(selectedDocuemnt)
            }
        }
        else{
            
            let selectedDocuemnt = arrofEducationProofs[indexPath.row] as! DoctorIdentificationProof
            if let delegateObj = self.delegate {
                delegateObj.viewDocumentClicked(selectedDocuemnt)
            }
        }
        
    }
    
    func deleteDocClicked(_ cell: UploadDocsAttachmentTableViewCell) {
        
        guard let indexPath = self.tbofDocuments.indexPath(for: cell) else {
            // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
            return
        }
        
        //        print(indexPath.section)
        //        print(indexPath.row)
        //
        if indexPath.section == 1 {
            
            
            if indexPath.row == 0 {
                let doctiden = arrofMedicalProofs[0] as! DoctorIdentificationProof
                doctiden.isDataUpdated = "1"
                if doctiden.serverIndex == 0 {
                    strofRegisProof1_f = "1"
                }
                else if doctiden.serverIndex == 1 {
                    strofRegisProof2_f = "1"
                }
                else if doctiden.serverIndex == 2 {
                    strofRegisProof3_f = "1"
                }
                
            }
            else if indexPath.row == 1 {
                let doctiden = arrofMedicalProofs[1] as! DoctorIdentificationProof
                doctiden.isDataUpdated = "1"
                if doctiden.serverIndex == 0 {
                    strofRegisProof1_f = "1"
                }
                else if doctiden.serverIndex == 1 {
                    strofRegisProof2_f = "1"
                }
                else if doctiden.serverIndex == 2 {
                    strofRegisProof3_f = "1"
                }
            }
            else if indexPath.row == 2 {
                let doctiden = arrofMedicalProofs[2] as! DoctorIdentificationProof
                doctiden.isDataUpdated = "1"
                if doctiden.serverIndex == 0 {
                    strofRegisProof1_f = "1"
                }
                else if doctiden.serverIndex == 1 {
                    strofRegisProof2_f = "1"
                }
                else if doctiden.serverIndex == 2 {
                    strofRegisProof3_f = "1"
                }
            }
            
            arrofMedicalProofs.removeObject(at: indexPath.row)
        }
        else{
            
            if indexPath.row == 0 {
                let doctiden = arrofEducationProofs[0] as! DoctorIdentificationProof
                doctiden.isDataUpdated = "1"
                if doctiden.serverIndex == 0 {
                    strofEdiucationProof1_f = "1"
                    
                }
                else if doctiden.serverIndex == 1 {
                    strofEdiucationProof2_f = "1"
                    
                }
                else if doctiden.serverIndex == 2 {
                    strofEdiucationProof3_f = "1"
                    
                }
            }
            else if indexPath.row == 1 {
                let doctiden = arrofEducationProofs[1] as! DoctorIdentificationProof
                doctiden.isDataUpdated = "1"
                if doctiden.serverIndex == 0 {
                    strofEdiucationProof1_f = "1"
                    
                }
                else if doctiden.serverIndex == 1 {
                    strofEdiucationProof2_f = "1"
                    
                }
                else if doctiden.serverIndex == 2 {
                    strofEdiucationProof3_f = "1"
                    
                }
            }
            else if indexPath.row == 2 {
                let doctiden = arrofEducationProofs[2] as! DoctorIdentificationProof
                doctiden.isDataUpdated = "1"
                if doctiden.serverIndex == 0 {
                    strofEdiucationProof1_f = "1"
                    
                }
                else if doctiden.serverIndex == 1 {
                    strofEdiucationProof2_f = "1"
                    
                }
                else if doctiden.serverIndex == 2 {
                    strofEdiucationProof3_f = "1"
                    
                }
            }
            
            arrofEducationProofs.removeObject(at: indexPath.row)
            
        }
        
        istoSendRequest = true
        
        self.tbofDocuments.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }
        else  if section == 1 {
            return arrofMedicalProofs.count
        }else{
            return arrofEducationProofs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1  || indexPath.section == 2 {
            
            
            let attachmentCell = tableView.dequeueReusableCell(withIdentifier: "UploadDocsAttachmentTableViewCell", for: indexPath) as! UploadDocsAttachmentTableViewCell
            
            
            attachmentCell.delegate = self
            
            if indexPath.section == 1 {
                
                if Connectivity.isCheckForNewwork() == true {
                    
                let documrObj = arrofMedicalProofs[indexPath.row] as! DoctorIdentificationProof
                attachmentCell.lblofAttachmentTitle.text = documrObj.strFileName
                
                if indexPath.row == arrofMedicalProofs.count-1 {
                    attachmentCell.lblofSeparator.isHidden = false
                }else{
                    attachmentCell.lblofSeparator.isHidden = true
                }
                    
                } else {
                    
                    let documrObj = arrofMedicalProofs[indexPath.row] as! DoctorIdentificationProof
                    attachmentCell.lblofAttachmentTitle.text = documrObj.strFileName
                    
                    if indexPath.row == arrofMedicalProofs.count-1 {
                        attachmentCell.lblofSeparator.isHidden = false
                    }else{
                        attachmentCell.lblofSeparator.isHidden = true
                    }
                    
                }
            }
            else{
                
                if Connectivity.isCheckForNewwork() == true {
                
                let documrObj = arrofEducationProofs[indexPath.row] as! DoctorIdentificationProof
                attachmentCell.lblofAttachmentTitle.text = documrObj.strFileName
                
                if indexPath.row == arrofEducationProofs.count-1 {
                    attachmentCell.lblofSeparator.isHidden = false
                }else{
                    attachmentCell.lblofSeparator.isHidden = true
                }
                    
                } else {
                    
                    let documrObj = arrofEducationProofs[indexPath.row] as! DoctorIdentificationProof
                    attachmentCell.lblofAttachmentTitle.text = documrObj.strFileName
                    
                    if indexPath.row == arrofEducationProofs.count-1 {
                        attachmentCell.lblofSeparator.isHidden = false
                    }else{
                        attachmentCell.lblofSeparator.isHidden = true
                    }
                }
            }
            
            attachmentCell.selectionStyle = .none
            return attachmentCell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let selectedDocuemnt = arrofMedicalProofs[indexPath.row] as! DoctorIdentificationProof
            if let delegateObj = self.delegate {
                delegateObj.viewDocumentClicked(selectedDocuemnt)
            }
        }else{
            let selectedDocuemnt = arrofEducationProofs[indexPath.row] as! DoctorIdentificationProof
            if let delegateObj = self.delegate {
                delegateObj.viewDocumentClicked(selectedDocuemnt)
            }
        }
        
        
        
        
    }
    
    @objc func addnewMedicalProofClicked(_ sender : UIButton){
        
        if arrofMedicalProofs.count == 3 {
            
            Utilities.sharedInstace.showAlertviewWithMessage(NSLocalizedString("Max limit of medical proofs are 3 only", comment: ""))
            
        }else{
            
            let newmedicalProof = DoctorIdentificationProof.init()
            arrofMedicalProofs.insert(newmedicalProof, at: 0)
            newmedicalProof.serverIndex = arrofMedicalProofs.count - 1
            //   arrofMedicalProofs.add(newmedicalProof)
            selectedSection = sender.tag
           
            if UIDevice.current.userInterfaceIdiom == .pad{
                showActionSheetForIpad()
            }else{
                 showActionSheet()
            }
            
          }
        
        //    self.tbofDocuments.reloadData()
        
    }
    
    
    
    
    @objc func addnewEducationProofClicked(_ sender : UIButton){
        
        if arrofEducationProofs.count == 3 {
            
            Utilities.sharedInstace.showAlertviewWithMessage(NSLocalizedString("Max limit of education proofs are 3 only", comment: ""))
            
        }else{
            
            let newEducationProof = DoctorIdentificationProof.init()
            arrofEducationProofs.insert(newEducationProof, at: 0)
            newEducationProof.serverIndex = arrofEducationProofs.count - 1
            //            arrofEducationProofs.add(newEducationProof)
            selectedSection = sender.tag
            if UIDevice.current.userInterfaceIdiom == .pad{
                showActionSheetForIpad()
            }else{
                showActionSheet()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if section == 0 {
                return 172
            }else{
                return 45
            }
            
        } else {
            if section == 0 {
                return 350
            }else{
                return 60
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 70
        }else {
            return 100
        }
        
        //  return 70
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "UploadDocsSectionHeaderTableViewCell") as! UploadDocsSectionHeaderTableViewCell
            
            return sectionHeader
        }
        else{
            let sectionTitle = tableView.dequeueReusableCell(withIdentifier: "UploadDocSectilonTitleTableViewCell") as! UploadDocSectilonTitleTableViewCell
            if section == 1 {
                sectionTitle.lblofTitle.text = arrofTitles[0]
                sectionTitle.btnofAddnewDocs.tag = 0
                //            if arrofMedicalProofs.count == 3 {
                //                sectionTitle.btnofAddnewDocs.isHidden = true
                //            }
                //            else{
                sectionTitle.btnofAddnewDocs.isHidden = false
                //            }
                sectionTitle.btnofAddnewDocs.addTarget(self, action: #selector(addnewMedicalProofClicked(_:)), for: .touchUpInside)
            }
            else{
                sectionTitle.lblofTitle.text = arrofTitles[1]
                
                sectionTitle.btnofAddnewDocs.tag = 1
                //            if arrofEducationProofs.count == 3 {
                //                sectionTitle.btnofAddnewDocs.isHidden = true
                //            }
                //            else{
                sectionTitle.btnofAddnewDocs.isHidden = false
                //            }
                sectionTitle.btnofAddnewDocs.addTarget(self, action: #selector(addnewEducationProofClicked(_:)), for: .touchUpInside)
                
            }
            
            return sectionTitle
            
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrofTitles.count + 1
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight: CGFloat = 45
        if scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
        }
        else if scrollView.contentOffset.y >= sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0)
        }
        
    }
    
    
    
    
}





