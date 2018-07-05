//
//  BankAccountsViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class BankAccountsViewController: UIViewController {
    
    @IBOutlet weak var bankAccTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnAction(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addBankAccountBtnTapped(_ sender : Any){
        
        let newBankAcc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "AddBankDetailsViewController") as! AddBankDetailsViewController
        
        self.navigationController?.pushViewController(newBankAcc, animated: true)
        
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

extension BankAccountsViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankAccountTableViewCell", for: indexPath) as! BankAccountTableViewCell
        
        cell.lblOfName.text = "smsc"
        cell.lblOfBranch.text = "kondapur"
        cell.lblOfBankName.text = "SBi"
        cell.lblOfAccountType.text = "savings"
        cell.lblOfAccountNumber.text = "123456"
        cell.lblOfAccountActivationDate.text = "Active - Added on 3 Jan 2018"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 220
        } else {
            return 270
        }
      //  return 220
    }
    
}

