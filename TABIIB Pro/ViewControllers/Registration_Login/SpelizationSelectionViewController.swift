//
//  SpelizationSelectionViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

protocol SpelicilationsSelected {
    func selectedSpecilations(_ arrofSpecialicatos : NSMutableArray)
}



class SpelizationSelectionViewController: UIViewController,SpelicilationsSelected {
    func selectedSpecilations(_ arrofSpecialicatos: NSMutableArray) {
        
    }
    
    
    @IBOutlet var tbofSpecilaztions: UITableView!
    var singtonObj : SingleTonClass!
    var arrofListedSpecilation : NSMutableArray!
    var arrofSelectedSpecilations : NSMutableArray!
    var delegate : SpelicilationsSelected!
    
    @IBOutlet var viewofSelectedOptions : UIView!
    @IBOutlet var collecitonofSelctedSpe : UICollectionView!
    var arrofCopyofSelctedSpeci : NSMutableArray! = NSMutableArray.init()
    
    @IBOutlet var topConstarintValue: NSLayoutConstraint!
    var isFromUpdateProfile : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singtonObj = SingleTonClass.SharedInstance
        arrofListedSpecilation = NSMutableArray.init()
        arrofSelectedSpecilations = NSMutableArray.init()
        arrofListedSpecilation.addObjects(from: singtonObj.arrofSpecilazations as! [Any])
        
        if self.arrofCopyofSelctedSpeci.count > 0 {
            arrofSelectedSpecilations.addObjects(from: arrofCopyofSelctedSpeci as! [Any])
            topConstarintValue.constant = 50
            viewofSelectedOptions.isHidden = false
            collecitonofSelctedSpe.reloadData()
        }
        else{
            topConstarintValue.constant = 0
            viewofSelectedOptions.isHidden = true
        }
        
        tbofSpecilaztions.reloadData()
        
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        
        if arrofSelectedSpecilations.count == 0 {
            Utilities.sharedInstace.showAlertviewWithMessage(NSLocalizedString("Select atleast one specialization", comment: ""))
        }else {
            if let delegateObj = self.delegate {
                delegateObj.selectedSpecilations(arrofSelectedSpecilations)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        
        if isFromUpdateProfile {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is ProfileViewController {
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }else{
            self.navigationController?.popViewController(animated: true)
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
extension SpelizationSelectionViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrofSelectedSpecilations.count
    }
    
    @objc func btnSpecilationDeletionClicked(_ sender : UIButton) {
        
        if arrofSelectedSpecilations.count > 0 {
            arrofSelectedSpecilations.removeObject(at: sender.tag)
            collecitonofSelctedSpe.reloadData()
            tbofSpecilaztions.reloadData()
            
            if arrofSelectedSpecilations.count == 0 {
                topConstarintValue.constant = 0
                viewofSelectedOptions.isHidden = true
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellofSepeSele = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedSpelicationCollectionViewCell", for: indexPath) as! SelectedSpelicationCollectionViewCell
        
        let dictofSeplization = arrofSelectedSpecilations[indexPath.row] as! NSDictionary
        
        cellofSepeSele.lblofSpecilazation.text = String(describing: dictofSeplization.TabiibDocObjectForKey(forKey: DocSpecialisations.APIResponse.spName))
        
        cellofSepeSele.btnotDeleteSpelization.tag = indexPath.row
        cellofSepeSele.btnotDeleteSpelization.addTarget(self, action: #selector(btnSpecilationDeletionClicked(_:)), for: .touchUpInside)
        
        return cellofSepeSele
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let dictofSeplization = arrofSelectedSpecilations[indexPath.row] as! NSDictionary
        let specilization: String = String(describing: dictofSeplization.TabiibDocObjectForKey(forKey: DocSpecialisations.APIResponse.spName))
        let width = specilization.width(withConstrainedHeight: 33, font: Constatns.LatoRegular(14))
       
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CGSize(width: width + 30 , height: 33)
        }
        else if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: width + 105 , height: 33)
        }
        return CGSize(width: width + 30 , height: 33)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
}

extension String
{
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height);
        
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.width;
    }
}

extension SpelizationSelectionViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrofListedSpecilation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let specilacitionCell = tableView.dequeueReusableCell(withIdentifier: "SpelicationListTableViewCell", for: indexPath) as! SpelicationListTableViewCell
        
        let dictofSpecilations = arrofListedSpecilation[indexPath.row] as! NSDictionary
        
        specilacitionCell.lblofName.text = String(describing:dictofSpecilations.TabiibDocObjectForKey(forKey: DocSpecialisations.APIResponse.spName))
        
        if arrofSelectedSpecilations.contains(dictofSpecilations) {
            specilacitionCell.imgofSelection.image  = UIImage.init(named: "sele_box")
        }
        else{
            specilacitionCell.imgofSelection.image = UIImage.init(named : "box")
        }
        specilacitionCell.selectionStyle = .none
        return specilacitionCell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dictofSpecilations = arrofListedSpecilation[indexPath.row] as! NSDictionary
        
        if arrofSelectedSpecilations.contains(dictofSpecilations) {
            arrofSelectedSpecilations.remove(dictofSpecilations)
        }
        else{
            arrofSelectedSpecilations.add(dictofSpecilations)
        }
        
        if arrofSelectedSpecilations.count > 0 {
            
            let newarray =  arrofSelectedSpecilations.reverseObjectEnumerator().allObjects
            arrofSelectedSpecilations.removeAllObjects()
            arrofSelectedSpecilations.addObjects(from: newarray)
            
            viewofSelectedOptions.isHidden = false
            topConstarintValue.constant = 50
            collecitonofSelctedSpe.reloadData()
            
        }else{
            viewofSelectedOptions.isHidden = true
            topConstarintValue.constant = 0
        }
        tbofSpecilaztions.reloadData()
        
    }
    
    
}


