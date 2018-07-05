//
//  SearchFilterViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

typealias SearchClinincResponse = (_ dictofResponse : NSDictionary) -> Void

class SearchFilterViewController: UIViewController,ErrorProtocalDelegate  {
    
    @IBOutlet weak var searchFilterTableView : UITableView!
    @IBOutlet weak var searchbar : UISearchBar!
    
    
    var arrofClinics : NSMutableArray!
    
    @IBOutlet var viewofNoClinincs : UIView!
    
    var searchClinincName : String! = ""
    let searchApiQueue = DispatchGroup()
    var isSearching : Bool = false
    var total :  NSInteger = 0
    var currentpage : NSInteger = 0
    var isRequestisGoingon : Bool = false
    
    var timerObj : Timer!
    var isRequestisgoing : Bool = false
    var isError : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrofClinics = NSMutableArray.init()
        viewofNoClinincs.isHidden = true
        
        
        let attributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.font : Constatns.LatoRegular(14)
        ]
        
        searchbar.setValue(NSLocalizedString("Cancel", comment: ""), forKey:"_cancelButtonText")
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        searchClinincName = ""
        callforClinicSearch(true) { (responseObj) in
            // print(responseObj)
            self.isRequestisgoing = false
            self.arrofClinics.removeAllObjects()
            let arrofClinincsres = responseObj.object(forKey: SearchClinics.APIResponse.data) as! NSArray
            if arrofClinincsres.count > 0  {
                
                //  if arrofClinincsres.count > 0 && self.isSearching == true {
                self.arrofClinics.addObjects(from: arrofClinincsres as! [Any])
                self.viewofNoClinincs.isHidden = true
                self.searchFilterTableView.isHidden = false
                self.searchFilterTableView.reloadData()
            }else{
                self.viewofNoClinincs.isHidden = false
                self.searchFilterTableView.isHidden = true
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    @IBAction func backBtnAction(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func callforRemainingPages(){
        
      //  APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      SearchClinics.APIRequest.clinicSearchKey : searchClinincName,
                                      SearchClinics.APIRequest.page : "\(currentpage)"]
        
        isRequestisGoingon = true
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.searchClinics, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            
            APIServices.SharedInstance.hideProgress()
            
            //   print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            self.isRequestisGoingon = false
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                let arrofClinincsres = dictofResonse.object(forKey: SearchClinics.APIResponse.data) as! NSArray
                self.arrofClinics.addObjects(from: arrofClinincsres as! [Any])
                
                self.searchFilterTableView.reloadData()
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
                
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        if self.isError == ""{
            
        }
        
    }
    
    
    func saveSearchClinicInCoredata(dict : NSDictionary) {
        
     let arrofClinincs = dict.object(forKey: SearchClinics.APIResponse.data) as! NSArray
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        
        for item in arrofClinincs {
            //            let newUser = NSEntityDescription.entity(forEntityName: clinicsCoreDataList.EntityName.ClinicList, in: context)!
            //            let object = NSManagedObject(entity: newUser, insertInto: context)
            //            let hospitalName = (item as AnyObject).value(forKey: CliniListbyDocref.APIResponse.hospitalName)
            //            let hospitalBranchName = (item as AnyObject).value(forKey: CliniListbyDocref.APIResponse.hospitalBranchName)
            //            let hospitalPhone = (item as AnyObject).value(forKey: CliniListbyDocref.APIResponse.hospitalHelpLinePhone)
            //
            
            
//            object.setValue(hospitalName, forKey: clinicsCoreDataList.Attributes.hospitalName)
//            object.setValue(hospitalBranchName, forKey: clinicsCoreDataList.Attributes.hospitalBranchName)
//            object.setValue(hospitalPhone, forKey: clinicsCoreDataList.Attributes.hospitalHelpLinePhone)
            
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
            
            
        }
        
    }
    
    
    func callforClinicSearch(_ toShowLoader : Bool, success : @escaping SearchClinincResponse) {
        if toShowLoader {
          //  APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
             self.showLoader()
        }
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      SearchClinics.APIRequest.clinicSearchKey : searchClinincName,
                                      SearchClinics.APIRequest.page : "0",
                                      SearchClinics.APIRequest.mobilePrefix : UserDefaultStore.mobilePrefix!]
        
        print(param)
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.searchClinics, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            if toShowLoader {
                APIServices.SharedInstance.hideProgress()
            }
            // print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                if dictofResonse.object(forKey: SearchClinics.APIResponse.totalRecords) != nil && String(describing:dictofResonse.object(forKey: SearchClinics.APIResponse.totalRecords)!) != "<null>" {
                    
                    let strofTotleRecords = String(describing:dictofResonse.TabiibDocObjectForKey(forKey: SearchClinics.APIResponse.totalRecords))
                    
                    self.total = Int(strofTotleRecords)!
                    
                    self.saveSearchClinicInCoredata(dict: dictofResonse)
                }
                
                success(dictofResonse)
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
                
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    @objc func toCallSearchApiQueue() {
        
        //        var serverEror : NSError?
        
        searchApiQueue.enter()
        isRequestisgoing = true
        callforClinicSearch(false) { (responseObj) in
            // print(responseObj)
            self.isRequestisgoing = false
            self.arrofClinics.removeAllObjects()
            let arrofClinincsres = responseObj.object(forKey: SearchClinics.APIResponse.data) as! NSArray
            if arrofClinincsres.count > 0  {
                
                //  if arrofClinincsres.count > 0 && self.isSearching == true {
                self.arrofClinics.addObjects(from: arrofClinincsres as! [Any])
                self.viewofNoClinincs.isHidden = true
                self.searchFilterTableView.isHidden = false
                self.searchFilterTableView.reloadData()
            }else{
                self.viewofNoClinincs.isHidden = false
                self.searchFilterTableView.isHidden = true
            }
            
            self.searchApiQueue.leave()
        }
        
        searchApiQueue.notify(queue: .main) {
        }
        
    }
    
    
  
    
    
    func callforClinicBasicInformation(clinincDetails : NSDictionary) {
        
        
    //    APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        let strHospiRef = String(describing:clinincDetails.TabiibDocObjectForKey(forKey: SearchClinics.APIResponse.hospRef))
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      getClinicinfo.APIRequest.hospRef : strHospiRef]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.getClinicinfo, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //    print(response)
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                let clinincAddingVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "ClinicAddingViewController") as! ClinicAddingViewController
                clinincAddingVc.isFromExisting = true
                
                let dataofClininc = dictofResonse.object(forKey: getClinicinfo.APIResponse.data) as! NSArray
                
                clinincAddingVc.dicotfClinincTimings = dataofClininc[0] as! NSDictionary
                clinincAddingVc.isFromSearchclininc = true
                
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
                
                if messag == NetworkErrorIssue{
                    OopsVC.errorType = NetworkError
                }
                self.present(OopsVC, animated: true, completion: nil)
            }
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

extension SearchFilterViewController : UISearchBarDelegate

{
    
    //MARK: - - -  Searchbar Delegate and Datasource methods
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchClinincName = ""
        isSearching = false
        searchBar.resignFirstResponder()
        arrofClinics.removeAllObjects()
        
        searchClinincName = ""
        callforClinicSearch(true) { (responseObj) in
            // print(responseObj)
            self.isRequestisgoing = false
            self.arrofClinics.removeAllObjects()
            let arrofClinincsres = responseObj.object(forKey: SearchClinics.APIResponse.data) as! NSArray
            if arrofClinincsres.count > 0  {
                
                //  if arrofClinincsres.count > 0 && self.isSearching == true {
                self.arrofClinics.addObjects(from: arrofClinincsres as! [Any])
                self.viewofNoClinincs.isHidden = true
                self.searchFilterTableView.isHidden = false
                self.searchFilterTableView.reloadData()
            }else{
                self.viewofNoClinincs.isHidden = false
                self.searchFilterTableView.isHidden = true
            }
            
        }
        //        self.viewofNoClinincs.isHidden = false
        //        self.searchFilterTableView.isHidden = true
    }
    
    //    @objc func loadSearchData(_ searchtext : String) {
    //        self.searchBar(searchbar, textDidChange: searchtext)
    //    }
    //
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            isSearching = false
            //            strSearchedText = ""
            let newString = ""
            //loaad default events
            self.viewofNoClinincs.isHidden = false
            self.searchFilterTableView.isHidden = true
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(toCallSearchApiQueue), object: newString)
            searchClinincName = newString
            APIServices.SharedInstance.invalidatePreviousRequest()
            if self.timerObj != nil {
                self.timerObj.invalidate()
            }
            
            
        }else{
            
            isSearching = true
            let newString = searchText
            
            
            //            self.timerObj = Timer.scheduledTimer(withTimeInterval: 2, repeats: falsei, block: { (timerobj) in
            //                self.timerObj.invalidate()
            //                if self.isRequestisgoing == false {
            
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(toCallSearchApiQueue), object: newString)
            
            searchClinincName = newString
            
            self.timerObj = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timerobj) in
                self.timerObj.invalidate()
                self.toCallSearchApiQueue()
                
            })
            
            // self.perform(#selector(loadSearchData(_:)), with: loadSearchData, afterDelay: 0.5)
            
            
            //call for search api
            //       self.toCallSearchApiQueue()
            
            //                }
            //            })
            
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.resignFirstResponder()
    }
    
    
    
    
}


extension SearchFilterViewController : UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrofClinics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Clininiccell = tableView.dequeueReusableCell(withIdentifier: "ListOfClinicTableViewCell", for: indexPath) as! ListOfClinicTableViewCell
        
        let dictofClininc = arrofClinics[indexPath.row] as! NSDictionary
        Clininiccell.lblOfClinicName.text = String(describing:dictofClininc.TabiibDocObjectForKey(forKey: SearchClinics.APIResponse.hospitalName))
        
        let strofBranch = String(describing:dictofClininc.TabiibDocObjectForKey(forKey: SearchClinics.APIResponse.hospitalBranchName))
        
        let strofMobileNumber = String(describing:dictofClininc.TabiibDocObjectForKey(forKey: SearchClinics.APIResponse.hospitalPhone))
        
        var finalString : String! = ""
        
        if strofBranch == "" {
            finalString = strofMobileNumber
        }else{
            if strofMobileNumber == "" {
                finalString = strofBranch
            }else{
                finalString = strofBranch + " | " + strofMobileNumber
            }
        }
        
        Clininiccell.lblOfClinicMobileNumber.text = finalString
        Clininiccell.selectionStyle = .none
        return Clininiccell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        self.timerObj.invalidate()
        isRequestisgoing = true
        let dictofClininc = arrofClinics[indexPath.row] as! NSDictionary
        self.callforClinicBasicInformation(clinincDetails: dictofClininc)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if arrofClinics.count < total {
                if isRequestisGoingon == false {
                    currentpage += 1
                    callforRemainingPages()
                }
            }
        }
        
    }
    
}


