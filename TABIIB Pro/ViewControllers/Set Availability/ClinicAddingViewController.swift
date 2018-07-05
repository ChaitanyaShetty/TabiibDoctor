//
//  ClinicAddingViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class ClinicAddingViewController: UIViewController {
    
    @IBOutlet var lblofClinicInfoSelected: UILabel!
    @IBOutlet var lblofAvailabletimeSelected: UILabel!
    
    @IBOutlet var viewofClinincInformation: UIView!
    @IBOutlet var viewofDocSetAvailability: UIView!
    
    @IBOutlet var btnOfClinicInfo : UIButton!
    @IBOutlet var btnOfAvailableTime : UIButton!
    
    var clinicInfoVc : ClinicInformationViewController!
    var setAvailibilityVc : DoctorSetAvailabilityTimingsViewController!
    
    var isFromExisting : Bool = false
    var dicotfClinincTimings : NSDictionary!
    
    var isClinincAddToDoctor : Bool = false
    var strClinincReference : String!
    
    var singObj : SingleTonClass!
    
    var isFromSearchclininc : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        singObj = SingleTonClass.SharedInstance
        singObj.singIdentifier = "ClinicAddingViewController"
        
        
        //by default clinic info is visible
        
        viewofClinincInformation.isHidden = false
        viewofDocSetAvailability.isHidden = true
        lblofClinicInfoSelected.isHidden = false
        lblofAvailabletimeSelected.isHidden = true
        
        switchView(0)
        
        if isFromExisting == true {
            strClinincReference = String(describing:dicotfClinincTimings.TabiibDocObjectForKey(forKey: getClinicinfo.APIResponse.hospRef))
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    func switchView(_ index : Int){
        switch index {
        case 0:
            //move personal to education
            UIView.animate(withDuration: 0.5) {
                
                self.viewofClinincInformation.frame = CGRect(x:-self.view.frame.width, y: self.viewofClinincInformation.frame.origin.y, width: self.viewofClinincInformation.frame.width, height: self.viewofClinincInformation.frame.height)
                
                self.viewofClinincInformation.frame = CGRect(x: 0, y: self.viewofClinincInformation.frame.origin.y, width: self.viewofClinincInformation.frame.width, height: self.viewofClinincInformation.frame.height)
                
                
            }
            
            viewofClinincInformation.isHidden = false
            viewofDocSetAvailability.isHidden = true
            
            
            lblofClinicInfoSelected.isHidden = false
            lblofAvailabletimeSelected.isHidden = true
            
            
            if isFromExisting {
                clinicInfoVc.userInteractionmethods()
                //clinicInfoVc.isfromExistingBoolValue = true
                clinicInfoVc.dicotfClinincTimings = self.dicotfClinincTimings
                clinicInfoVc.isFromExistingOne = true
                clinicInfoVc.bindClinicData()
            }
            else{
                clinicInfoVc.loadPrefix()
            }
            
            break
            
        case 1:
            
            //move personal to education
            UIView.animate(withDuration: 0.5) {
                
                self.viewofDocSetAvailability.frame = CGRect(x: self.view.frame.width, y: self.viewofDocSetAvailability.frame.origin.y, width: self.viewofDocSetAvailability.frame.width, height: self.viewofDocSetAvailability.frame.height)
                
                self.viewofDocSetAvailability.frame = CGRect(x: 0, y: self.viewofDocSetAvailability.frame.origin.y, width: self.viewofDocSetAvailability.frame.width, height: self.viewofDocSetAvailability.frame.height)
                
                
            }
            
            viewofClinincInformation.isHidden = true
            viewofDocSetAvailability.isHidden = false
            
            lblofClinicInfoSelected.isHidden = true
            lblofAvailabletimeSelected.isHidden = false
            
            
            setAvailibilityVc.selectedclinicRef = self.strClinincReference
            
            if isFromExisting {
                 setAvailibilityVc.isexistingFromAvailTimngs = true
                setAvailibilityVc.isFromExisting = true
                if isFromSearchclininc == true {
                    setAvailibilityVc.dicotfClinincTimings = self.dicotfClinincTimings
                    setAvailibilityVc.loadBindData()
                    setAvailibilityVc.loadSearchClinincData()
                }else{
                    setAvailibilityVc.dicotfClinincTimings = self.dicotfClinincTimings
                    setAvailibilityVc.loadBindData()
                     setAvailibilityVc.loadSearchClinincData()
                }
            }else {
                  setAvailibilityVc.ClinicInfoTimingData()
            }
            
            
            break
            
        default:
            break
        }
    }
    
    @IBAction func btnBackClicked(_ sender : Any) {
        
        //         self.backBtnAction()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnClinicInfoClicked(_ sender: Any) {
        
        switchView(0)
        
        btnOfClinicInfo.setTitleColor(UIColor.white, for: .normal)
        btnOfAvailableTime.setTitleColor(Constatns.AppointmentColour(), for: .normal)
        
        
        
    }
    
    
    @IBAction func btnSetAvailabilityClicked(_ sender: Any) {
        if isFromExisting {
            switchView(1)
        }else{
            if isClinincAddToDoctor {
                switchView(1)
            }
        }
        
        
        btnOfAvailableTime.setTitleColor(UIColor.white, for: .normal)
        btnOfClinicInfo.setTitleColor(Constatns.AppointmentColour(), for: .normal)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ClinicInformationViewController" {
            self.clinicInfoVc = segue.destination as! ClinicInformationViewController
            self.clinicInfoVc.delegate = self
        }
        else if segue.identifier == "DoctorSetAvailabilityTimingsViewController" {
            self.setAvailibilityVc = segue.destination as! DoctorSetAvailabilityTimingsViewController
            self.setAvailibilityVc.delegate = self
            //nwewnew ew commegtn
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

extension ClinicAddingViewController : ClininInfoUpdateDelegate {
    
    //    func proccedClicked(_ hospitalRef: String) {
    //
    //
    //        strClinincReference = hospitalRef
    //        isClinincAddToDoctor = true
    //        switchView(1)
    //
    //
    //
    //    }
    
    func proccedClicked(_ dictOfClinicInfo: NSDictionary) {
        strClinincReference = String(describing:dictOfClinicInfo.TabiibDocObjectForKey(forKey: AddClinicBasicProfile.APIResponse.hospRef))
        if strClinincReference == "" {
            strClinincReference = String(describing:dictOfClinicInfo.TabiibDocObjectForKey(forKey: AddClinicBasicProfile.APIResponse.hospitalUserRef))
        }
        isClinincAddToDoctor = true
        setAvailibilityVc.dictOfClinicInfo = dictOfClinicInfo
        switchView(1)
    }
    
    func backtoAddclinc() {
        switchView(1)
    }
    
}


extension ClinicAddingViewController : DoctorAvailabilityUpdateDelegate {
    
    func submitClicked() {
        //  print("submit")
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is HomeViewController {
                self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }
        
        
        //            let homeVc  = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        //            self.navigationController?.popToViewController(homeVc, animated: true)
        
    }
}

