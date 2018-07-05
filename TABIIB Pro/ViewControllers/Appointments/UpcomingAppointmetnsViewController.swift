//
//  UpcomingAppointmetnsViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

public protocol UpcomingAppointmentDelegate {
    func loadMoreUpcomingAppointDelegate()
    func reloadupcomingAllAppointmetns()
}



class UpcomingAppointmetnsViewController: UIViewController,UpcomingAppointmentDelegate {
    
    func loadMoreUpcomingAppointDelegate() {
        
    }
    func reloadupcomingAllAppointmetns(){
        
    }
    
    @IBOutlet var tbofAppointmetns: UITableView!
    
    var dictofApiResponse : NSDictionary!
    
    var arrofAppointments : NSMutableArray!
    var upcomingCoreDataArr : NSMutableArray!
    var isFromCoreData : Bool = false
    
    var totalNoofRecords : Int!
    
    var selectedIndex : IndexPath!
    
    var delegate : UpcomingAppointmentDelegate!
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var viewofNoAppointments : UIView!
    
    var isRequestisgoingon : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        arrofAppointments = NSMutableArray.init()
        upcomingCoreDataArr = NSMutableArray.init()
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string:NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        tbofAppointmetns.addSubview(refreshControl)
        viewofNoAppointments.isHidden = true
    }
    
    @objc func refresh(sender:AnyObject) {
        
        refreshControl.beginRefreshing()
        if let delegateObj = self.delegate {
            delegateObj.reloadupcomingAllAppointmetns()
        }
        
    }
    
    func loadRemainingMore(_ arrofResponseApponits : NSArray){
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        
        isRequestisgoingon = false
        
        if arrofAppointments.count > 0 {
            arrofAppointments.addObjects(from: arrofResponseApponits as! [Any])
            tbofAppointmetns.reloadData()
        }else{
            tbofAppointmetns.isHidden = true
            viewofNoAppointments.isHidden = false
        }
        
        
    }
    
    func reloadCoreDataObjects()  {
        isFromCoreData = true
        if  upcomingCoreDataArr.count > 0 {
            self.tbofAppointmetns.isHidden = false
            self.viewofNoAppointments.isHidden = true
            self.tbofAppointmetns.reloadData()
        } else {
            self.tbofAppointmetns.isHidden = true
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
        
        if arrofAppointments.count > 0 {
            tbofAppointmetns.isHidden = false
            tbofAppointmetns.reloadData()
            viewofNoAppointments.isHidden = true
        }else{
            tbofAppointmetns.isHidden = true
            viewofNoAppointments.isHidden = false
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


extension UpcomingAppointmetnsViewController : AppoinmentActionDelegate

{
    
    
    func updateAppointmentList() {
        
        refreshControl.beginRefreshing()
        if let delegateObj = self.delegate {
            delegateObj.reloadupcomingAllAppointmetns()
        }
        
        //        self.arrofAppointments.removeObject(at:selectedIndex.row)
        //        self.tbofAppointmetns.beginUpdates()
        //        self.tbofAppointmetns.deleteRows(at: [selectedIndex], with: UITableViewRowAnimation.left)
        //        self.tbofAppointmetns.endUpdates()
    }
    
    
    func cancelClicked() {
        updateAppointmentList()
    }
    
    func checkoutClicked() {
        updateAppointmentList()
    }
    
    func checkinClicked() {
        updateAppointmentList()
    }
    
}


extension UpcomingAppointmetnsViewController : UITableViewDataSource,UITableViewDelegate

{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromCoreData {
            return upcomingCoreDataArr.count
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
        
        let appointCell =  tableView.dequeueReusableCell(withIdentifier: "AppointmentsTableViewCell", for: indexPath) as! AppointmentsTableViewCell
        
        var dicofAppointment = NSDictionary.init()
        if isFromCoreData {
            let appointObj = upcomingCoreDataArr[indexPath.row] as! Appointments
            let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:appointObj.appointmentData!)
            dicofAppointment = unarchiveObject  as! NSDictionary
        } else {
            dicofAppointment = arrofAppointments[indexPath.row] as! NSDictionary
        }
        
        //let dicofAppointment = arrofAppointments[indexPath.row] as! NSDictionary
        
        appointCell.lblofClinicName.text = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.hospitalName))
        
        appointCell.lblofReason.text = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.reason))
        
        let appointmentDate = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingDate))
        
        let strOfDate : String = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookOn))
        appointCell.lblofRequestedDate.text = strOfDate.getDateFormate()
        
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
        
        if String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingThrough)) != "Web" {
            appointCell.imgofappointType.image = UIImage.init(named: "Mobile")
        }else{
            appointCell.imgofappointType.image = UIImage.init(named: "Web")
            
        }
        
        
        appointCell.lblofDay.text = appointmentDate.getDayOfWeek()
        appointCell.lblofMonth.text = appointmentDate.getMonthFormate()
        
        appointCell.lblofPatientName.text = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bkPatientName))
        appointCell.lblofFollowup.text = NSLocalizedString("New", comment: "")
        
        //        appointCell.lblofRequestedDate.text = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookOn))
        
        //appointCell.viewOfCornerAndShadow.dropShadow(color: UIColor.orange, opacity:  0.5, offSet: CGSize(width: -1, height: 1), radius:  1, scale: true)
        
        appointCell.selectionStyle = .none
        
        return appointCell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var dicofAppointment = NSDictionary.init()
        if isFromCoreData {
            let appointObj = upcomingCoreDataArr[indexPath.row] as! Appointments
            let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:appointObj.appointmentData!)
            dicofAppointment = unarchiveObject  as! NSDictionary
        } else {
            dicofAppointment = arrofAppointments[indexPath.row] as! NSDictionary
        }
      //  let dicofAppointment = arrofAppointments[indexPath.row] as! NSDictionary
        //  print("in details")
        
        selectedIndex = indexPath
        
        let appointDetailsVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "AppointmentDetailsViewController") as! AppointmentDetailsViewController
        appointDetailsVC.typeofAppointment = "U"
        appointDetailsVC.delegate = self
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
                        delegateObj.loadMoreUpcomingAppointDelegate()
                    }
                }
            }
            }
        }
        
    }
    
    
}



