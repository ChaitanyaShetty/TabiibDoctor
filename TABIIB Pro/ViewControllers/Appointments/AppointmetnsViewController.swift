//
//  AppointmetnsViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import CoreData

typealias SearchAppointmentsResponse = (_ dictofResponse : NSDictionary) -> Void


class AppointmetnsViewController: CommonViewController,ErrorProtocalDelegate  {
    
    @IBOutlet var searchAppointment: UISearchBar!
    
    
    
    @IBOutlet var viewofUpcomingAppointments: UIView!
    @IBOutlet var viewofRequestedAppointmetns: UIView!
    @IBOutlet var viewofCompletedAppointmetns: UIView!
    @IBOutlet var viewofCanceledAppointmetns: UIView!
    
    @IBOutlet weak var AppointmentCollect : UICollectionView!
    
    var requestedAppointDetailsVc  : RequestedAppointmentsViewController!
    var upcomingAppointDetailsVc : UpcomingAppointmetnsViewController!
    var completedAppointDetailsVc : CompletedAppointmentsViewController!
    var canceledAppointDetailsVc : CancelledAppointmetnsViewController!
    
    let RequestedType = "Requested"
    let UpcomingType = "Upcoming"
    let CompletedType = "Completed"
    let CancelledType = "Cancelled"
    
    var strofSelectedType : String!
    var uniqueId : NSArray!
    
    var dictofCoreDataRequestedResponse : NSDictionary!
    var dictofCoreDataUpcomingResponse : NSDictionary!
    var dictofCoreDataCompletedResponse : NSDictionary!
    var dictofCoreDataCanceledResponse : NSDictionary!
    
    var searchAppointName : String! = ""
    let searchApiQueue = DispatchGroup()
    var isSearching : Bool = false
    
    var total :  NSInteger = 0
    var currentpage : NSInteger = 0
    var isRequestisGoingon : Bool = false
    
    
    var timerObj : Timer!
    var isRequestisgoing : Bool = false
    
    var arrOfCollection : [String]!
    var selectedIndex : Int = 0
    
    var singObj : SingleTonClass!
    
    
    let UpComingTit = NSLocalizedString("UpComing", comment: "")
    let CompletedTit = NSLocalizedString("Completed", comment: "")
    let CanceledTit = NSLocalizedString("Canceled", comment: "")
    let RequestedTit = NSLocalizedString("Requested", comment: "")
    
    var isError : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let attributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.font : Constatns.LatoRegular(14)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        searchAppointment.setValue(NSLocalizedString("Cancel", comment: ""), forKey:"_cancelButtonText")
        
        
        singObj = SingleTonClass.SharedInstance
        singObj.singIdentifier = "AppointmetnsViewController"
        
        arrOfCollection = [String]()
        
        
        
        
        if UserDefaultStore.isAutoConfirmAppointment == "1"{
            arrOfCollection = [UpComingTit,CompletedTit,CanceledTit]
        }else{
            arrOfCollection = [RequestedTit,UpComingTit,CompletedTit,CanceledTit]
        }
        
        strofSelectedType = Requested
        selectedIndex(0)
        
//        if Connectivity.isCheckForNewwork() == false {
//            fetchData()
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    func selectionOptions(_ index : Int,_ dictofResponse : NSDictionary){
        
        switch index {
            
        case 0:
            if self.isIndicatorisvisible {
                self.hideActivityIndicator()
            }
            UIView.animate(withDuration: 0.5) {
                
                self.viewofRequestedAppointmetns.frame = CGRect(x: -self.viewofRequestedAppointmetns.frame.width, y: self.viewofRequestedAppointmetns.frame.origin.y, width: self.viewofRequestedAppointmetns.frame.width, height: self.viewofRequestedAppointmetns.frame.height)
                self.viewofRequestedAppointmetns.frame = CGRect(x: 0, y: self.viewofRequestedAppointmetns.frame.origin.y, width: self.viewofRequestedAppointmetns.frame.width, height: self.viewofRequestedAppointmetns.frame.height)
                //(-414.0, 186.0, 414.0, 550.0)//(0.0, 186.0, 414.0, 550.0)
            }
            
            //default in personal
            viewofRequestedAppointmetns.isHidden = false
            viewofUpcomingAppointments.isHidden = true
            viewofCompletedAppointmetns.isHidden = true
            viewofCanceledAppointmetns.isHidden = true
            
            
            
            break
            
        case 1:
            if self.isIndicatorisvisible {
                self.hideActivityIndicator()
            }
            UIView.animate(withDuration: 0.5) {
                
                self.viewofUpcomingAppointments.frame = CGRect(x: self.viewofUpcomingAppointments.frame.width, y: self.viewofUpcomingAppointments.frame.origin.y, width: self.viewofUpcomingAppointments.frame.width, height: self.viewofUpcomingAppointments.frame.height)
                self.viewofUpcomingAppointments.frame = CGRect(x: 0, y: self.viewofUpcomingAppointments.frame.origin.y, width: self.viewofUpcomingAppointments.frame.width, height: self.viewofUpcomingAppointments.frame.height)
                
            }
            
            //default in personal
            viewofRequestedAppointmetns.isHidden = true
            viewofUpcomingAppointments.isHidden = false
            viewofCompletedAppointmetns.isHidden = true
            viewofCanceledAppointmetns.isHidden = true
            
            
            
            break
            
        case 2:
            if self.isIndicatorisvisible {
                self.hideActivityIndicator()
            }
            UIView.animate(withDuration: 0.5) {
                
                self.viewofCompletedAppointmetns.frame = CGRect(x: self.viewofCompletedAppointmetns.frame.width, y: self.viewofCompletedAppointmetns.frame.origin.y, width: self.viewofCompletedAppointmetns.frame.width, height: self.viewofCompletedAppointmetns.frame.height)
                self.viewofCompletedAppointmetns.frame = CGRect(x: 0, y: self.viewofCompletedAppointmetns.frame.origin.y, width: self.viewofCompletedAppointmetns.frame.width, height: self.viewofCompletedAppointmetns.frame.height)
                
            }
            
            //default in personal
            viewofRequestedAppointmetns.isHidden = true
            viewofUpcomingAppointments.isHidden = true
            viewofCompletedAppointmetns.isHidden = false
            viewofCanceledAppointmetns.isHidden = true
            
            
            
            break
            
        case 3 :
            if self.isIndicatorisvisible {
                self.hideActivityIndicator()
            }
            
            UIView.animate(withDuration: 0.5) {
                
                self.viewofCanceledAppointmetns.frame = CGRect(x: self.viewofCanceledAppointmetns.frame.width, y: self.viewofCanceledAppointmetns.frame.origin.y, width: self.viewofCanceledAppointmetns.frame.width, height: self.viewofCanceledAppointmetns.frame.height)
                self.viewofCanceledAppointmetns.frame = CGRect(x: 0, y: self.viewofCanceledAppointmetns.frame.origin.y, width: self.viewofCanceledAppointmetns.frame.width, height: self.viewofCanceledAppointmetns.frame.height)
                
            }
            
            //default in personal
            viewofRequestedAppointmetns.isHidden = true
            viewofUpcomingAppointments.isHidden = true
            viewofCompletedAppointmetns.isHidden = true
            viewofCanceledAppointmetns.isHidden = false
            
            
            
            break
            
            
            
        default:
            
            break
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        
        //        self.backBtnAction()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddnewAppointmentClicked(_ sender: Any) {
        
        
        
        
    }
    
    //    @IBAction func btnCancelledClicked(_ sender: Any) {
    //        strofSelectedType = Cancelled
    //       CallforAppointmentAPIReqiest(Cancelled)
    //    }
    //
    //    @IBAction func btnCompletedClicked(_ sender: Any) {
    //        strofSelectedType = Completed
    //        CallforAppointmentAPIReqiest(Completed)
    //    }
    //
    //    @IBAction func btnUpcomingClicked(_ sender: Any) {
    //        strofSelectedType = Upcoming
    //        CallforAppointmentAPIReqiest(Upcoming)
    //    }
    //
    //    @IBAction func btnRequestedClicked(_ sender: Any) {
    //        strofSelectedType = Requested
    //        CallforAppointmentAPIReqiest(Requested)
    //    }
    //
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "RequestedAppointmentsViewController") {
            self.requestedAppointDetailsVc = segue.destination as! RequestedAppointmentsViewController
            self.requestedAppointDetailsVc.delegate = self
        }
        else if(segue.identifier == "UpcomingAppointmetnsViewController"){
            self.upcomingAppointDetailsVc = segue.destination as! UpcomingAppointmetnsViewController
            self.upcomingAppointDetailsVc.delegate = self
        }
        else if(segue.identifier == "CompletedAppointmentsViewController") {
            self.completedAppointDetailsVc = segue.destination as! CompletedAppointmentsViewController
            self.completedAppointDetailsVc.delegate = self
        }
        else if(segue.identifier == "CancelledAppointmetnsViewController") {
            self.canceledAppointDetailsVc = segue.destination as! CancelledAppointmetnsViewController
            self.canceledAppointDetailsVc.delegate = self
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

extension AppointmetnsViewController : UISearchBarDelegate

{
    
    
    @objc func toCallSearchAppointQueue() {
        
        searchApiQueue.enter()
        isRequestisgoing =  true
        
        var apiRequestMethode : String!
        
        if strofSelectedType == RequestedType {
            apiRequestMethode = APIMethods.getDocReqestedBooking
        }
        else if strofSelectedType == UpcomingType {
            apiRequestMethode = APIMethods.getDocUpcomingBooking
        }
        else if strofSelectedType == CompletedType {
            apiRequestMethode = APIMethods.getDocPastBooking
        }
        else if strofSelectedType == CancelledType {
            apiRequestMethode = APIMethods.getDocDeclinedBooking
        }
        
        
        callforAppoinments(false, apiRequestMethode, 0, searchAppointName) { (dictofResonse) in
            
            if self.isIndicatorisvisible {
                self.hideActivityIndicator()
            }
            
            if self.strofSelectedType ==  self.RequestedType {
                self.selectionOptions(0, dictofResonse)
                self.requestedAppointDetailsVc.dictofApiResponse = dictofResonse
                self.requestedAppointDetailsVc.reloadAppointmentss()
                
            }
            else if self.strofSelectedType == self.UpcomingType {
                self.selectionOptions(1, dictofResonse)
                self.upcomingAppointDetailsVc.dictofApiResponse = dictofResonse
                self.upcomingAppointDetailsVc.reloadAppointmentss()
                
            }
            else if self.strofSelectedType == self.CompletedType {
                self.selectionOptions(2, dictofResonse)
                self.completedAppointDetailsVc.dictofApiResponse = dictofResonse
                self.completedAppointDetailsVc.reloadAppointmentss()
                
            }
            else if self.strofSelectedType == self.CancelledType {
                self.selectionOptions(3, dictofResonse)
                self.canceledAppointDetailsVc.dictofApiResponse = dictofResonse
                self.canceledAppointDetailsVc.reloadAppointmentss()
                
            }
            
            self.isRequestisgoing = false
            
        }
        
        
    }
    
    
    
    //MARK: - - -  Searchbar Delegate and Datasource methods
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchAppointName = ""
        isSearching = false
        self.hideActivityIndicator()
        APIServices.SharedInstance.invalidatePreviousRequest()
        searchBar.resignFirstResponder()
        self.toCallSearchAppointQueue()
        //
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
            searchAppointName = ""
            self.hideActivityIndicator()
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.toCallSearchAppointQueue), object: "")
            APIServices.SharedInstance.invalidatePreviousRequest()
            self.toCallSearchAppointQueue()
            
            //            APIServices.SharedInstance.invalidatePreviousRequest()
            //
            //            self.toCallSearchAppointQueue()
            //            strSearchedText = ""
            //loaad default events
            //            self.viewofNoClinincs.isHidden = false
            //            self.searchFilterTableView.isHidden = true
            //
            if self.timerObj != nil {
                self.timerObj.invalidate()
            }
            
        }else{
            
            isSearching = true
            let newString = searchText
            
            if self.isRequestisgoing == false {
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(toCallSearchAppointQueue), object: newString)
                
                self.searchAppointName = newString
                
                self.timerObj = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timerobj) in
                    self.timerObj.invalidate()
                    self.hideActivityIndicator()
                    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.toCallSearchAppointQueue), object: "")
                    APIServices.SharedInstance.invalidatePreviousRequest()
                    self.toCallSearchAppointQueue()
                    
                })
                
                //            }
                //            self.timerObj = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timerobj) in
                //                            self.timerObj.invalidate()
                //
                //        if self.isRequestisgoing == false {
                //
                //            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.toCallSearchAppointQueue), object: newString)
                ////
                //            self.searchAppointName = newString
                ////
                //            self.timerObj = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timerobj) in
                //                self.timerObj.invalidate()
                //                self.toCallSearchAppointQueue()
                ////
                //            })
                
                // self.perform(#selector(loadSearchData(_:)), with: loadSearchData, afterDelay: 0.5)
                
                
                //call for search api
                //       self.toCallSearchApiQueue()
                
            }
            //                        })
            
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

extension AppointmetnsViewController : CancelledAppointLoadmoreDelegate
{
    
    func loadMoreCancelAppoiDelegate() {
        if isRequestisGoingon == false {
            currentpage = currentpage + 1
            
            if Connectivity.isCheckForNewwork() == false {
//                let arrofResponse = dictofCoreDataCanceledResponse.object(forKey: getDoctorAppointments.APIResponse.data) as! NSArray
//                self.canceledAppointDetailsVc.loadRemainingMore(arrofResponse)
            } else {
            
            callforAppoinments(true, APIMethods.getDocDeclinedBooking, currentpage,"") { (dictofApiResponse) in
                
                let arrofResponse = dictofApiResponse.object(forKey: getDoctorAppointments.APIResponse.data) as! NSArray
                self.canceledAppointDetailsVc.loadRemainingMore(arrofResponse)
                
            }
            }
        }
    }
    
    func reloadcanceldAllAppointmetns() {
        
        APIServices.SharedInstance.invalidatePreviousRequest()
        
        currentpage = 0
        
        if Connectivity.isCheckForNewwork() == false {
//            self.canceledAppointDetailsVc.dictofApiResponse = dictofCoreDataCanceledResponse
//            self.canceledAppointDetailsVc.reloadAppointmentss()
            
        } else {
            
        callforAppoinments(true, APIMethods.getDocDeclinedBooking, currentpage,"") { (dictofApiResponse) in
            
            self.canceledAppointDetailsVc.dictofApiResponse = dictofApiResponse
            self.canceledAppointDetailsVc.reloadAppointmentss()
            
        }
        }
    }
}

extension AppointmetnsViewController : CompleteAppointLoadmoreDelegate {
    
    func loadMoreCompleAppoiDelegate() {
        if isRequestisGoingon == false {
            currentpage = currentpage + 1
            
             if Connectivity.isCheckForNewwork() == false {
                
//                let arrofResponse = dictofCoreDataCompletedResponse.object(forKey: getDoctorAppointments.APIResponse.data) as! NSArray
//                self.completedAppointDetailsVc.loadRemainingMore(arrofResponse)
                
             } else {
            
            callforAppoinments(true, APIMethods.getDocPastBooking, currentpage,"") { (dictofApiResponse) in
                
                let arrofResponse = dictofApiResponse.object(forKey: getDoctorAppointments.APIResponse.data) as! NSArray
                self.completedAppointDetailsVc.loadRemainingMore(arrofResponse)
                
            }
                
            }
        }
        
    }
    
    func reloadcompletedAppointmetns() {
        
        APIServices.SharedInstance.invalidatePreviousRequest()
        
        currentpage = 0
         if Connectivity.isCheckForNewwork() == false {
            
//            self.completedAppointDetailsVc.dictofApiResponse = dictofCoreDataCompletedResponse
//            self.completedAppointDetailsVc.reloadAppointmentss()
            
         } else {
            
        callforAppoinments(true, APIMethods.getDocPastBooking, currentpage,"") { (dictofApiResponse) in
            
            
            self.completedAppointDetailsVc.dictofApiResponse = dictofApiResponse
            self.completedAppointDetailsVc.reloadAppointmentss()
            
        }
            
        }
    }
}

extension AppointmetnsViewController : UpcomingAppointmentDelegate {
    
    func loadMoreUpcomingAppointDelegate() {
        if isRequestisGoingon == false {
            currentpage = currentpage + 1
            
              if Connectivity.isCheckForNewwork() == false {
                
//                let arrofResponse = dictofCoreDataUpcomingResponse.object(forKey: getDoctorAppointments.APIResponse.data) as! NSArray
//                self.upcomingAppointDetailsVc.loadRemainingMore(arrofResponse)
//                self.upcomingAppointDetailsVc.reloadCoreDataObjects()
                
              } else {
            
            callforAppoinments(true, APIMethods.getDocUpcomingBooking, currentpage,"") { (dictofApiResponse) in
                
                let arrofResponse = dictofApiResponse.object(forKey: getDoctorAppointments.APIResponse.data) as! NSArray
                self.upcomingAppointDetailsVc.loadRemainingMore(arrofResponse)
                
            }
                
            }
        }
    }
    
    func reloadupcomingAllAppointmetns() {
        
        APIServices.SharedInstance.invalidatePreviousRequest()
        
        currentpage = 0
        
         if Connectivity.isCheckForNewwork() == false {
            
//            self.upcomingAppointDetailsVc.dictofApiResponse = dictofCoreDataUpcomingResponse
//            self.upcomingAppointDetailsVc.reloadAppointmentss()
            
         } else {
        
        callforAppoinments(true, APIMethods.getDocUpcomingBooking, currentpage,"") { (dictofApiResponse) in
            
            self.upcomingAppointDetailsVc.dictofApiResponse = dictofApiResponse
            self.upcomingAppointDetailsVc.reloadAppointmentss()
            
        }
            
        }
    }
}

extension AppointmetnsViewController : RequestAppointLoadmoreDelegate {
    
    func loadMoreReqAppoiDelegate() {
        if isRequestisGoingon == false {
            currentpage = currentpage + 1
            
            if Connectivity.isCheckForNewwork() == false {
                
//                let arrofResponse = dictofCoreDataRequestedResponse.object(forKey: getDoctorAppointments.APIResponse.data) as! NSArray
//                self.requestedAppointDetailsVc.loadRemainingMore(arrofResponse)
                
            } else {
            
            callforAppoinments(true, APIMethods.getDocReqestedBooking, currentpage,"") { (dictofApiResponse) in
                
                let arrofResponse = dictofApiResponse.object(forKey: getDoctorAppointments.APIResponse.data) as! NSArray
                self.requestedAppointDetailsVc.loadRemainingMore(arrofResponse)
                
            }
                
            }
        }
    }
    
    func reloadreqAllAppointmetns() {
        
        APIServices.SharedInstance.invalidatePreviousRequest()
        
        currentpage = 0
        
        if Connectivity.isCheckForNewwork() == false {
            
//            self.requestedAppointDetailsVc.dictofApiResponse = dictofCoreDataRequestedResponse
//            self.requestedAppointDetailsVc.reloadAppointmentss()
            
        } else {
      
        callforAppoinments(true, APIMethods.getDocReqestedBooking, currentpage,"") { (dictofApiResponse) in
            
            self.requestedAppointDetailsVc.dictofApiResponse = dictofApiResponse
            self.requestedAppointDetailsVc.reloadAppointmentss()
            
        }
            
        }
    }
    
}



extension AppointmetnsViewController {
    
    func callforAppoinments(_ toShowLoader : Bool,_ apiRequestMethode : String, _ currentPage : Int,_ searchText : String ,success : @escaping SearchAppointmentsResponse){
        isRequestisGoingon = true
        
        self.showActivityIndicator()
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      getDoctorAppointments.APIRequest.page : "\(currentPage)",
            getDoctorAppointments.APIRequest.searchKey : "\(searchText)"]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: apiRequestMethode, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            self.hideActivityIndicator()
            
            self.isRequestisGoingon = false
            
            //  print(response)
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                success(dictofResonse)
                
                
                
                
                //coredata
                 let arrofResponse = dictofResonse.object(forKey: getDoctorAppointments.APIResponse.data) as! NSArray
                
                let appDel = UIApplication.shared.delegate as! AppDelegate
                let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
               
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:AppointmentDetailsCoreDataList.EntityName.Appointments)
                
                for i in 0 ..<  arrofResponse.count {
                    
                    let dic = arrofResponse[i] as! NSDictionary
                    
                fetchRequest.predicate = NSPredicate(format: "appointID = %@",  dic.value(forKey: getDoctorAppointments.APIResponse.uniqueId) as! CVarArg)
                
                
                    
                    do {
                        let list = try context.fetch(fetchRequest) as? [NSManagedObject]
                        if list!.count == 0 {
                            if self.strofSelectedType == self.RequestedType {
                                self.saveAppointmentDetailsInCoredata(dict: dictofResonse)
                            }
                            else if self.strofSelectedType == self.UpcomingType {
                                self.saveAppointmentDetailsInCoredata(dict: dictofResonse)
                            }
                            else if self.strofSelectedType == self.CompletedType {
                                self.saveAppointmentDetailsInCoredata(dict: dictofResonse)
                            }
                            else if self.strofSelectedType == self.CancelledType {
                                self.saveAppointmentDetailsInCoredata(dict: dictofResonse)
                            }
                         
                            print("save %@")
                        }else{
                            print("update %@")
                            
                            
                              let object = list![0]
                             if self.strofSelectedType == self.RequestedType {
                            let  uniqueIdvalues = dic.value(forKey: getDoctorAppointments.APIResponse.uniqueId)
                            object.setValue(uniqueIdvalues, forKey: AppointmentDetailsCoreDataList.Attributes.appointID)
                                do {
                                    try context.save()
                                } catch {
                                    print("Failed saving")
                                }
                            }
                             else if self.strofSelectedType == self.UpcomingType {
                                let  uniqueIdvalues = dic.value(forKey: getDoctorAppointments.APIResponse.uniqueId)
                                object.setValue(uniqueIdvalues, forKey: AppointmentDetailsCoreDataList.Attributes.appointID)
                                do {
                                    try context.save()
                                } catch {
                                    print("Failed saving")
                                }
                             }
                             else if self.strofSelectedType == self.CompletedType {
                                let  uniqueIdvalues = dic.value(forKey: getDoctorAppointments.APIResponse.uniqueId)
                                object.setValue(uniqueIdvalues, forKey: AppointmentDetailsCoreDataList.Attributes.appointID)
                                do {
                                    try context.save()
                                } catch {
                                    print("Failed saving")
                                }
                             }
                             else if self.strofSelectedType == self.CancelledType {
                                let  uniqueIdvalues = dic.value(forKey: getDoctorAppointments.APIResponse.uniqueId)
                                object.setValue(uniqueIdvalues, forKey: AppointmentDetailsCoreDataList.Attributes.appointID)
                                do {
                                    try context.save()
                                } catch {
                                    print("Failed saving")
                                }
                            }
                            
                            
                            //  print("update %@")
                        }
                    } catch let error as NSError {
                        // failure
                        print("Fetch failed: \(error.localizedDescription)")
                }
                
                }
           
            }
            else{
                Utilities.sharedInstace.showAlertviewWithMessage(String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.error_message)))
                
            }
            
        }) { (networkErr, messag) in
            self.hideActivityIndicator()
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
//                if messag == NetworkErrorIssue{
//                    OopsVC.errorType = NetworkError
//                }
//                self.present(OopsVC, animated: true, completion: nil)
//            }
        }
    }
    
    
    func saveAppointmentDetailsInCoredata(dict : NSDictionary ) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
       
        let dictofAppointment = dict
       
        let arrofResponse = dictofAppointment.object(forKey: getDoctorAppointments.APIResponse.data) as! NSArray
        
      //   let encodedObject : Data = NSKeyedArchiver.archivedData(withRootObject:   arrofResponse)
       
        if self.strofSelectedType == self.RequestedType {
           
            for appID in arrofResponse {
                let entity = NSEntityDescription.entity(forEntityName: AppointmentDetailsCoreDataList.EntityName.Appointments, in: context)!
                let object = NSManagedObject(entity: entity, insertInto: context)
              let  uniqueIdvalues = (appID as AnyObject).value(forKey: getDoctorAppointments.APIResponse.uniqueId)
                object.setValue(uniqueIdvalues, forKey: AppointmentDetailsCoreDataList.Attributes.appointID)
                 let encodedObject : Data = NSKeyedArchiver.archivedData(withRootObject:   appID)
                object.setValue(encodedObject, forKey:  AppointmentDetailsCoreDataList.Attributes.appointmentData)
                object.setValue("Req", forKey: AppointmentDetailsCoreDataList.Attributes.appointType)
                
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
                
            }
          
            
        } else if self.strofSelectedType == self.UpcomingType {
         
            for appID in arrofResponse {
                let entity = NSEntityDescription.entity(forEntityName: AppointmentDetailsCoreDataList.EntityName.Appointments, in: context)!
                let object = NSManagedObject(entity: entity, insertInto: context)
                let  uniqueIdvalues = (appID as AnyObject).value(forKey: getDoctorAppointments.APIResponse.uniqueId)
                object.setValue(uniqueIdvalues, forKey: AppointmentDetailsCoreDataList.Attributes.appointID)
                let encodedObject : Data = NSKeyedArchiver.archivedData(withRootObject:   appID)
                object.setValue(encodedObject, forKey:  AppointmentDetailsCoreDataList.Attributes.appointmentData)
                object.setValue("Up", forKey: AppointmentDetailsCoreDataList.Attributes.appointType)
                
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
                
            }
            
        } else if self.strofSelectedType == self.CompletedType {
            
            for appID in arrofResponse {
                let entity = NSEntityDescription.entity(forEntityName: AppointmentDetailsCoreDataList.EntityName.Appointments, in: context)!
                let object = NSManagedObject(entity: entity, insertInto: context)
                let  uniqueIdvalues = (appID as AnyObject).value(forKey: getDoctorAppointments.APIResponse.uniqueId)
                object.setValue(uniqueIdvalues, forKey: AppointmentDetailsCoreDataList.Attributes.appointID)
                let encodedObject : Data = NSKeyedArchiver.archivedData(withRootObject:   appID)
                object.setValue(encodedObject, forKey:  AppointmentDetailsCoreDataList.Attributes.appointmentData)
                object.setValue("Com", forKey: AppointmentDetailsCoreDataList.Attributes.appointType)
                
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
                
            }
            
        } else if self.strofSelectedType == self.CancelledType {
            
            for appID in arrofResponse {
                let entity = NSEntityDescription.entity(forEntityName: AppointmentDetailsCoreDataList.EntityName.Appointments, in: context)!
                let object = NSManagedObject(entity: entity, insertInto: context)
                let  uniqueIdvalues = (appID as AnyObject).value(forKey: getDoctorAppointments.APIResponse.uniqueId)
                object.setValue(uniqueIdvalues, forKey: AppointmentDetailsCoreDataList.Attributes.appointID)
                let encodedObject : Data = NSKeyedArchiver.archivedData(withRootObject:   appID)
                object.setValue(encodedObject, forKey:  AppointmentDetailsCoreDataList.Attributes.appointmentData)
                object.setValue("Cancel", forKey: AppointmentDetailsCoreDataList.Attributes.appointType)
                
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
                
            }
            
        }

        
    }
    
    func fetchRequestedCoreData() {
        
        let appoType = "Req"
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: AppointmentDetailsCoreDataList.EntityName.Appointments)
        
        do {
            fetchRequest.predicate = NSPredicate(format: "appointType == %@", appoType)
            let results = try context.fetch(fetchRequest)
            print(results)
            self.requestedAppointDetailsVc.requestedCoreDataArr = NSMutableArray.init(array: results)
            
             selectionOptions(0, [:])
            
            self.requestedAppointDetailsVc.reloadCoreDataObjects()

//            if results.count != 0 {
//
//            for case let Appointmentsobject as Appointments in results{
//             let appID = Appointmentsobject.appointID
//             let data = Appointmentsobject.appointmentData
//             let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:data!)
//                 dictofCoreDataRequestedResponse = unarchiveObject  as! NSDictionary
//
//            }
//
//            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
        
        
    }
    
    
    func fetchUpcomingCoreData() {
        
        let appoType = "Up"
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: AppointmentDetailsCoreDataList.EntityName.Appointments)
        
        do {
            fetchRequest.predicate = NSPredicate(format: "appointType == %@", appoType)
            let results = try context.fetch(fetchRequest)
            print(results)
            self.upcomingAppointDetailsVc.upcomingCoreDataArr = NSMutableArray.init(array: results)
            
             selectionOptions(1, [:])
            
            self.upcomingAppointDetailsVc.reloadCoreDataObjects()
//            if results.count != 0 {
//
//                for case let Appointmentsobject as Appointments in results{
//                    let appID = Appointmentsobject.appointID
//                    let data = Appointmentsobject.appointmentData
//                    let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:data!)
//                    dictofCoreDataRequestedResponse = unarchiveObject  as! NSDictionary
//
//                }
            
            //}
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
        
        
    }
    
    func fetchCompletedCoreData() {
        
        let appoType = "Com"
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: AppointmentDetailsCoreDataList.EntityName.Appointments)
        
        do {
            fetchRequest.predicate = NSPredicate(format: "appointType == %@", appoType)
            let results = try context.fetch(fetchRequest)
            print(results)
            self.completedAppointDetailsVc.completedCoreDataArr = NSMutableArray.init(array: results)
            
             selectionOptions(2, [:])
            
            self.completedAppointDetailsVc.reloadCoreDataObjects()
//            if results.count != 0 {
//
//                for case let Appointmentsobject as Appointments in results{
//                    let appID = Appointmentsobject.appointID
//                    let data = Appointmentsobject.appointmentData
//                    let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:data!)
//                    dictofCoreDataRequestedResponse = unarchiveObject  as! NSDictionary
//
//                }
//
//            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
        
        
    }
    
    
    func fetchCanceledCoreData() {
        
        let appoType = "Cancel"
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: AppointmentDetailsCoreDataList.EntityName.Appointments)
        
        do {
            fetchRequest.predicate = NSPredicate(format: "appointType == %@", appoType)
            let results = try context.fetch(fetchRequest)
            print(results)
            self.canceledAppointDetailsVc.canceledCoreDataArr = NSMutableArray.init(array: results)
            
            
             selectionOptions(3, [:])
            
            self.canceledAppointDetailsVc.reloadCoreDataObjects()
            
//            if results.count != 0 {
//
//                for case let Appointmentsobject as Appointments in results{
//                    let appID = Appointmentsobject.appointID
//                    let data = Appointmentsobject.appointmentData
//                    let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:data!)
//                    dictofCoreDataRequestedResponse = unarchiveObject  as! NSDictionary
//
//                }
//
//            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
        
        
    }
    
    
    
    func fetchData() {
        
          if strofSelectedType == RequestedType {
            fetchRequestedCoreData()
        }  else if strofSelectedType == UpcomingType {
            fetchUpcomingCoreData()
        }  else if strofSelectedType == CompletedType {
            fetchCompletedCoreData()
        }  else if strofSelectedType == CancelledType {
            fetchCanceledCoreData()
        }
        
//        let app = UIApplication.shared.delegate as! AppDelegate
//        let context = app.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: AppointmentDetailsCoreDataList.EntityName.Appointments)
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
//                    let appType = (result as AnyObject).value(forKey: AppointmentDetailsCoreDataList.Attributes.appointType) as! String
//                    print(appType)
//


                    //    if strofSelectedType == RequestedType {
//                            if appType == "Req"  {
//                            let appID = (result as AnyObject).value(forKey: AppointmentDetailsCoreDataList.Attributes.appointID)
//                            let data = (result as AnyObject).value(forKey: AppointmentDetailsCoreDataList.Attributes.appointmentData) as! NSData
//                            let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:data as Data)
//                            dictofCoreDataRequestedResponse = unarchiveObject  as! NSDictionary
                         //   self.fetchRequestedCoreData()
//                            self.selectionOptions(0, dictofCoreDataRequestedResponse)
//                            self.requestedAppointDetailsVc.dictofApiResponse = dictofCoreDataRequestedResponse
//                             self.requestedAppointDetailsVc.reloadAppointmentss()
                           // }
                      //  }
//                        else if strofSelectedType == UpcomingType {
//                            if appType == "Up" {
//                            let data = (result as AnyObject).value(forKey: AppointmentDetailsCoreDataList.Attributes.appointmentData) as! NSData
//                            let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:data as Data)
//                            dictofCoreDataUpcomingResponse = unarchiveObject  as! NSDictionary
//                            self.selectionOptions(1, dictofCoreDataUpcomingResponse)
//                            self.upcomingAppointDetailsVc.dictofApiResponse = dictofCoreDataUpcomingResponse
//                            self.upcomingAppointDetailsVc.reloadAppointmentss()
//                            }
//                        }
//                        else if strofSelectedType == CompletedType {
//                            if appType == "Com"  {
//                            let data = (result as AnyObject).value(forKey: AppointmentDetailsCoreDataList.Attributes.appointmentData) as! NSData
//                            let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:data as Data)
//                            dictofCoreDataCompletedResponse = unarchiveObject  as! NSDictionary
//                            self.selectionOptions(2, dictofCoreDataCompletedResponse)
//                            self.completedAppointDetailsVc.dictofApiResponse = dictofCoreDataCompletedResponse
//                            self.completedAppointDetailsVc.reloadAppointmentss()
//                            }
//                        }
//                        else if strofSelectedType == CancelledType {
//                            if appType == "Cancel" {
//                            let data = (result as AnyObject).value(forKey: AppointmentDetailsCoreDataList.Attributes.appointmentData) as! NSData
//                            let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:data as Data)
//                            dictofCoreDataCanceledResponse = unarchiveObject  as! NSDictionary
//                            self.selectionOptions(3, dictofCoreDataCanceledResponse)
//                            self.canceledAppointDetailsVc.dictofApiResponse = dictofCoreDataCanceledResponse
//                            self.canceledAppointDetailsVc.reloadAppointmentss()
//                            }
//                        }
////
//
                    
                    //    break
                   // }
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
        
    }
    
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        CallforAppointmentAPIReqiest(strofSelectedType)
        
    }
    
    
    func CallforAppointmentAPIReqiest(_ selectedType : String){
        
        var apiRequestMethode : String!
        
        if selectedType == RequestedType {
            apiRequestMethode = APIMethods.getDocReqestedBooking
        }
        else if selectedType == UpcomingType {
            apiRequestMethode = APIMethods.getDocUpcomingBooking
        }
        else if selectedType == CompletedType {
            apiRequestMethode = APIMethods.getDocPastBooking
        }
        else if selectedType == CancelledType {
            apiRequestMethode = APIMethods.getDocDeclinedBooking
        }
        
        
        callforAppoinments(true, apiRequestMethode,0,"") { (dictofResonse) in
            
            if selectedType ==  self.RequestedType {
                self.selectionOptions(0, dictofResonse)
                
                self.requestedAppointDetailsVc.dictofApiResponse = dictofResonse
                self.requestedAppointDetailsVc.reloadAppointmentss()
                
            }
            else if selectedType == self.UpcomingType {
                self.selectionOptions(1, dictofResonse)
                self.upcomingAppointDetailsVc.dictofApiResponse = dictofResonse
                self.upcomingAppointDetailsVc.reloadAppointmentss()
                
            }
            else if selectedType == self.CompletedType {
                self.selectionOptions(2, dictofResonse)
                self.completedAppointDetailsVc.dictofApiResponse = dictofResonse
                self.completedAppointDetailsVc.reloadAppointmentss()
                
            }
            else if selectedType == self.CancelledType {
                self.selectionOptions(3, dictofResonse)
                self.canceledAppointDetailsVc.dictofApiResponse = dictofResonse
                self.canceledAppointDetailsVc.reloadAppointmentss()
                
            }
        }
        
        /*
         APIServices.SharedInstance.MbProgress(view: self.view, Message: "Loading...")
         
         let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey, APIRequestKeys.userRef : UserDefaultStore.userRef,getDoctorAppointments.APIRequest.page : "0"]
         
         
         APIServices().callApiResponse(MethodName: apiRequestMethode, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
         
         APIServices.SharedInstance.hideProgress()
         
         print(response)
         
         let dictofResonse = response as! NSDictionary
         
         if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
         
         if selectedType ==  self.Requested {
         self.selectionOptions(0, dictofResonse)
         self.requestedAppointDetailsVc.dictofApiResponse = dictofResonse
         self.requestedAppointDetailsVc.reloadAppointmentss()
         
         }
         else if selectedType == self.Upcoming {
         self.selectionOptions(1, dictofResonse)
         self.upcomingAppointDetailsVc.dictofApiResponse = dictofResonse
         self.upcomingAppointDetailsVc.reloadAppointmentss()
         
         }
         else if selectedType == self.Completed {
         self.selectionOptions(2, dictofResonse)
         self.completedAppointDetailsVc.dictofApiResponse = dictofResonse
         self.completedAppointDetailsVc.reloadAppointmentss()
         
         }
         else if selectedType == self.Cancelled {
         self.selectionOptions(3, dictofResonse)
         self.canceledAppointDetailsVc.dictofApiResponse = dictofResonse
         self.canceledAppointDetailsVc.reloadAppointmentss()
         
         }
         
         }
         else{
         
         Utilities.sharedInstace.showAlertviewWithMessage("Error from server")
         }
         
         
         }) { (networkErr) in
         
         print(networkErr as Any)
         
         }*/
        
    }
    
    
   
    
}

extension AppointmetnsViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppoinmentCollectionViewCell", for: indexPath) as! AppoinmentCollectionViewCell
        
        cell.lblOfApp.text = arrOfCollection[indexPath.row]
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            if indexPath.row == selectedIndex {
                cell.lblOfApp.textColor = UIColor.white
                cell.lblOfApp.font = Constatns.Lato_Bold(13)
                cell.lblOfBgColor.backgroundColor = UIColor.white
            }else{
                cell.lblOfApp.textColor = Constatns.AppointmentColour()
                cell.lblOfApp.font = Constatns.LatoRegular(13)
                cell.lblOfBgColor.backgroundColor = UIColor.clear
            }
        }
        else if UIDevice.current.userInterfaceIdiom == .pad {
            if indexPath.row == selectedIndex {
                cell.lblOfApp.textColor = UIColor.white
                cell.lblOfApp.font = Constatns.Lato_Bold(25)
                cell.lblOfBgColor.backgroundColor = UIColor.white
            }else{
                cell.lblOfApp.textColor = Constatns.AppointmentColour()
                cell.lblOfApp.font = Constatns.LatoRegular(25)
                cell.lblOfBgColor.backgroundColor = UIColor.clear
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
         if UIDevice.current.userInterfaceIdiom == .phone {
            if arrOfCollection.count == 3{
                return CGSize(width: self.view.frame.size.width/3, height: 50)
            }else{
                return CGSize(width: self.view.frame.size.width/4, height: 50)
            }
        } else {
            if arrOfCollection.count == 3{
                return CGSize(width: self.view.frame.size.width/3, height: 90)
            }else{
                return CGSize(width: self.view.frame.size.width/4, height: 90)
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        selectedIndex(selectedIndex)
        
        collectionView.reloadData()
    }
    
    
    func selectedIndex(_ integ : Int){
        
        /*["Requested","UpComing","Completed","Canceled"]*/
        
        if self.isIndicatorisvisible {
            self.hideActivityIndicator()
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.toCallSearchAppointQueue), object: "")
            APIServices.SharedInstance.invalidatePreviousRequest()
        }
        
        if arrOfCollection[integ] == RequestedTit{
            strofSelectedType = RequestedType
          //
            if Connectivity.isCheckForNewwork() == false {
                fetchData()
                
                
            }else{
                CallforAppointmentAPIReqiest(Requested)
            }
            
        }
        if arrOfCollection[integ] == UpComingTit{
            strofSelectedType = UpcomingType
            if Connectivity.isCheckForNewwork() == false {
                fetchData()
            }else{
                CallforAppointmentAPIReqiest(Upcoming)
            }
        }
        if arrOfCollection[integ] == CompletedTit{
            strofSelectedType = CompletedType
            if Connectivity.isCheckForNewwork() == false {
                fetchData()
            }else{
                CallforAppointmentAPIReqiest(Completed)
            }
        }
        if arrOfCollection[integ] == CanceledTit{
            strofSelectedType = CancelledType
            
            if Connectivity.isCheckForNewwork() == false {
                fetchData()
            }else{
                CallforAppointmentAPIReqiest(Cancelled)
            }
        }
        
        
    }
    
}






