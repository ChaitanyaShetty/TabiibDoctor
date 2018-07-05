//
//  AddClinicsViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class AddClinicsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
    }
    
    @IBAction func backBtnAction(_ sender : Any){
        //         self.backBtnAction()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func addClinicBtnAction(_ sender : Any){
        
        let clinincAddVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "ClinicAddingViewController") as! ClinicAddingViewController
        self.navigationController?.pushViewController(clinincAddVC, animated: true)
    }
    
    
    @IBAction func existingClinicBtnAction(_ sender : Any){
        
        let existingClinicVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "SearchFilterViewController") as! SearchFilterViewController
        
        self.navigationController?.pushViewController(existingClinicVC, animated: true)
        
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
