//
//  RequestedAppointmentsViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import CoreData


public protocol RequestAppointLoadmoreDelegate {
    func loadMoreReqAppoiDelegate()
    func reloadreqAllAppointmetns()
   
}



class RequestedAppointmentsViewController: UIViewController,ErrorProtocalDelegate,RequestAppointLoadmoreDelegate {
    
    func loadMoreReqAppoiDelegate() {
        
    }
    func reloadreqAllAppointmetns(){
        
    }
    
    
    @IBOutlet var tbofAppointments: UITableView!
    
    var dictofApiResponse : NSDictionary!
    var dictofCoreDataResponse : NSDictionary!
    var requestedCoreDataArr : NSMutableArray!
    
    var arrofAppointments : NSMutableArray!
    var arrofOpenCellIndexs : NSMutableArray!
    var isFromCoreData : Bool = false
    
     var isbtnOfSelected : Bool = false
    
    
    var delegate : RequestAppointLoadmoreDelegate!
    
    var totalNoofRecords : Int!
    
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var viewofNoAppointments : UIView!
    
    var isRequestisgoingon : Bool = false
    var isError : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrofOpenCellIndexs = NSMutableArray.init()
        arrofAppointments = NSMutableArray.init()
        requestedCoreDataArr = NSMutableArray.init()
        viewofNoAppointments.isHidden = true
        tbofAppointments.isHidden = false
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        tbofAppointments.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewofNoAppointments.isHidden = true
        tbofAppointments.isHidden = false
    }
    
    @objc func refresh(sender:AnyObject) {
        
        refreshControl.beginRefreshing()
        if let delegateObj = self.delegate {
            
            delegateObj.reloadreqAllAppointmetns()
            
            //            arrofAppointments.removeAllObjects()
            //            refreshControl.endRefreshing()
            //            tbofAppointments.reloadData()
        }
        
    }
    
    
    func loadRemainingMore(_ arrofResponseApponits : NSArray){
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        isRequestisgoingon = false
        if arrofAppointments.count > 0 {
            arrofAppointments.addObjects(from: arrofResponseApponits as! [Any])
            tbofAppointments.reloadData()
        }else{
            viewofNoAppointments.isHidden = false
            tbofAppointments.isHidden = true
        }
        
        
    }
    
    func reloadCoreDataObjects()  {
         isFromCoreData = true
        
        if  requestedCoreDataArr.count > 0 {
            self.tbofAppointments.isHidden = false
            self.viewofNoAppointments.isHidden = true
            self.tbofAppointments.reloadData()
        } else {
            self.tbofAppointments.isHidden = true
            self.viewofNoAppointments.isHidden = false
        }
        
       
    }
    
    func reloadAppointmentss(){
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        
        let arrofResponse = dictofApiResponse.object(forKey: getDoctorAppointments.APIResponse.data) as! NSArray
        
        let strofTotleRecords = String(describing:dictofApiResponse.TabiibDocObjectForKey(forKey: SearchClinics.APIResponse.totalRecords))
        
        totalNoofRecords = Int(strofTotleRecords)!
        
        arrofAppointments.removeAllObjects()
        
        arrofAppointments.addObjects(from: arrofResponse as! [Any])
        
        arrofOpenCellIndexs.removeAllObjects()
        
        
        if arrofAppointments.count > 0 {
            tbofAppointments.isHidden = false
            tbofAppointments.reloadData()
            viewofNoAppointments.isHidden = true
        }else{
            viewofNoAppointments.isHidden = false
            tbofAppointments.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calltoupadateAccepedCoredataStatus(_ dictApp: NSDictionary, _ indexPath : IndexPath) {
        
        
       // let arrofResponse = dictApp.object(forKey: getDoctorAppointments.APIResponse.data) as! NSArray
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:AppointmentDetailsCoreDataList.EntityName.Appointments)
        
       // for i in 0 ..<  arrofResponse.count {
            
            let dic = dictApp
            
            fetchRequest.predicate = NSPredicate(format: "appointID = %@",  dic.value(forKey: getDoctorAppointments.APIResponse.uniqueId) as! CVarArg)
            
            
            do {
                let list = try context.fetch(fetchRequest) as? [NSManagedObject]
                if list!.count == 0 {

                    print("save %@")
                }else{
                    print("update %@")
                    //  print("update %@")
                  //  let object = NSEntityDescription.insertNewObject(forEntityName: AppointmentDetailsCoreDataList.EntityName.Appointments, into: context)
                   // let entity = NSEntityDescription.entity(forEntityName: AppointmentDetailsCoreDataList.EntityName.Appointments, in: context)!
                  // let object = NSManagedObject(entity: entity, insertInto: context)
                  //  let  uniqueIdvalues = (dic as AnyObject).value(forKey: getDoctorAppointments.APIResponse.uniqueId)
                    //object.setValue(uniqueIdvalues, forKey: AppointmentDetailsCoreDataList.Attributes.appointID)
                    
                    let object = list![0]
                    
                    
                    object.setValue("Up", forKey: AppointmentDetailsCoreDataList.Attributes.appointType)
                    
//                    let encodedObject : Data = NSKeyedArchiver.archivedData(withRootObject: dic)
//                    object.setValue(encodedObject, forKey:  AppointmentDetailsCoreDataList.Attributes.appointmentData)
                 
                    
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
            
       // }
        
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
            
        } catch {
            
        }
    }
    
    func calltoupadateRejectedCoredataStatus(_ dictApp: NSDictionary, _ indexPath : IndexPath) {
        
       // let arrofResponse = dictofApiResponse.object(forKey: getDoctorAppointments.APIResponse.data) as! NSArray
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:AppointmentDetailsCoreDataList.EntityName.Appointments)
        
       // for i in 0 ..<  arrofResponse.count {
            
            let dic = dictApp
            
            fetchRequest.predicate = NSPredicate(format: "appointID = %@",  dic.value(forKey: getDoctorAppointments.APIResponse.uniqueId) as! CVarArg)
            
            
            do {
                let list = try context.fetch(fetchRequest) as? [NSManagedObject]
                if list!.count == 0 {
              
                    print("save %@")
                }else{
                    print("update %@")
               
                    let object = list![0]
                    
//                    let entity = NSEntityDescription.entity(forEntityName: AppointmentDetailsCoreDataList.EntityName.Appointments, in: context)!
//                    let object = NSManagedObject(entity: entity, insertInto: context)
//                    let  uniqueIdvalues = (dic as AnyObject).value(forKey: getDoctorAppointments.APIResponse.uniqueId)
//                    object.setValue(uniqueIdvalues, forKey: AppointmentDetailsCoreDataList.Attributes.appointID)
                    object.setValue("Cancel", forKey: AppointmentDetailsCoreDataList.Attributes.appointType)
//                    let encodedObject : Data = NSKeyedArchiver.archivedData(withRootObject: dic)
//                    object.setValue(encodedObject, forKey:  AppointmentDetailsCoreDataList.Attributes.appointmentData)
                    
                    
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
            
      //  }
        
    }
    
    
    func calltoUpdateAppointmentStatusAPIReqiest(_ dictofAppointment : NSDictionary,_ appointmentStatus : String,_ indexPath : IndexPath){
        
        let strogBookingREf = String(describing:dictofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingRef))
        
        
        APIServices.SharedInstance.MbProgress(view: self.view, Message:APIServiceLoading.Loading)
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey, APIRequestKeys.userRef : UserDefaultStore.userRef,updateDocBooking.APIRequest.bookingRef : strogBookingREf,updateDocBooking.APIRequest.bookingStatus : appointmentStatus]
        
        
        APIServices().callApiResponse(MethodName: APIMethods.updateDocBooking, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //   print(response)
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                
                if self.isbtnOfSelected == false {
                self.calltoupadateAccepedCoredataStatus(dictofAppointment, indexPath)
            } else {
                self.calltoupadateRejectedCoredataStatus(dictofAppointment, indexPath)
            }
                
                self.arrofAppointments.removeObject(at: indexPath.row)
                
                if self.arrofAppointments.count > 0 {
                    self.tbofAppointments.beginUpdates()
                    self.tbofAppointments.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
                    self.tbofAppointments.endUpdates()
                }else{
                    self.viewofNoAppointments.isHidden = false
                    self.tbofAppointments.isHidden = true
                }
                
                
                
                
            }
            else{
                
                let serv = NSLocalizedString("Error from server", comment: "")
                Utilities.sharedInstace.showAlertviewWithMessage(serv)
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
//                
//                if messag == NetworkErrorIssue{
//                    OopsVC.errorType = NetworkError
//                }
//                self.present(OopsVC, animated: true, completion: nil)
//            }
        }
    }
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        if self.isError == "Home"{
            
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

extension RequestedAppointmentsViewController : UITableViewDataSource,UITableViewDelegate,SwipeableCellDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromCoreData {
           return requestedCoreDataArr.count
        } else {
        return arrofAppointments.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 150
        } else {
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let appointCell =  tableView.dequeueReusableCell(withIdentifier: "SwipeTableViewCell", for: indexPath) as! SwipeTableViewCell
        
        var dicofAppointment = NSDictionary.init()
        if isFromCoreData {
            let appointObj = requestedCoreDataArr[indexPath.row] as! Appointments
            let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:appointObj.appointmentData!)
               dicofAppointment = unarchiveObject  as! NSDictionary
        } else {
         dicofAppointment = arrofAppointments[indexPath.row] as! NSDictionary
        }
        
        appointCell.lblofClinicName.text = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.hospitalName))
        
        appointCell.lblofReason.text = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.reason))
        
        let strOfDate : String = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookOn))
        
        
        appointCell.lblofRequestedDate.text = strOfDate.getDateFormate()
        //String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookOn))
        
        let appointmentDate = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingDate))
        
        let arrofDate = appointmentDate.components(separatedBy: "-")
        if arrofDate.count > 0 {
            appointCell.lblofDate.text = arrofDate.last
        }
        
        //        let startSlot =  String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.startBookingSlot))
        //        let arrOfStartSLot = startSlot.components(separatedBy: " ")
        //        if arrOfStartSLot.count > 0{
        //            let startSlotTime = arrOfStartSLot[0]
        //            appointCell.lbloftime.text =  startSlotTime + "-" + String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.endBookingSlot))
        //
        //        }
        
        appointCell.lbloftime.text =  String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.startBookingSlot)) + " - " + String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.endBookingSlot))
        
        appointCell.lblofDay.text = appointmentDate.getDayOfWeek()
        
        appointCell.lblofPatientName.text = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bkPatientName))
        
        if String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingThrough)) != "Web" {
            appointCell.imgofappointType.image = UIImage.init(named: "Mobile")
        }else{
            appointCell.imgofappointType.image = UIImage.init(named: "Web")
            
        }
        appointCell.lblofFollowup.text = NSLocalizedString("New", comment: "")
        
        appointCell.lblofMonth.text = appointmentDate.getMonthFormate()
        
        //  appointCell.lblofRequestedDate.text = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookOn))
        
        
        appointCell.selectionStyle = .none
        
        appointCell.delegate = self
        
        if arrofOpenCellIndexs.contains(indexPath) {
            appointCell.openCell()
        }else{
            appointCell.closeCell()
        }
        
        return appointCell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dicofAppointment = NSDictionary.init()
        if isFromCoreData {
            let appointObj = requestedCoreDataArr[indexPath.row] as! Appointments
            let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:appointObj.appointmentData!)
            dicofAppointment = unarchiveObject  as! NSDictionary
        } else {
            dicofAppointment = arrofAppointments[indexPath.row] as! NSDictionary
        }
       // let dicofAppointment = arrofAppointments[indexPath.row] as! NSDictionary
        //     print("in details")
        
        let appointDetailsVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "AppointmentDetailsViewController") as! AppointmentDetailsViewController
        appointDetailsVC.typeofAppointment = "R"
        appointDetailsVC.selectedAppointment = dicofAppointment
        self.navigationController?.pushViewController(appointDetailsVC, animated: true)
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
             if Connectivity.isCheckForNewwork() == true {
            if arrofAppointments.count < totalNoofRecords {
                if isRequestisgoingon == false {
                    if let delegateObj = self.delegate {
                        isRequestisgoingon = true
                        delegateObj.loadMoreReqAppoiDelegate()
                    }
                }
            }
            }
        }
        
    }
    
    
    func btnAcceptClicked(_ cell: SwipeTableViewCell) {
        
        /*bookingStatus = 2 Accept
         3 declinde
         */
        self.isbtnOfSelected = false
        guard let indexPath = self.tbofAppointments.indexPath(for: cell) else {
            return
        }
        if indexPath != nil {
               if Connectivity.isCheckForNewwork() == true {
            let dicotfAppointment = arrofAppointments[indexPath.row] as! NSDictionary
            
            //   print("accept clickd : \(dicotfAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.hospitalName))")
         
            calltoUpdateAppointmentStatusAPIReqiest(dicotfAppointment, "2",indexPath)
                
           
            }
            
        }
        
    }
    
    
    func btnRejectClicked(_ cell: SwipeTableViewCell) {
        guard let indexPath = self.tbofAppointments.indexPath(for: cell) else {
            return
        }
        self.isbtnOfSelected = true
        if indexPath != nil {
               if Connectivity.isCheckForNewwork() == true {
            let dicotfAppointment = arrofAppointments[indexPath.row] as! NSDictionary
            
            //  print("rekect clickd : \(dicotfAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.hospitalName))")
            
            calltoUpdateAppointmentStatusAPIReqiest(dicotfAppointment, "3",indexPath)
               }
        }
    }
    
    
    func cellDidOpen(_ cell: SwipeTableViewCell) {
        
        guard let indexPAth = self.tbofAppointments.indexPath(for: cell) else {
            return
        }
        
        arrofOpenCellIndexs.add(indexPAth)
    }
    
    func cellDidClose(_ cell: SwipeTableViewCell) {
        
        guard let indexPAth = self.tbofAppointments.indexPath(for: cell) else {
            return
        }
        
        arrofOpenCellIndexs.remove(indexPAth)
        
    }
    
    
    
    
}


