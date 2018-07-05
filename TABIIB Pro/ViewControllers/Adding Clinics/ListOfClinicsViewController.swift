//
//  ListOfClinicsViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import CoreData

class ListOfClinicsViewController: CommonViewController,ErrorProtocalDelegate {
  
    @IBOutlet weak var listOfClinicTableView : UITableView!
    @IBOutlet weak var viewOfAddClinic : UIView!
    
    var noofPages : Int! = 0
    var totalNoofEvents : Int! = 0
    var arrofClinics : NSMutableArray!
    var isRequestgoing : Bool = false
    var resultClinics = [Any]()
    var totalRecords : Int! = 0
 
    
    
    @IBOutlet var btnNewClininc : UIButton!
    
    @IBOutlet var viewOfNoClinics : UIView!
    
    var singObj : SingleTonClass!
    var isError : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singObj = SingleTonClass.SharedInstance
        singObj.singIdentifier = "ListOfClinicsViewController"
        
        viewOfAddClinic.layer.cornerRadius = viewOfAddClinic.frame.width/2
        viewOfAddClinic.layer.masksToBounds = true
        viewOfAddClinic.clipsToBounds = true
        
        arrofClinics = NSMutableArray.init()
        
        
        btnNewClininc.isHidden = false
        
        //getListofClinics()

//        fetchData()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        // if self.isFromNetworkInstance == true{
        self.arrofClinics.removeAllObjects()
        //self.isFromNetworkInstance = false
        
        noofPages = 0
        getListofClinics()
        // }
        if Connectivity.isCheckForNewwork() == false {
      
            fetchData()
        }
        
    }
    
    
    func saveClinicsInCoredata(arrodClinincsData : NSArray) {
        
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
        let newUser = NSEntityDescription.entity(forEntityName: clinicsCoreDataList.EntityName.ClinicList, in: context)!
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:clinicsCoreDataList.EntityName.ClinicList)
        
        for i in 0 ..< arrodClinincsData.count {
            
            let dic = arrodClinincsData[i] as! NSDictionary
            
            if let phoneNumber = dic.value(forKey: CliniListbyDocref.APIResponse.hospitalHelpLinePhone) {
                
                //  fetchRequest.predicate = NSPredicate(format: "hospitalHelpLinePhone = %@", dic.value(forKey: CliniListbyDocref.APIResponse.hospitalHelpLinePhone) as! CVarArg)
                let predicate = NSPredicate(format: "hospitalHelpLinePhone = %@", phoneNumber as! CVarArg)
                fetchRequest.predicate = predicate
                
                do {
                    let list = try context.fetch(fetchRequest) as? [ClinicList]
                    if list!.count == 0 {
                        
                
                        let object = NSManagedObject(entity: newUser, insertInto: context)
                        
                        let hospitalName = dic.value(forKey: CliniListbyDocref.APIResponse.hospitalName)
                        let hospitalBranchName = dic.value(forKey: CliniListbyDocref.APIResponse.hospitalBranchName)
                        let hospitalPhone = dic.value(forKey: CliniListbyDocref.APIResponse.hospitalHelpLinePhone)
                        
                        object.setValue(hospitalName, forKey: clinicsCoreDataList.Attributes.hospitalName)
                        object.setValue(hospitalBranchName, forKey: clinicsCoreDataList.Attributes.hospitalBranchName)
                        object.setValue(hospitalPhone, forKey: clinicsCoreDataList.Attributes.hospitalHelpLinePhone)
                        
                        do {
                            try context.save()
                        } catch {
                            print("Failed saving")
                        }
                        
                        print("save %@","\(i)")
                    }else{
                        print("update %@","\(i)")
                        //  print("update %@")
                        let object = list![0]
                        let hospitalPhone = dic.value(forKey: CliniListbyDocref.APIResponse.hospitalHelpLinePhone)
                        object.setValue(hospitalPhone, forKey: clinicsCoreDataList.Attributes.hospitalHelpLinePhone)
                        do {
                            try context.save()
                        } catch {
                            print("Failed saving")
                        }
                        
                    }
                    
                    
                } catch let error as NSError {
                    // failure
                    print("Fetch failed: \(error.localizedDescription)")
                }
                
            }
            
        }
        
        
        
        
        
//        let dictofClininc = arr
//
//                //         if self.networkFunctionality == 1 {
//
//        let app = UIApplication.shared.delegate as! AppDelegate
//        let context = app.persistentContainer.viewContext
//
//
//        for item in dictofClininc {
//            let newUser = NSEntityDescription.entity(forEntityName: clinicsCoreDataList.EntityName.ClinicList, in: context)!
//            let object = NSManagedObject(entity: newUser, insertInto: context)
//
//            let hospitalName = (item as AnyObject).value(forKey: CliniListbyDocref.APIResponse.hospitalName)
//            let hospitalBranchName = (item as AnyObject).value(forKey: CliniListbyDocref.APIResponse.hospitalBranchName)
//            let hospitalPhone = (item as AnyObject).value(forKey: CliniListbyDocref.APIResponse.hospitalHelpLinePhone)
//
//            object.setValue(hospitalName, forKey: clinicsCoreDataList.Attributes.hospitalName)
//            object.setValue(hospitalBranchName, forKey: clinicsCoreDataList.Attributes.hospitalBranchName)
//            object.setValue(hospitalPhone, forKey: clinicsCoreDataList.Attributes.hospitalHelpLinePhone)
//
//            do {
//                try context.save()
//            } catch {
//                print("Failed saving")
//            }
//
//
//        }
   
    }
    
    func fetchData() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName:clinicsCoreDataList.EntityName.ClinicList, in: context)
        fetchRequest.entity = entityDescription
//        let predicate = NSPredicate(format: "hospitalName = %@" , self.resultClinics)
//        fetchRequest.predicate = predicate

        
        do {
            self.resultClinics = try context.fetch(fetchRequest) as [Any]
//            let predicate = NSPredicate(format: "hospitalName = %@", self.resultClinics)
//             self.fetchRequest.predicate = predicate
            print(self.resultClinics)
            
            
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
        print(self.resultClinics)
        for result in self.resultClinics {
//            var dict = (result as AnyObject).value(forKey: "hospitalName")
//            print(dict)
////            let predicate = NSPredicate(format: "hospitalName = %@", dict as! CVarArg)
////            fetchRequest.predicate = predicate
//            dict = (result as AnyObject).value(forKey: "hospitalBranchName")
//            print(dict)
//            dict = (result as AnyObject).value(forKey: "hospitalHelpLinePhone")
//            print(dict)
        }
        
        if self.resultClinics.count > 0 {
            self.listOfClinicTableView.reloadData()
        }else{
            
        }
 
    }
    
    
    
    func getListofClinics(){
        
        /*{"userRef":"QmalxZn4UQEWfSq6","ApiKey":"SKZHTiNhgR6G9TSl","page":"0"}*/
        
        
        self.showActivityIndicator()
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      CliniListbyDocref.APIRequest.page : String(noofPages)]
        
        isRequestgoing = true
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.cliniListbyDocref, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
         
            self.hideActivityIndicator()
            
            //  print(response)der
            
            self.isRequestgoing = false
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                
                if self.isError == "getlist" {
                    self.arrofClinics.removeAllObjects()
                }
                
                // self.arrofClinics.removeAllObjects()
                
                let strofTotleRecords = String(describing:dictofResonse.TabiibDocObjectForKey(forKey: CliniListbyDocref.APIResponse.totalRecords))
                
                self.totalNoofEvents = Int(strofTotleRecords)!
                
                let arrodClinincsData = dictofResonse.object(forKey: getDoctorAppointments.APIResponse.data) as! NSArray
                
                
                if self.arrofClinics.count == 0{
                    self.arrofClinics.addObjects(from: arrodClinincsData as! [Any])
                }else{
                    self.arrofClinics.addObjects(from: arrodClinincsData as! [Any])
                }
                
                if self.arrofClinics.count > 0{
                    self.listOfClinicTableView.reloadData()
                }else{
                   
                }
                
               self.saveClinicsInCoredata(arrodClinincsData: arrodClinincsData)

             }
            else{
                
                let serv = NSLocalizedString("Error from Server", comment: "")
                
                Utilities.sharedInstace.showAlertviewWithMessage(serv)
            }
            
            
        }) { (networkErr, messag) in
            
            self.isFromNetworkInstance = true
            self.hideActivityIndicator()
            
//            if messag == unauthorised {
//
//                let unauth = NSLocalizedString("UnAuthorisedUser", comment: "")
//
//                let objofSweetAlrt = SweetAlerts()
//                objofSweetAlrt.isTapGestureReg = false
//
//                _ =  objofSweetAlrt.showAlert(unauth, style: .none, buttonTitle: NSLocalizedString("Okay", comment : ""), action: { (okay) in
//                    objofSweetAlrt.isTapGestureReg = false
//
//                    let loginVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                    UserDefaultStore.isLogined = "0"
//                    self.navigationController?.pushViewController(loginVC, animated: true)
//                })
//            }else{
//
//                let OopsVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
//
//                OopsVC.errorDelegate = self
//                self.isError = "getlist"
//
//                if messag == NetworkErrorIssue{
//                    OopsVC.errorType = NetworkError
//                }
//
//                self.present(OopsVC, animated: true, completion: nil)
//            }
        }
    }
    
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        noofPages = 0
        getListofClinics()
        
        
    }
    
    
    @IBAction func backBtnAction(_ sender : Any){
        //         self.backBtnAction()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func addClinicBtnAction(_ sender : Any){
        
        let addClinicVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "AddClinicsViewController") as! AddClinicsViewController
        
        self.navigationController?.pushViewController(addClinicVC, animated: true)
        
        
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
extension ListOfClinicsViewController : UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Connectivity.isCheckForNewwork() == true {
            return arrofClinics.count
        } else {
            return resultClinics.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 145.0
        }
        else if UIDevice.current.userInterfaceIdiom == .pad {
            return 180.0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfClinicTableViewCell", for: indexPath) as! ListOfClinicTableViewCell
        
        if Connectivity.isCheckForNewwork() == true {
            
        let dictofClininc = arrofClinics[indexPath.row] as! NSDictionary
        
        cell.lblOfClinicName.text = String(describing:dictofClininc.TabiibDocObjectForKey(forKey: CliniListbyDocref.APIResponse.hospitalName))
        
        cell.lblOfClinicMobileNumber.text = String(describing:dictofClininc.TabiibDocObjectForKey(forKey: CliniListbyDocref.APIResponse.hospitalBranchName)) + " - " + String(describing:dictofClininc.TabiibDocObjectForKey(forKey: CliniListbyDocref.APIResponse.hospitalHelpLinePhone))
        
        if String(describing:dictofClininc.TabiibDocObjectForKey(forKey: CliniListbyDocref.APIResponse.morningStatus)) == "1" {
            cell.imgOfClinicAccept.image = UIImage.init(named: "Done")
        }
        else{
            cell.imgOfClinicAccept.image = UIImage.init(named: "Done")
            
        }
        }
        else if Connectivity.isCheckForNewwork() == false {
     
            let data = self.resultClinics[indexPath.row]
            cell.lblOfClinicName.text = (data as AnyObject).value(forKey: CliniListbyDocref.APIResponse.hospitalName) as? String
            cell.lblOfClinicMobileNumber.text = ((data as AnyObject).value(forKey: CliniListbyDocref.APIResponse.hospitalBranchName) as? String)! + " - " + ((data as AnyObject).value(forKey: CliniListbyDocref.APIResponse.hospitalHelpLinePhone) as? String)!
           //   }
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if isRequestgoing == false {
                if arrofClinics.count < totalNoofEvents {
                    noofPages = noofPages + 1
                    getListofClinics()
                }
            }
//            if networkFunctionality == 1 {
//                if resultClinics.count > totalRecords {
//                    noofPages = noofPages + 1
//                    fetchData()
//                }
//            }
        }
        
    }
    
    
    func callforClinicBasicInformation2(clinincDetails : NSDictionary) {
        
     //   APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        let strHospiRef = String(describing:clinincDetails.TabiibDocObjectForKey(forKey: SearchClinics.APIResponse.hospRef))
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      getClinicinfo.APIRequest.hospRef : strHospiRef]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.getClinicinfo, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //   print(response)
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                let clinincAddingVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "ClinicAddingViewController") as! ClinicAddingViewController
                clinincAddingVc.isFromExisting = true
                
                let dataofClininc = dictofResonse.object(forKey: getClinicinfo.APIResponse.data) as! NSArray
                
                clinincAddingVc.dicotfClinincTimings = dataofClininc[0] as! NSDictionary
                
                self.navigationController?.pushViewController(clinincAddingVc, animated: true)
                
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
                self.isError = "listclinics"
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        isRequestgoing = true
        let dictofClininc = arrofClinics[indexPath.row] as! NSDictionary
        self.callforClinicBasicInformation2(clinincDetails: dictofClininc)
        
    }
    
    
}

