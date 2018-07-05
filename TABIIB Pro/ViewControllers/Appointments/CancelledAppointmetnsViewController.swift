//
//  CancelledAppointmetnsViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

public protocol CancelledAppointLoadmoreDelegate {
    func loadMoreCancelAppoiDelegate()
    func reloadcanceldAllAppointmetns()
}



class CancelledAppointmetnsViewController: UIViewController,CancelledAppointLoadmoreDelegate {
    
    func loadMoreCancelAppoiDelegate(){
        
    }
    
    func reloadcanceldAllAppointmetns(){
        
    }
    
    @IBOutlet var tbofAppointmetns: UITableView!
    
    var dictofApiResponse : NSDictionary!
    
    var arrofAppointments : NSMutableArray!
    var canceledCoreDataArr : NSMutableArray!
    var isFromCoreData : Bool = false
    
    var refreshControl: UIRefreshControl!
    
    var totalNoofRecords : Int!
    
    var delegate : CancelledAppointLoadmoreDelegate!
    @IBOutlet var viewofNoAppointments : UIView!
    
    var isRequestisgoingon : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrofAppointments = NSMutableArray.init()
        canceledCoreDataArr = NSMutableArray.init()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        tbofAppointmetns.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        
        refreshControl.beginRefreshing()
        if let delegateObj = self.delegate {
            delegateObj.reloadcanceldAllAppointmetns()
        }
        
    }
    
    
    
    func loadRemainingMore(_ arrofResponseApponits : NSArray){
        
        isRequestisgoingon = false
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        if arrofAppointments.count > 0 {
            arrofAppointments.addObjects(from: arrofResponseApponits as! [Any])
            tbofAppointmetns.reloadData()
        }else{
            viewofNoAppointments.isHidden = false
            tbofAppointmetns.isHidden = true
        }
        
    }
    
    
    func reloadCoreDataObjects()  {
         isFromCoreData = true
        if  canceledCoreDataArr.count > 0 {
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
            viewofNoAppointments.isHidden = false
            tbofAppointmetns.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CancelledAppointmetnsViewController : UITableViewDataSource,UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromCoreData {
            return canceledCoreDataArr.count
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
            let appointObj = canceledCoreDataArr[indexPath.row] as! Appointments
            let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with:appointObj.appointmentData!)
            dicofAppointment = unarchiveObject  as! NSDictionary
        } else {
            dicofAppointment = arrofAppointments[indexPath.row] as! NSDictionary
        }
        
        
        //let dicofAppointment = arrofAppointments[indexPath.row] as! NSDictionary
        
        appointCell.lblofClinicName.text = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.hospitalName))
        
        appointCell.lblofReason.text = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.reason))
        
        let strOfDate : String = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookOn))
        appointCell.lblofRequestedDate.text = strOfDate.getDateFormate()
        
        let appointmentDate = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingDate))
        
        let arrofDate = appointmentDate.components(separatedBy: "-")
        if arrofDate.count > 0 {
            appointCell.lblofDate.text = arrofDate.last
        }
        
        //        let startSlot =  String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.startBookingSlot))
        //        let arrOfStartSLot = startSlot.components(separatedBy: " ")
        //        if arrOfStartSLot.count > 0{
        //            let startSlotTime = arrOfStartSLot[0]
        //             appointCell.lbloftime.text =  startSlotTime + "-" + String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.endBookingSlot))
        //
        //        }
        
        appointCell.lbloftime.text = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.startBookingSlot)) + " - " + String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.endBookingSlot))
        
        if String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingThrough)) != "Web" {
            appointCell.imgofappointType.image = UIImage.init(named: "Mobile")
        }else{
            appointCell.imgofappointType.image = UIImage.init(named: "Web")
            
        }
        
        
        appointCell.lblofDay.text = appointmentDate.getDayOfWeek()
        
        appointCell.lblofPatientName.text = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bkPatientName))
        
        
        if String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.status)) == "Rejected"{
            //System
            if String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookingDeclinedBy)) == "System" {
                appointCell.lblofFollowup.text = NSLocalizedString("By TABIIB", comment: "")
            }else{
                appointCell.lblofFollowup.text = NSLocalizedString("By you", comment: "")
            }
        }else if String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.status)) == "Canceled"{
            appointCell.lblofFollowup.text = NSLocalizedString("Patient", comment: "")
        } else{
            appointCell.lblofFollowup.text = NSLocalizedString("New", comment: "")
        }
        
        
        appointCell.lblofMonth.text = appointmentDate.getMonthFormate()
        
        //  appointCell.lblofRequestedDate.text = String(describing:dicofAppointment.TabiibDocObjectForKey(forKey: getDoctorAppointments.APIResponse.bookOn))
        
        
        //        appointCell.delegate = self
        
        appointCell.selectionStyle = .none
        
        return appointCell
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if isRequestisgoingon == false {
                 if Connectivity.isCheckForNewwork() == true {
                if arrofAppointments.count < totalNoofRecords {
                    if let delegateObj = self.delegate {
                        isRequestisgoingon = true
                        delegateObj.loadMoreCancelAppoiDelegate()
                        
                    }
                }
                }
            }
        }
        
    }
    
    
    
    
}


