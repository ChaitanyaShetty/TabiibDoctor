//
//  AboutViewController.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit

let selectedAppdelegateStoryBoard = Constatns.Appdelegate?.selectedStoryboard


class AboutViewController: UIViewController {
    
    @IBOutlet weak var aboutCollectionView : UICollectionView!
    @IBOutlet weak var pageControl : UIPageControl!
    
    
    var arrOfCollectionItems : NSMutableArray!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 13/255, green: 150/255, blue: 184/255, alpha: 1.0)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
        arrOfCollectionItems = NSMutableArray()
        aboutCellsDescription()
        
        pageControl.numberOfPages = arrOfCollectionItems.count
        
    }
    
    func aboutCellsDescription(){
        
        let dict1 = NSMutableDictionary()
        let dict2 = NSMutableDictionary()
        let dict3 = NSMutableDictionary()
        let dict4 = NSMutableDictionary()
        
        let keyOfdic1 = NSLocalizedString("Set Your Availability", comment: "")
        let valueOfdic1 = NSLocalizedString("Plan a month ahead. Set your availability based on your extended practice hours", comment: "")
        
        
        let keyOfdic2 = NSLocalizedString("Manage Appointments Easily", comment: "")
        let valueOfdic2 = NSLocalizedString("Setup, cancel, and reschedule appointments for the entire month, any time of the day", comment: "")
        
        
        let keyOfdic3 = NSLocalizedString("Become More Discoverable", comment: "")
        let valueOfdic3 = NSLocalizedString("Reach prospective patients, use iPhone or Android and maximize your earnings", comment: "")
        
        let keyOfdic4 = NSLocalizedString("Manage Multiple Clinics", comment: "")
        let valueOfdic4 = NSLocalizedString("Add multiple clinics under your profile and easily handle your appointments", comment: "")
        
        dict1.setValue(keyOfdic1, forKey: "Headertitle")
        dict1.setValue(valueOfdic1, forKey: "Description")
        dict1.setValue("About1", forKey: "image")
        
        dict2.setValue(keyOfdic2, forKey: "Headertitle")
        dict2.setValue(valueOfdic2, forKey: "Description")
        dict2.setValue("About2", forKey: "image")
        
        dict3.setValue(keyOfdic3, forKey: "Headertitle")
        dict3.setValue(valueOfdic3, forKey: "Description")
        dict3.setValue("About3", forKey: "image")
        
        dict4.setValue(keyOfdic4, forKey: "Headertitle")
        dict4.setValue(valueOfdic4, forKey: "Description")
        dict4.setValue("About4", forKey: "image")
        
        arrOfCollectionItems.add(dict1)
        arrOfCollectionItems.add(dict2)
        arrOfCollectionItems.add(dict3)
        arrOfCollectionItems.add(dict4)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func tapOnSkip() {
        
        let loginVc = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVc, animated: true)
        
    }
    
}

extension AboutViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfCollectionItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aboutCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AboutCollectionViewCell", for: indexPath) as! AboutCollectionViewCell
        
        let dicOfObj = arrOfCollectionItems[indexPath.row] as! NSDictionary
        
        aboutCell.CollectionOfImages.image = UIImage.init(named: dicOfObj.TabiibDocObjectForKey(forKey : "image"))
        aboutCell.lblOfTitle.text = dicOfObj.TabiibDocObjectForKey(forKey : "Headertitle")
        let myString = dicOfObj.TabiibDocObjectForKey(forKey : "Description")
        let myAttribute = [NSAttributedStringKey.foregroundColor: UIColor.colorFromRGB(0x929292),NSAttributedStringKey.font : Constatns.LatoRegular(14)]
        aboutCell.lblOfTitleContent.textAlignment = .center
        aboutCell.lblOfTitleContent.attributedText = NSAttributedString(string: myString, attributes: myAttribute)
        aboutCell.btnOfSkip.addTarget(self, action: #selector(tapOnSkip), for: .touchUpInside)
        
        return aboutCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.aboutCollectionView.frame.size.width, height: self.aboutCollectionView.frame.size.height)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for case let customcell as AboutCollectionViewCell in aboutCollectionView.visibleCells {
            let indexpath = aboutCollectionView.indexPath(for: customcell)
            pageControl.currentPage = (indexpath?.row)!
            //            if pageControl.currentPage == 3 {
            //                self.aboutCollectionView.isScrollEnabled = false
            //            }else{
            //                self.aboutCollectionView.isScrollEnabled = true
            //            }
        }
    }
    
    
}




