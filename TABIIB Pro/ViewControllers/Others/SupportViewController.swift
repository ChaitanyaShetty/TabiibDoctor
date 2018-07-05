//
//  SupportViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import MessageUI


class SupportViewController: UIViewController,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var supportCollectionView : UICollectionView!
    
    var arrOfSupportImages = NSMutableArray()
    var arrOfSupportTxt = NSMutableArray()
    
    var  strofAppVerison  = "1.0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            strofAppVerison  = version
        }
        
        let keyOfdic1 = NSLocalizedString("FAQ’s", comment: "")
        let keyOfdic2 = NSLocalizedString("Privacy Policy", comment: "")
        let keyOfdic3 = NSLocalizedString("T & C", comment: "")
        let keyOfdic4 = NSLocalizedString("About us", comment: "")
        let keyOfdic5 = NSLocalizedString("Rate us", comment: "")
        let keyOfdic6 = NSLocalizedString("Email us", comment: "")
        let keyOfdic7 = NSLocalizedString("Contact us", comment: "")
        
        arrOfSupportTxt = [keyOfdic1,keyOfdic2,keyOfdic3,keyOfdic4,keyOfdic5,keyOfdic6,keyOfdic7]
        
        arrOfSupportImages = ["Faqs","Privacy","TAndC","AboutUs","RateUs","EmailUs","ContactUs"]
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnAction(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
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

extension SupportViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfSupportTxt.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SupportCollectionViewCell", for: indexPath) as! SupportCollectionViewCell
        
        cell.imgOfSupportCell.image = UIImage.init(named: arrOfSupportImages[indexPath.row] as! String)
        cell.lblOfSupporttxt.text = arrOfSupportTxt[indexPath.row] as? String
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
               return CGSize(width: (self.view.frame.size.width/2), height: 120)
          }
        else if UIDevice.current.userInterfaceIdiom == .pad {
            
            return CGSize(width: (self.view.frame.size.width/3)+80, height: (self.view.frame.size.width/2)-100)
            
        }
        
        return CGSize(width: (self.view.frame.size.width/2), height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
        }
        else if UIDevice.current.userInterfaceIdiom == .pad {
            return UIEdgeInsets(top: 36, left:36, bottom: 36, right:36)
        }
        
        return UIEdgeInsets(top: 16, left:16, bottom: 16, right: 16)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
           return 0
        }
        else if UIDevice.current.userInterfaceIdiom == .pad {
            return 20
        }
        return 0
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            //faq's
            let loadVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LoadWebViewController") as! LoadWebViewController
            loadVc.viewtoLoad = "1"
            self.navigationController?.pushViewController(loadVc, animated: true)
        }
        else if indexPath.row == 1 {
            //Privacy
            let loadVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LoadWebViewController") as! LoadWebViewController
            loadVc.viewtoLoad = "2"
            self.navigationController?.pushViewController(loadVc, animated: true)
        }
        else if indexPath.row == 2 {
            //terms cond
            let loadVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LoadWebViewController") as! LoadWebViewController
            loadVc.viewtoLoad = "3"
            self.navigationController?.pushViewController(loadVc, animated: true)
        }
        else if indexPath.row == 3 {
            //about us
            let loadVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LoadWebViewController") as! LoadWebViewController
            loadVc.viewtoLoad = "4"
            self.navigationController?.pushViewController(loadVc, animated: true)
        }
        else if indexPath.row == 4 {
            //rate of app
            //for testing
            rateApp(appId: "1360992776", completion: { (clciked) in
                print("rate of app")
            })
            
        }
        else if indexPath.row == 5 {
            //email us
            composeEmailForContact()
        }
        else if indexPath.row == 6 {
            //contact us
            //for testing
            // var missedCallNumber = UserDefaultStore.ContactNumber!
            var missedCallNumber = UserDefaultStore.contact_Mobileno
            if missedCallNumber != "" {
                missedCallNumber = missedCallNumber?.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
                guard let number = URL(string: "telprompt://" + missedCallNumber!) else { return }
                UIApplication.shared.open(number, options: [:], completionHandler: { (opend) in
                    if opend {
                        
                    }
                })
            }
        }
        
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return 0
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return 20
    //    }
    
    func composeEmailForContact(){
        
        //check mail is composed or not
        
        
        
        if !MFMailComposeViewController.canSendMail() {
            
            var strofBody = ""
            
            if UserDefaultStore.isLogined == "1" {
                strofBody = String.init(format: "Email : %@ \n PhoneNumber : %@ \n\n\n App version : %@", UserDefaultStore.emailId!,UserDefaultStore.mobileNumber!,strofAppVerison)
            }else{
                strofBody = String.init(format: "App version : %@",strofAppVerison)
            }
            
            let finalUrlbody : String! = strofBody.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            
            let strofSubejct : String = "Tabiib Doctor iOS App"
            
            let finalSub :String! = strofSubejct.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            //for testing
            // let strofToEmail : String = UserDefaultStore.ContactEmail
            let strofToEmail : String = UserDefaultStore.contact_EmailID
            
            let finlaUrl : String! = strofToEmail.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            
            
            let googleUrlString = String.init(format: "googlegmail:///co?subject=%@&body=%@&to=%@",finalSub,finalUrlbody,finlaUrl)
            
            if let googleUrl = NSURL(string: googleUrlString) {
                if UIApplication.shared.canOpenURL(googleUrl as URL) {
                    UIApplication.shared.open(googleUrl as URL, options: [:], completionHandler: nil)
                }
                else{
                    Utilities.sharedInstace.showAlertviewWithMessage("Configure Email in your device")
                    
                }
            }
        }
        else{
            
            let composeVC = MFMailComposeViewController()
            composeVC.setSubject("Tabiib Doctor iOS App")
            composeVC.mailComposeDelegate = self
            //for testing
            // let strofToEmail : String = UserDefaultStore.ContactEmail
            let strofToEmail : String = UserDefaultStore.contact_EmailID
            //            composeVC.setToRecipients([UserdefaultsStored.SupportedEmailIdforQue!])
            composeVC.setToRecipients([strofToEmail])
            var strofMsgBody = ""
            
            
            if UserDefaultStore.isLogined == "1" {
                strofMsgBody = String.init(format: "Email : %@ \n PhoneNumber : %@ \n\n\n App version : %@", UserDefaultStore.emailId!,UserDefaultStore.mobileNumber!,strofAppVerison)
            }else{
                strofMsgBody = String.init(format: "App version : %@",strofAppVerison)
            }
            composeVC.setMessageBody(strofMsgBody, isHTML: true)
            self.present(composeVC, animated: true, completion: nil)
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    
}


