//
//  Utilities.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

class Utilities {
    
    static var sharedInstace = Utilities()
    
    
    func showAlertviewWithMessage(_ strofMsg : String){
        _ = SweetAlerts().showAlert(strofMsg, style: .none, buttonTitle: NSLocalizedString("Okay", comment : ""), buttonColor: Constatns.ThemeColour())
    }
    
    func isIphone() -> Bool {
        return (UIDevice.current.userInterfaceIdiom == .phone) ? true : false
    }
    
    func openAppPermissions(){
        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
        
    }
    
    func isStringContainsAnySpecialCharacter(_ strofString : String) -> Bool {
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ")
        
        if strofString.rangeOfCharacter(from: characterset.inverted) != nil{
            return false
        }else{
            return true
        }
        
    }
    
    
    func getVersion() -> String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "no version info"
        }
        return version
    }
    
    
    func detectIphone5S() -> Bool{
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 568 {
            return true
        }else{
            return false
        }
    }
    
    
    func checkCameraRuntimePermission() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .notDetermined,.denied,.restricted:
            return false
        case .authorized:
            return true
        }
    }
    
    
    func checkPhotosRuntimePermisson() -> Bool{
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .denied,.notDetermined,.restricted:
            return false
        case .authorized:
            return true
        }
        
    }
    
    
    //MARK: - - valdiate password
    func isValidPassword(candidate: String) -> Bool {
        
        let passwordRegex = "(?=.*[a-z])(?=.*[!@#$&*])(?=.*[A-Z])(?=.*\\d).{6,15}"
        
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: candidate)
    }
    
    //MARK: - Validate the EmailId
    
    func validateEmail(emailAddress : String) -> Bool {
        
        let emailRegex : String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest : NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: emailAddress)
        
    }
    
    
    
    
}
