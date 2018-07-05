//
//  PaymentsViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class PaymentsViewController: CommonViewController {
    
    @IBOutlet weak var paymentTableView : UITableView!
    
    var arrOfPayMentDetails : NSMutableArray!
    var isRequestgoing : Bool = false
    var totalNoofEvents : Int! = 0
     var noofPages : Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrOfPayMentDetails = NSMutableArray()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        self.arrOfPayMentDetails.removeAllObjects()

        noofPages = 0
        getMyPaymentsAPI()
    
    }
    
    @IBAction func backBtnAction(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func getMyPaymentsAPI(){
        
     
        self.showActivityIndicator()
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey, APIRequestKeys.userRef : UserDefaultStore.userRef,                                   doctorPaymentList.APIRequest.page : String(noofPages)]
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.doctorPaymentList, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
          
          
            print(response)
            
            self.hideActivityIndicator()
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                /*
 data =     (
 {
 amount = 800;
 bookingRef = 1B3YbNyQMEfJK6Qs;
 currency = BHD;
 disease = "";
 docUserRef = olFEaUQjganslXGF;
 doctorUserRef = o87UpL9ZPHwpEnWV;
 emailId = "<null>";
 mobileNumber = "<null>";
 mobilePrefix = 91;
 patGender = male;
 patName = "<null>";
 patUserRef = o87UpL9ZPHwpEnWV;
 paymentDateTime = "2018-04-26 07:45:09";
 paymentStatus = 1;
 }
 );
 success = true;
 "success_message" = "Payment list get successfully.";
 totalRecords = 1;
*/
                let strofTotleRecords = String(describing:dictofResonse.TabiibDocObjectForKey(forKey: doctorPaymentList.APIResponse.totalRecords))
                
                self.totalNoofEvents = Int(strofTotleRecords)!
                
                let arrodPaymentData = dictofResonse.object(forKey: getDoctorAppointments.APIResponse.data) as! NSArray


                if self.arrOfPayMentDetails.count == 0{
                    self.arrOfPayMentDetails.addObjects(from: arrodPaymentData as! [Any])
                }else{
                    self.arrOfPayMentDetails.addObjects(from: arrodPaymentData as! [Any])
                }
                
                if self.arrOfPayMentDetails.count > 0{
                    self.paymentTableView.reloadData()
                }else{
                    
                }
                
             
                
            }
            else{
                Utilities.sharedInstace.showAlertviewWithMessage(String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.error_message)))
            }
            
            
        }){ (networkErr,messag)  in
            
            APIServices.SharedInstance.hideProgress()
            
            if messag == unauthorised {
                
                let unauth = NSLocalizedString("UnAuthorisedUser", comment: "")
                
                let objofSweetAlrt = SweetAlerts()
                objofSweetAlrt.isTapGestureReg = false
                _ =  objofSweetAlrt.showAlert(unauth, style: .none, buttonTitle: NSLocalizedString("Okay", comment: ""), action: { (okay) in
                    objofSweetAlrt.isTapGestureReg = false
                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    UserDefaultStore.isLogined = "0"
                    self.navigationController?.pushViewController(loginVC, animated: true)
                    
                })
            }
            if messag == NetworkErrorIssue {
                
                let OopsVC = self.storyboard?.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
                OopsVC.errorType = NetworkError
                self.navigationController?.pushViewController(OopsVC, animated: true)
            }
            
            if messag == geterror{
                let OopsVC = self.storyboard?.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
                self.navigationController?.pushViewController(OopsVC, animated: true)
            }
            
        }
        
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if isRequestgoing == false {
                if arrOfPayMentDetails.count < totalNoofEvents {
                    noofPages = noofPages + 1
                    getMyPaymentsAPI()
                }
            }
        }
        
    }
    
    func reloadAPICall() {
        
        self.dismiss(animated: true, completion: nil)
        
        noofPages = 0
        getMyPaymentsAPI()
        
        
    }
    
}

extension PaymentsViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfPayMentDetails.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentsTableViewCell", for: indexPath) as! PaymentsTableViewCell
        
        let dictofPayments = arrOfPayMentDetails[indexPath.row] as! NSDictionary
        
        cell.lblOfPatientName.text = String(describing:dictofPayments.TabiibDocObjectForKey(forKey: doctorPaymentList.APIResponse.patName))
        cell.lblOfPaymentStatus.text = String(describing:dictofPayments.TabiibDocObjectForKey(forKey: doctorPaymentList.APIResponse.paymentStatus))
        cell.lblOfPaidDate.text = String(describing:dictofPayments.TabiibDocObjectForKey(forKey: doctorPaymentList.APIResponse.paymentDateTime))
        cell.lblOfAmount.text = String(describing:dictofPayments.TabiibDocObjectForKey(forKey: doctorPaymentList.APIResponse.amount))
        cell.lblOfCurrency.text = String(describing:dictofPayments.TabiibDocObjectForKey(forKey: doctorPaymentList.APIResponse.currency))
        cell.lblOfPaymentType.text = "online"
        cell.lblOfTransactionID.text = "asas"
        cell.lblOfAppointmentID.text = "Appointment ID- 123456"
         cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 220
        } else {
            return 270
        }
       // return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appointDetailsVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "BankAccountsViewController") as! BankAccountsViewController
        self.navigationController?.pushViewController(appointDetailsVC, animated: true)
    }
    
}


