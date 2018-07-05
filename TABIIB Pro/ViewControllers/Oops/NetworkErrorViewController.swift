//
//  NetworkErrorViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
let NetworkError = "Network"

protocol ErrorProtocalDelegate  {
    func reloadAPICall()
}

class NetworkErrorViewController: UIViewController {
    
    
    func reloadAPICall() {
        
    }
    
    let strIdent : String! = nil
    
    var singObj : SingleTonClass!
    
    @IBOutlet var viewofNetWorkError : UIView!
    @IBOutlet var viewofServerError: UIView!
    
    var errorType : String! = ""
    
    var errorDelegate : ErrorProtocalDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singObj = SingleTonClass.SharedInstance
        
        if errorType == NetworkError {
            viewofServerError.isHidden = true
            viewofNetWorkError.isHidden = false
        }else{
            viewofServerError.isHidden = false
            viewofNetWorkError.isHidden = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    @IBAction func btnBackclicked(_ sender : UIButton) {
    //        self.navigationController?.popViewController(animated: true)
    //    }
    
    @IBAction func btnOfReload(_ sender : Any){
        
        if let delegateObj  = self.errorDelegate {
            delegateObj.reloadAPICall()
        }
        
        
        // self.dismissofErrorVc()
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

