//
//  LanguageViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

class LanguageViewController: UIViewController {
    
    @IBOutlet weak var langTableView : UITableView!
    
    var arraOfLang : NSMutableArray!
    var selecLang : String!
    var singObj : SingleTonClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        singObj = SingleTonClass.SharedInstance
        singObj.singIdentifier = "SettingsViewController"
        
        arraOfLang = NSMutableArray()
        
        let English = NSLocalizedString("English", comment: " ")
        let Arabic = NSLocalizedString("Arabic", comment: " ")
        arraOfLang = [English,Arabic]
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


extension LanguageViewController : UITableViewDelegate,UITableViewDataSource


{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraOfLang.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let langSeleCell = tableView.dequeueReusableCell(withIdentifier: "LangSeleTableViewCell", for: indexPath) as! LangSeleTableViewCell
        
        langSeleCell.lblofLang.text = arraOfLang[indexPath.row] as? String
        
        if L102Language.currentAppleLanguage() == "en"{
            
            if indexPath.row == 0{
                langSeleCell.imgOflang.image = UIImage.init(named: "lang_Select")
            }else {
                langSeleCell.imgOflang.image = UIImage.init(named : "Check_unselect")
            }
            
        }else{
            
            if indexPath.row == 0{
                langSeleCell.imgOflang.image = UIImage.init(named : "Check_unselect")
            }else {
                langSeleCell.imgOflang.image = UIImage.init(named : "lang_Select")
            }
            
        }
        
        if indexPath.row == 1{
            langSeleCell.lblOfLine.isHidden = true
        }
        
        
        
        langSeleCell.selectionStyle = .none
        return langSeleCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let strofSelectedlang = indexPath.row
        self.selecLang = String(describing: strofSelectedlang)
        
        if selecLang != UserDefaultStore.selectedLanguage {
            updateTimer()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 70
        } else {
            return 90
        }
    }
    
    func updateTimer() {
        
        let lang = NSLocalizedString("Are you sure you want to change the language?", comment: "")
        let okay = NSLocalizedString( "Okay", comment: "")
        let cancel = NSLocalizedString("Cancel", comment: "")
        
        let objofSweetAlrt = SweetAlerts()
        objofSweetAlrt.isTapGestureReg = false
        _ = objofSweetAlrt.showAlert2(lang, style: .success, buttonTitle: okay, buttonColor: Constatns.ThemeColour(), otherButtonTitle: cancel, otherbuttonColor: Constatns.WeekDaysColour(), action: { (clcked) in
            
            if L102Language.currentAppleLanguage() == "en" {
                L102Language.setAppleLAnguageTo(lang: "ar")
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            } else {
                L102Language.setAppleLAnguageTo(lang: "en")
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
            UserDefaultStore.selectedLanguage = self.selecLang
            
            
            var storyboard : UIStoryboard!
            let appdelegateObj = Constatns.Appdelegate
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                storyboard =  UIStoryboard.init(name: "Main", bundle: nil)
            }
            else if UIDevice.current.userInterfaceIdiom == .pad {
                storyboard =  UIStoryboard.init(name: "Main_iPad", bundle: nil)
            }

            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let appdelegateObj = Constatns.Appdelegate
            
            var navigationcontorObj = UINavigationController()
            // L102Localizer.DoTheMagic()
            
            
            
            if UserDefaultStore.isLogined == "0" {
                
                let aboutvc  = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
                navigationcontorObj = UINavigationController.init(rootViewController: aboutvc)
                //                        navigationcontorObj.isNavigationBarHidden = true
                //                        appdelegateObj?.window?.rootViewController =  navigationcontorObj
                
            }
            else{
                let homevc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                navigationcontorObj = UINavigationController.init(rootViewController: homevc)
            }
            
            navigationcontorObj.isNavigationBarHidden = true
            appdelegateObj?.window?.rootViewController =  navigationcontorObj
            
            //                    appdelegateObj?.window?.rootViewController = storyboard.instantiateInitialViewController()
            
            
        }, action2: { (cancel) in
            
        })
    }
    
    
    
    
}
