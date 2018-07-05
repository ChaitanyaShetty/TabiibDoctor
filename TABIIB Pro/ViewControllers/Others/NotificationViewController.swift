//
//  NotificationViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController,ErrorProtocalDelegate {
    
    @IBOutlet weak var tbofNotifications: UITableView!
    
    var noofPages : Int! = 0
    var totalNoofDoctors : Int! = 0
    var isRequestgoing : Bool = false
    
    var arrofNotifications : NSMutableArray!
    
    @IBOutlet var viewOfNoNotif : UIView!
    var isError : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrofNotifications = NSMutableArray.init()
        viewOfNoNotif.isHidden = true
        // Do any additional setup after loading the view.
        getNotificationListAPIReqiest()
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    func getNotificationListAPIReqiest(){
        
        
        isRequestgoing = true
     //   APIServices.SharedInstance.MbProgress(view: self.view, Message: APIServiceLoading.Loading)
        self.showLoader()
        
        let param : [String : Any] = [APIRequestKeys.ApiKey : UserDefaultStore.ApiKey, APIRequestKeys.userRef : UserDefaultStore.userRef,updateNotificationStatus.APIRequest.page : "",updateNotificationStatus.APIRequest.userType : userType]
        
        
        APIServices.SharedInstance.callApiResponse(MethodName: APIMethods.updateNotificationStatus, RequestType: Constatns.HTTP_REQUEST_POST, postString: "", isQueryString: false, parameters: param, success: { (response) in
            
            APIServices.SharedInstance.hideProgress()
            
            // print(response)
            
            
            self.isRequestgoing = false
            
            let dictofResonse = response as! NSDictionary
            
            if String(describing:dictofResonse.TabiibDocObjectForKey(forKey: APICommResponse.success)) == APICommResponse.True {
                
                self.totalNoofDoctors = Int(String(describing:dictofResonse.TabiibDocObjectForKey(forKey: updateNotificationStatus.APIResponse.totalRecords)))
                
                let arrofResponsedata = dictofResonse.object(forKey: updateNotificationStatus.APIResponse.data) as! NSArray
                
                if arrofResponsedata.count > 0 {
                    self.viewOfNoNotif.isHidden = true
                    self.arrofNotifications.addObjects(from: arrofResponsedata as! [Any])
                    self.tbofNotifications.reloadData()
                }else{
                    self.viewOfNoNotif.isHidden = false
                }
            }
            else{
                
                Utilities.sharedInstace.showAlertviewWithMessage("Error from server")
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
        
        getNotificationListAPIReqiest()
        
    }
    
    
    @IBAction func btnBackClicked(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
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

extension NotificationViewController : UITableViewDelegate,UITableViewDataSource


{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrofNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let notifiCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        
        let dicrtifNotif = arrofNotifications[indexPath.row] as! NSDictionary
        
        notifiCell.lblofNotification.text = String(dicrtifNotif.TabiibDocObjectForKey(forKey: updateNotificationStatus.APIResponse.notificationMessage))
        
        
        notifiCell.selectionStyle = .none
        return notifiCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if isRequestgoing == false {
                if arrofNotifications.count < totalNoofDoctors {
                    noofPages = noofPages + 1
                    getNotificationListAPIReqiest()
                }
            }
        }
        
    }
    
    
    
}
