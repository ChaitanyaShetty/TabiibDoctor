//
//  AppointmentDetailsViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

let Requested = "Requested"
let Upcoming = "Upcoming"
let Completed = "Completed"
let Cancelled = "Cancelled"

let checkin = NSLocalizedString("Check In", comment: "")
let checkout = NSLocalizedString("Check Out", comment: "")
let call = NSLocalizedString("Call", comment: "")
let cancel = NSLocalizedString("Cancel", comment: "")

let CheckIn = checkin
let Checkout = checkout
let Call = call
let Cancel = cancel

protocol AppoinmentActionDelegate {
    
    func cancelClicked()
    func checkinClicked()
    func checkoutClicked()
    
}





class AppointmentDetailsViewController: UIViewController,ErrorProtocalDelegate,AppoinmentActionDelegate {
    func cancelClicked() {
        
    }
    
    func checkinClicked() {
        
    }
    
    func checkoutClicked() {
        
    }
    
    
    @IBOutlet weak var appointmentDetiTableView : UITableView!
    @IBOutlet weak var lblOfTypeFollow : UILabel!
    @IBOutlet weak var lblOfID : UILabel!
    @IBOutlet weak var lblOfSource : UILabel!
    
    var typeofAppointment : String! = ""
    var selectedAppointment : NSDictionary!
    
    var arrOfCollection : [String]!
    var arrOfCollImages : NSMutableArray!
    
    var delegate : AppoinmentActionDelegate!
    
    var dictofResponse : NSDictionary!
    var isError : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dictofResponse = NSDictionary.init()
        
        arrOfCollection = [String]()
        arrOfCollImages = NSMutableArray()
        
        lblOfSource.text =  NSLocalizedString("Source", comment: "") + " - " + "\(String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingThrough)))"
        
        lblOfTypeFollow.text =  NSLocalizedString("Type", comment: "") + " : " + NSLocalizedString("New", comment: "")
        
        lblOfID.text =  NSLocalizedString("ID", comment: "") + " - " + "\(String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.uniqueId)))"
        
        
        /* patient details cell , hospital cell, history details , payment details, your actions
         
         upcoming = 4 or 3
         requested,completed = 3 or 2
         
         */
        if typeofAppointment == "U" {
            
            calltoCheckincheckOutStatusAPIReqiest()
            //
            //        arrOfCollection = ["Check In","Check out","Delaye","Suggestions","Did not Arrive","Call","Cancel"]
            //        arrOfCollImages = ["Checkin","CheckOut","Delayed","Suggestions","Didn'tArrive","Call","Cancel"]
            
            
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    
    func calltoCheckincheckOutStatusAPIReqiest(){
        
        
        let strogBookingREf = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingRef))
        
        
     //   APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      checkCheckIn.APIRequest.bookingRef : strogBookingREf,checkCheckIn.APIRequest.userType : userType]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.checkCheckIn, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //   print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                
                //                let strofCheckinVal = String(describing:dictofResonse.TabiibDocObjectForKey(forKey: checkCheckIn.APIResponse.CheckIN))
                //
                //                if strofCheckinVal != "<null>" {
                //
                //                }
                /* if String(describing:dictofResponse.TabiibDocObjectForKey(forKey: checkCheckIn.APIResponse.EnableCheckIn)) == "0" {
                 print("disable check in")
                 
                 print("disbale checkout")
                 
                 if arrOfCollection[indexPath.row] == checkin {
                 cell.lblOfTitle.textColor = UIColor.red
                 }
                 if arrOfCollection[indexPath.row] == checkout {
                 cell.lblOfTitle.textColor = UIColor.red
                 }
                 }
                 else if String(describing:dictofResponse.TabiibDocObjectForKey(forKey: checkCheckIn.APIResponse.EnableCheckIn)) == "1" {
                 print("enable checkl inf")
                 
                 if arrOfCollection[indexPath.row] ==  checkin {
                 cell.lblOfTitle.textColor = UIColor.green
                 
                 if String(describing:dictofResponse.TabiibDocObjectForKey(forKey: checkCheckIn.APIResponse.checkInOutStatus)) == "0" {
                 if arrOfCollection[indexPath.row] == checkout {
                 cell.lblOfTitle.textColor = UIColor.red
                 }
                 }else    if String(describing:dictofResponse.TabiibDocObjectForKey(forKey: checkCheckIn.APIResponse.checkInOutStatus)) == "1" {
                 if arrOfCollection[indexPath.row] == checkout {
                 cell.lblOfTitle.textColor = UIColor.green
                 }
                 }else{
                 if arrOfCollection[indexPath.row] == checkout {
                 cell.lblOfTitle.textColor = UIColor.red
                 }
                 }
                 
                 }
                 }arrOfCollection = [CheckIn,Checkout,Call,Cancel]
                 arrOfCollImages = ["Checkin","CheckOut","Call","Cancel_1"]
                 */
                
                
                if dictofResonse.object(forKey: checkCheckIn.APIResponse.CheckIN) != nil {
                    
                    let dictofData = dictofResonse.object(forKey: checkCheckIn.APIResponse.CheckIN) as! NSDictionary
                    self.dictofResponse = NSDictionary.init(dictionary: dictofData)
                    
                    if String(describing:dictofData.TabiibDocObjectForKey(forKey: checkCheckIn.APIResponse.EnableCheckIn)) == "0" {
                        
                        if L102Language.currentAppleLanguage() == "en"{
                            self.arrOfCollection = [Call,Cancel]
                        }else{
                            self.arrOfCollection = ["اتصل","إلغاء"]
                        }
                        // self.arrOfCollection = [Call,Cancel]
                        self.arrOfCollImages = ["Call","Cancel_1"]
                    }
                    else if  String(describing:dictofData.TabiibDocObjectForKey(forKey: checkCheckIn.APIResponse.EnableCheckIn)) == "1" {
                        
                        if String(describing:dictofData.TabiibDocObjectForKey(forKey: checkCheckIn.APIResponse.checkInOutStatus)) == "0" {
                            
                            if L102Language.currentAppleLanguage() == "en"{
                                self.arrOfCollection = [CheckIn,Call,Cancel]
                            }else{
                                self.arrOfCollection = ["حضر","اتصل","إلغاء"]
                            }
                            
                            // self.arrOfCollection = [CheckIn,Call,Cancel]
                            self.arrOfCollImages = ["Checkin","Call","Cancel_1"]
                            
                        }else if String(describing:dictofData.TabiibDocObjectForKey(forKey: checkCheckIn.APIResponse.checkInOutStatus)) == "1" {
                            
                            if L102Language.currentAppleLanguage() == "en"{
                                self.arrOfCollection = [Checkout,Call,Cancel]
                            }else{
                                self.arrOfCollection = ["تم الإنتهاء","اتصل","إلغاء"]
                            }
                            
                            // self.arrOfCollection = [Checkout,Call,Cancel]
                            self.arrOfCollImages = ["CheckOut","Call","Cancel_1"]
                        }
                        
                        //                        self.arrOfCollection = [CheckIn,Checkout,Call,Cancel]
                        //                       self. arrOfCollImages = ["Checkin","CheckOut","Call","Cancel_1"]
                    }
                    
                    self.appointmentDetiTableView.reloadData()
                }
                
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func backBtnAction(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
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


extension AppointmentDetailsViewController : UITableViewDelegate,UITableViewDataSource{
    
    /* patient details cell , hospital cell, history details , payment details, your actions
     
     upcoming = 4 or 3
     requested,completed = 3 or 2
     
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if typeofAppointment == "U" {
            
            //check if payments is did or not
            let strofStatus = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey:getDoctorAppointments.APIResponse.paymentStatus))
            if strofStatus == "1" {
                return 4
            }else{
                return 3
            }
        }
        else if typeofAppointment == "R" ||  typeofAppointment == "C"  {
            let strofStatus = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey:getDoctorAppointments.APIResponse.paymentStatus))
            if strofStatus == "1" {
                return 3
            }else{
                return 2
            }
            
        }
        //        else if typeofAppointment == "C" {
        //            let strofStatus = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey:getDoctorAppointments.APIResponse.paymentStatus))
        //            if strofStatus == "1" {
        //                return 3
        //            }else{
        //                return 2
        //            }
        //        }
        return 0
    }
    
    //for patient details
    func getPatDetiailsRowHeight() -> CGFloat {
        //check its booking for own or some one else
        let strofBookingType = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingType))
        if strofBookingType == "1" {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return 160
            } else {
                return 200
            }
            //   return 160
        }
        else {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return 300
            } else {
                return 340
            }
            //  return 300
        }
    }
    
    //for Hospital deitals
    func getHospitalDetRowHeight() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 275
        } else {
            return 300
        }
    }
    
    //for history details
    func getHistoryDetRowHeight() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 300
        } else {
            return 320
        }
    }
    
    //for payment details
    func getPaymentDetRowHeight() -> CGFloat {
        return 460
    }
    
    //for actions cel
    func getActionsRowHeight() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 460
        } else {
            return 478
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        /* patient details cell , hospital cell, history details , payment details, your actions
         
         upcoming = 4 or 3
         requested,completed = 3 or 2
         
         */
        
        if typeofAppointment == "U" {
            
            //cell 1 ; pat det
            
            if indexPath.row == 0 {
                return self.getPatDetiailsRowHeight()
            }
                
                //cell2 ; hospital
            else if indexPath.row == 1 {
                return self.getHistoryDetRowHeight()
            }
                
            else if indexPath.row == 2 {
                let strofStatus = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey:getDoctorAppointments.APIResponse.paymentStatus))
                if strofStatus == "1" {
                    //check for own or some one else
                    return self.getPaymentDetRowHeight()
                }else{
                    return self.getActionsRowHeight()
                }
            }
            else if indexPath.row == 3 {
                return self.getActionsRowHeight()
            }
            
        }else if typeofAppointment == "R"  ||  typeofAppointment == "C"  {
            
            
            
            if indexPath.row == 0 {
                return self.getPatDetiailsRowHeight()
            }
            else if indexPath.row == 1
            {
                return self.getHospitalDetRowHeight()
            }
            else if indexPath.row == 2 {
                
                let strofStatus = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey:getDoctorAppointments.APIResponse.paymentStatus))
                
                if strofStatus == "1" {
                    return self.getPaymentDetRowHeight()
                }
            }
        }
        return 0.0
    }
    
    
    func getPatientDetailsCell() -> AppDetProfileTableViewCell {
        
        let pateintDetCel = appointmentDetiTableView.dequeueReusableCell(withIdentifier: "AppDetProfileTableViewCell") as! AppDetProfileTableViewCell
        
        pateintDetCel.lblOfPatientName.text = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.patName))
        
        let strofPatiendDOb = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.patDateOfBirth))
        
        pateintDetCel.lblOfAge.text = strofPatiendDOb.getDateofBirth()
        
        
        let mobileprefix : String = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.mobilePrefix))
        let mobileNumber : String = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.patmobileNumber))
        
        pateintDetCel.lblOfMobileNumber.text = "+" + mobileprefix + mobileNumber
        
     //   pateintDetCel.lblOfMobileNumber.text = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.patmobileNumber))
        
        
        pateintDetCel.lblOfBookedFor.text = NSLocalizedString("Other", comment: "")
        let strofPatiendDOb2 = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bkPatientDOB))
        
        pateintDetCel.lblOfBFAge.text = strofPatiendDOb2.getDateofBirth()
        pateintDetCel.lblOfBFPatientName.text = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bkPatientName))
        
        pateintDetCel.lblOfBFMobileNumber.text = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bkPatientMobileNumber))
        
        pateintDetCel.selectionStyle = .none
        
        //        let strofBookingType = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingType))
        //
        //        if strofBookingType == "1" {
        //            pateintDetCel.viewofPateintDetails.isHidden = true
        //        }else{
        //            pateintDetCel.viewofPateintDetails.isHidden = false
        //        }
        
        
        return pateintDetCel
        
    }
    
    
    func getPatientDetailsCell1() -> AppDetProfileTableViewCell1 {
        
        let pateintDetCel = appointmentDetiTableView.dequeueReusableCell(withIdentifier: "AppDetProfileTableViewCell1") as! AppDetProfileTableViewCell1
        
        pateintDetCel.lblOfPatientname.text = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.patName))
        
        let strofPatiendDOb = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.patDateOfBirth))
        
        pateintDetCel.lblOfAge.text = strofPatiendDOb.getDateofBirth()
        
        
        let mobileprefix : String = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.mobilePrefix))
        let mobileNumber : String = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.patmobileNumber))
        
        pateintDetCel.lblOfMobile.text = "+" + mobileprefix + mobileNumber
        
        
         return pateintDetCel
        
    }
    
    
    
    func getHospitalCell() -> AppDetHospitalTableViewCell {
        
        let hospitalCell = appointmentDetiTableView.dequeueReusableCell(withIdentifier: "AppDetHospitalTableViewCell") as! AppDetHospitalTableViewCell
        
        hospitalCell.lblOfClinicName.text =  String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.hospitalName)) + "  "  +  String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.hospitalBranchName))
        hospitalCell.lblOfVisitReason.text = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.reason))
        
        let strOfDate : String = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookOn))
        hospitalCell.lblOfRequestedDate.text = strOfDate.getDateFormate()
        
        hospitalCell.lblOfRequestedTime.text = strOfDate.getTimeFormate()
        
        let strOfDate1 : String = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingDate))
        
        hospitalCell.lblOfAppointDate.text = strOfDate1.getDateFormate1()
        
        hospitalCell.lblOfAppointTime.text = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.startBookingSlot))
        
        hospitalCell.selectionStyle = .none
        
        return hospitalCell
        
    }
    
    func getHistoryCell() -> AppDetHistoryTableViewCell {
        
        let historyCell = appointmentDetiTableView.dequeueReusableCell(withIdentifier: "AppDetHistoryTableViewCell") as! AppDetHistoryTableViewCell
        
        historyCell.lblOfConsultedDate.text = "feb 5th"
        historyCell.lblOfConsultedTime.text = "5:30AM"
        historyCell.lblOfVisitReason.text = "dfncjkacfadms"
        historyCell.lblOfDrSuggestion.text = "Dancinshos"
        
        return historyCell
    }
    
    
    func getPaymentCell() -> AppDetPaymentTableViewCell {
        
        let paymentCell = appointmentDetiTableView.dequeueReusableCell(withIdentifier: "AppDetPaymentTableViewCell") as! AppDetPaymentTableViewCell
        
        paymentCell.lblOfMode.text = ": " + NSLocalizedString("Online", comment: "")
        paymentCell.lblOfAmountPaid.text = ": " +   String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.currency)) + " " +  String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.paymentAmount))
        paymentCell.lblOfTransactionID.text =  ": " +  String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.transaction_id))
        let strOfDate : String = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookOn))
        paymentCell.lblOfPaidDate.text =  ": " +  strOfDate.getDateFormate()
        paymentCell.lblOfPending.text =  ": " +  "0"
        paymentCell.lblOfPendingAmount.text = ": " +  NSLocalizedString("NO DUE", comment: "")
        paymentCell.lblOfpaidDateIfPending.text =  ": " + NSLocalizedString("NO", comment: "")
        
        
        return paymentCell
    }
    
    func getActionsCell() -> AppDetActionsTableViewCell {
        
        let actionsCell = appointmentDetiTableView.dequeueReusableCell(withIdentifier: "AppDetActionsTableViewCell") as! AppDetActionsTableViewCell
        
        actionsCell.selectionStyle = .none
        
        actionsCell.actionCollectionView.reloadData()
        
        return actionsCell
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* patient details cell , hospital cell, history details , payment details, your actions
         
         upcoming = 4 or 3
         requested,completed = 3 or 2
         
         */
        
        if indexPath.row == 0 {
            
            let strofBookingType = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingType))
            
            if strofBookingType == "1" {
                return getPatientDetailsCell1()
            }else{
                return getPatientDetailsCell()
            }
            
            
            
        }
        else if indexPath.row == 1 {
            return getHospitalCell()
        }
        
        //check type of apppointment
        if typeofAppointment == "U" {
            
            if indexPath.row == 2 {
                let strofStatus = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey:getDoctorAppointments.APIResponse.paymentStatus))
                
                if strofStatus == "1" {
                    return getPaymentCell()
                }else{
                    return getActionsCell()
                }
            }
            else if indexPath.row == 3 {
                return getActionsCell()
            }
            
        }else if typeofAppointment == "R"  || typeofAppointment == "C" {
            
            /* patient details cell , hospital cell, history details , payment details
             
             upcoming = 4 or 3
             requested,completed = 3 or 2
             
             */
            
            if indexPath.row == 2 {
                let strofStatus = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey:getDoctorAppointments.APIResponse.paymentStatus))
                
                if strofStatus == "1" {
                    return getPaymentCell()
                }else{
                    return getActionsCell()
                }
            }
            
        }
        
        return UITableViewCell()
        
    }
    
    
    
    
}

extension AppointmentDetailsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout


{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppDetActionCollectionViewCell", for: indexPath) as! AppDetActionCollectionViewCell
        
        cell.lblOfTitle.text = arrOfCollection[indexPath.row]
        cell.imgOfActionCollec.image = UIImage.init(named: arrOfCollImages[indexPath.row] as! String)
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width/4), height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        callActionAsperIndex(indexPath.row)
        
    }
    
    func calltoUpdateAppointmentStatusAPIReqiest(){
        
        
        let strogBookingREf = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingRef))
        
        
     //   APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      updateDocBooking.APIRequest.bookingRef : strogBookingREf,
                                      updateDocBooking.APIRequest.bookingStatus : "3"]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.updateDocBooking, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //   print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                if let delegateObj = self.delegate {
                    delegateObj.cancelClicked()
                    
                    self.navigationController?.popViewController(animated: true)
                }
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
//
//                if messag == NetworkErrorIssue{
//                    OopsVC.errorType = NetworkError
//                }
//                self.present(OopsVC, animated: true, completion: nil)
//            }
        }
    }
    
    
    
    func updateAppointmentStatusAPIReqiest(_ action : String){
        
        
        let strogBookingREf = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingRef))
        
        var apiMedthode : String!
        
        if action == CheckIn {
            apiMedthode = APIMethods.checkInAppointment
        }
        else if action == Checkout {
            apiMedthode = APIMethods.checkOutAppointment
        }
        
    //    APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
         self.showLoader()
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey,
                                      APIRequestKeys.userRef : UserDefaultStore.userRef,
                                      checkInAppointment.APIRequest.bookingRef : strogBookingREf]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: apiMedthode, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            //  print(response)
            
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True || String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == " true"{
                
                if action == CheckIn {
                    
                    //                    if let delegateObj = self.delegate {
                    //                        delegateObj.checkinClicked()
                    //                    }
                    self.arrOfCollection = [Checkout,Call,Cancel]
                    self.arrOfCollImages = ["CheckOut","Call","Cancel_1"]
                    self.appointmentDetiTableView.reloadData()
                }
                else
                {
                    if let delegateObj = self.delegate {
                        delegateObj.checkoutClicked()
                    }
                    self.navigationController?.popViewController(animated: true)
                }
                
                
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
//
//                if messag == NetworkErrorIssue{
//                    OopsVC.errorType = NetworkError
//                }
//                self.present(OopsVC, animated: true, completion: nil)
//            }
        }
    }
    
    
    
    
    
    func callActionAsperIndex(_ selectedIndex : Int) {
        
        if arrOfCollection[selectedIndex] == CheckIn {
            
            
            updateAppointmentStatusAPIReqiest(CheckIn)
            
            
            //            if let delegateObj = self.delegate {
            //                delegateObj.checkinClicked()
            //            }
            //
            //            self.navigationController?.popViewController(animated: true)
            
            
        }
        else if arrOfCollection[selectedIndex] == Checkout {
            
            updateAppointmentStatusAPIReqiest(Checkout)
            
        }
        else if arrOfCollection[selectedIndex] == Call {
            
            let strofBookingType = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingType))
            
            var calltoPatiennumber : String!
            
            if strofBookingType == "1" {
                
                 let mobilePrefix : String = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey:getDoctorAppointments.APIResponse.mobilePrefix))
                
                 let mobileNumber : String = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey:getDoctorAppointments.APIResponse.patmobileNumber))
                
                 calltoPatiennumber = mobilePrefix + mobileNumber
            }else{
                
                let mobilePrefix : String = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey:getDoctorAppointments.APIResponse.mobilePrefix))
                let mobileNumber : String = String(describing:selectedAppointment.TabiibDocObjectForKey(forKey:getDoctorAppointments.APIResponse.bkPatientMobileNumber))
                calltoPatiennumber = mobilePrefix + mobileNumber
                
            }
            
            calltoPatiennumber = calltoPatiennumber?.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
            
            guard let number = URL(string: "telprompt://" + calltoPatiennumber!) else { return }
            //            if #available(iOS 10.0, *) {
            UIApplication.shared.open(number, options: [:], completionHandler: { (opend) in
                if opend {
                    
                    
                }
            })
            
        }
        else if arrOfCollection[selectedIndex] == Cancel
        {
            
            _ =  SweetAlerts().showAlert2(NSLocalizedString("Are you sure want to Cancel Appointment?", comment: ""), style: .none, buttonTitle: NSLocalizedString("Yes", comment: ""), buttonColor: Constatns.ThemeColour(), otherButtonTitle: NSLocalizedString("No", comment: ""), otherbuttonColor: UIColor.lightGray, action: { (clciked) in
                self.calltoUpdateAppointmentStatusAPIReqiest()
                
            }, action2: { (clicekd) in
                
            })
            
            
        }
        
        
    }
    
}
