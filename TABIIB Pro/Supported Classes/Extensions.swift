//
//  Extensions.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import Foundation


class CommonViewController :  UIViewController {
    
    //    func reloadAPICall() {
    //
    //
    //
    //
    //    }
    
    
    var  activityIndicator : UIActivityIndicatorView!
    var isIndicatorisvisible : Bool! = false
    
    var isFromNetworkInstance : Bool! = false
    
    
    
    
    public func showActivityIndicator(){
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = Constatns.ThemeColour()
        activityIndicator.frame = CGRect.init(x: self.view.frame.size.width/2 - activityIndicator.frame.size.width, y:self.view.frame.size.height/2 , width: activityIndicator.frame.size.width, height: activityIndicator.frame.size.height)
        activityIndicator.startAnimating()
        if self.view.subviews.contains(activityIndicator){
            activityIndicator.removeFromSuperview()
            self.view.addSubview(activityIndicator)
        }else{
            self.view.addSubview(activityIndicator)
        }
        self.isIndicatorisvisible = true
        
    }
    

    

    
    public func hideActivityIndicator() {
        if self.view.subviews.contains(activityIndicator){
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            self.isIndicatorisvisible = false
            
        }
    }
    public func networkError(networkError : Int,_ message : String) {
        
        //    APIServices.SharedInstance.hideProgress()
        //    hideActivityIndicator()
        
        if message == unauthorised {
            
            let unauth = NSLocalizedString("UnAuthorisedUser", comment: "")
            
            let objofSweetAlrt = SweetAlerts()
            objofSweetAlrt.isTapGestureReg = false
            _ =  objofSweetAlrt.showAlert(unauth, style: .none, buttonTitle: NSLocalizedString("Okay", comment : ""), action: { (okay) in
                objofSweetAlrt.isTapGestureReg = false
                
                
                let loginVC = selectedAppdelegateStoryBoard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                UserDefaultStore.isLogined = "0"
                self.navigationController?.pushViewController(loginVC, animated: true)
                
                
            })
        }
        //        else if message == NetworkErrorIssue {
        //
        //            let OopsVC = selectedAppdelegateStoryBoard.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
        //            OopsVC.errorType = NetworkError
        //            self.present(OopsVC, animated: true, completion: nil)
        //        }
        //
        //        else{
        //            let OopsVC = selectedAppdelegateStoryBoard.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
        //            self.present(OopsVC, animated: true, completion: nil)
        //        }
        
        //        let OopsVC = selectedAppdelegateStoryBoard.instantiateViewController(withIdentifier: "NetworkErrorViewController") as! NetworkErrorViewController
        //
        //        OopsVC.errorDelegate = self
        //
        //        if message == NetworkErrorIssue{
        //            OopsVC.errorType = NetworkError
        //        }
        //        self.present(OopsVC, animated: true, completion: nil)
        
    }
    
    public func dismissofErrorVc(){
        self.dismiss(animated: true) {
            
        }
    }
    
    
    func backBtnShowImage(_ sender : UIButton){
        
        if L102Language.currentAppleLanguage() == "en"{
            sender.setImage(UIImage.init(named: "Back"), for: .normal)
        }else{
            sender.setImage(UIImage.init(named: "Back"), for: .normal)
        }
        
        
    }
    
    func backBtnWhiteShowImage(_ sender : UIButton){
        
        if L102Language.currentAppleLanguage() == "en"{
            sender.setImage(UIImage.init(named: "Back_white"), for: .normal)
        }else{
            sender.setImage(UIImage.init(named: "Back_white"), for: .normal)
        }
        
        
    }
    
    
}

extension UIViewController {
    
func showLoader(){
    if L102Language.currentAppleLanguage() == "ar"{
        APIServices.SharedInstance.MbProgress(view: self.view, Message: "تحميل..")
    }else{
        APIServices.SharedInstance.MbProgress(view: self.view, Message: "Loading..")
    }
}
    
}


extension UIImageView {
    public func imageFromURL(urlString: String,_ showIndicator : Bool) {
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = Constatns.ThemeColour()
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        if self.image == nil{
            if showIndicator {
                self.addSubview(activityIndicator)
            }
            
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })
            
        }).resume()
    }
}

extension NSDictionary{
    func TabiibDocObjectForKey(forKey : String) -> String{
        if self.object(forKey:forKey) != nil{
            return String(describing: self.object(forKey: forKey)!)
        }else{
            return ""
        }
    }
}



extension NSMutableArray {
    
    subscript (safe index : Int) -> Element? {
        return Int(index) < count ? self[index] : nil
    }
    
}

extension Int {
    
    func getWeekDayFromNumber() -> String{
        
        switch self {
            
        case 1:
            return NSLocalizedString("Sunday", comment: "")
            
        case 2:
            return NSLocalizedString("Monday", comment: "")
            
        case 3:
            return NSLocalizedString("Tuesday", comment: "")
            
        case 4:
            return NSLocalizedString("Wednesday", comment: "")
            
        case 5:
            return NSLocalizedString("Thursday", comment: "")
            
        case 6:
            return NSLocalizedString("Friday", comment: "")
            
        case 7:
            return NSLocalizedString("Saturday", comment: "")
            
        default:
            break
        }
        
        return ""
    }
    
    
}

extension String {
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    func getDateofBirthOwn() -> String{
        
        let dateFormatObj = DateFormatter.init()
        dateFormatObj.dateFormat = "DD-MMM-yyyy"
        dateFormatObj.locale = NSLocale.init(localeIdentifier: "en_US") as Locale!
        let datefromString = dateFormatObj.date(from: self)
        if datefromString != nil {
            let responsedate = datefromString?.getAge()
            return responsedate!
        }else{
            return ""
        }
        
    }
    
    func getDateofBirth() -> String{
        
        let dateFormatObj = DateFormatter.init()
        dateFormatObj.dateFormat = "yyyy-MM-dd"
        // dateFormatObj.locale = NSLocale.init(localeIdentifier: "en_US") as Locale!
        let datefromString = dateFormatObj.date(from: self)
        if datefromString != nil {
            let responsedate = datefromString?.getAge()
            return responsedate!
        }else{
            return ""
        }
        
    }
    
    
    func getDayOfWeek() -> String {
        
        let formatter  = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: self)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        return weekDay!.getWeekDayFromNumber()
    }
    
    func getDateFormate() ->  String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        // convert your string to date
        let yourDate = formatter.date(from: self)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "MMM dd, yyyy"
        // again convert your date to string
        
        var myStringafd : String! = ""
        
        if yourDate != nil{
            myStringafd = formatter.string(from: yourDate!)
        }else{
            myStringafd = ""
        }
        
        return myStringafd
        
    }
    
    func getDateFormate1() ->  String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        // convert your string to date
        let yourDate = formatter.date(from: self)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "MMM dd, yyyy"
        // again convert your date to string
        
        var myStringafd : String! = ""
        
        if yourDate != nil{
            myStringafd = formatter.string(from: yourDate!)
        }else{
            myStringafd = ""
        }
        
        return myStringafd
        
    }
    
    
    
    func getTimeFormate() ->  String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        // convert your string to date
        let yourDate = formatter.date(from: self)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "HH:mm"
        // again convert your date to string
        
        var myStringafd : String! = ""
        
        if yourDate != nil{
            myStringafd = formatter.string(from: yourDate!)
        }else{
            myStringafd = ""
        }
        
        return myStringafd
        
    }
    
    func getMonthFormate() ->  String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd"
        if UserDefaultStore.selectedLanguage == "0" {
            formatter.locale = NSLocale.init(localeIdentifier: "en_US") as Locale!
        }else{
            formatter.locale = NSLocale.init(localeIdentifier: "ar") as Locale!
        }
        
        // convert your string to date
        let yourDate = formatter.date(from: self)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "MMM"
        // again convert your date to string
        
        var myStringafd : String! = ""
        
        if yourDate != nil{
            myStringafd = formatter.string(from: yourDate!)
        }else{
            myStringafd = ""
        }
        
        return myStringafd
        
    }
    
    
    func getStringTimeToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let date = dateFormatter.date(from: self)
        return date ?? Date()
    }
    
}

extension Date {
    
    //    func getServerDateFormat_Arabic() -> String{
    //        let myDateFormatter = DateFormatter.init()
    //        myDateFormatter.dateFormat = "hh:mm a"
    //        myDateFormatter.locale = NSLocale.init(localeIdentifier: "en_US") as Locale!
    //        let strofDate = myDateFormatter.string(from: self as Date)
    //        return strofDate
    //    }
    //
    func getServerDateFormat() -> String{
        let myDateFormatter = DateFormatter.init()
        myDateFormatter.dateFormat = "hh:mm a"
        myDateFormatter.locale = NSLocale.init(localeIdentifier: "en_US") as Locale!
        let strofDate = myDateFormatter.string(from: self as Date)
        return strofDate
    }
    
    func getAge() -> String{
        
        let now = Date()
        let birthday: Date = self
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year,.month,.day], from: birthday, to: now)
        let age = ageComponents.year!
        if age == 0 {
            
            let months = ageComponents.month!
            if months != 0 {
                
                if months == 1{
                    
                    let strofMonths = NSLocalizedString("Month", comment: "")
                    let strofAge = String(months) + " " + strofMonths
                    return strofAge
                    
                }else{
                    let strofMonths = NSLocalizedString("Months", comment: "")
                    let strofAge = String(months) + " " + strofMonths
                    return strofAge
                }
                
            }else{
                
                let days = ageComponents.day!
                
                if days == 1{
                    let strofDays = NSLocalizedString("Day", comment: "")
                    let strofAge = String(days) + " " + strofDays
                    return strofAge
                }else{
                    let strofDays = NSLocalizedString("Days", comment: "")
                    let strofAge = String(days) + " " + strofDays
                    return strofAge
                }
            }
        }else {
            let strofYearss = NSLocalizedString("Years", comment: "")
            let strofAge = String(age) + " " + strofYearss
            return String(strofAge)
        }
    }
    
    func getYearName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        let strYear = dateFormatter.string(from: self)
        return strYear
    }
    
}



