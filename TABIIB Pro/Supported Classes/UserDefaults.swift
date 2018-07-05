//
//  UserDefaults.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import Foundation


class UserDefaultStore: NSObject {
    
    //ContactNumber
    class var isLogined : String! {
        
        get{
            if let did = UserDefaults.standard.object(forKey: "isLogined"){
                return did as! String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "isLogined")
        }
        
    }
    
    class var userMobile : String! {
        
        get{
            if let did = UserDefaults.standard.object(forKey: "userMobile"){
                return did as! String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "userMobile")
        }
    }
    
    class var password : String! {
        
        get{
            if let did = UserDefaults.standard.object(forKey: "password"){
                return did as! String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "password")
        }
    }
    
    
    class var currency : String?{
        
        get{
            if let did = UserDefaults.standard.object(forKey: "currency"){
                return did as? String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "currency")
        }
    }
    
    class var mobileNumber : String?{
        
        get{
            if let did = UserDefaults.standard.object(forKey: "mobileNumber"){
                return did as? String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "mobileNumber")
        }
    }
    
    class var emailId : String?{
        
        get{
            if let did = UserDefaults.standard.object(forKey: "emailId"){
                return did as? String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "emailId")
        }
    }
    
    
    class var mobilePrefix : String?{
        
        get{
            if let did = UserDefaults.standard.object(forKey: "mobilePrefix"){
                return did as? String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "mobilePrefix")
        }
    }
    
    class var userRef : String!{
        
        get{
            if let did = UserDefaults.standard.object(forKey: "userRef"){
                return did as! String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "userRef")
        }
    }
    
    class var ApiKey : String!{
        
        get{
            if let did = UserDefaults.standard.object(forKey: "ApiKey"){
                return did as! String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "ApiKey")
        }
    }
    
    class var userID : String!{
        
        get{
            if let did = UserDefaults.standard.object(forKey: "userID"){
                return did as! String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "userID")
        }
    }
    
    
    class var DeviceToken : String!{
        get{
            if let did = UserDefaults.standard.object(forKey: "DeviceToken"){
                return did as! String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "DeviceToken")
        }
    }
    
    
    class var deviceID : String?{
        
        get{
            if let did = UserDefaults.standard.object(forKey: "deviceID"){
                return did as? String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "deviceID")
        }
    }
    
    
    class var UpdatedAppVersionIs : String?{
        get{
            if let did = UserDefaults.standard.object(forKey: "UpdatedAppVersionIs"){
                return did as? String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "UpdatedAppVersionIs")
        }
    }
    
    class var isIsForcibleUpdate : String?{
        get{
            if let did = UserDefaults.standard.object(forKey: "isIsForcibleUpdate"){
                return did as? String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "isIsForcibleUpdate")
        }
    }
    
    
    class var appVersion : String?{
        
        get{
            if let did = UserDefaults.standard.object(forKey: "appVersion"){
                return did as? String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "appVersion")
        }
    }
    
    
    class var isAutoConfirmAppointment : String? {
        
        get {
            if let did = UserDefaults.standard.object(forKey: "isAutoConfirmAppointment") {
                return did as? String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "isAutoConfirmAppointment")
        }
    }
    
    
    class var selectedLanguage : String? {
        
        get {
            if let did = UserDefaults.standard.object(forKey: "selectedLanguage") {
                return did as? String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "selectedLanguage")
        }
    }
    
    
    class var checkMedicalNumber :String? {
        
        get {
            if let did = UserDefaults.standard.object(forKey: "checkMedicalNumber") {
                return did as? String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "checkMedicalNumber")
        }
    }
    
    class var contact_EmailID : String! {
        get{
            if let did = UserDefaults.standard.object(forKey: "contact_EmailID"){
                return did as! String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "contact_EmailID")
        }
    }
    
    //contact_Mobileno
    
    class var contact_Mobileno : String! {
        get{
            if let did = UserDefaults.standard.object(forKey: "contact_Mobileno"){
                return did as! String
            }
            return nil
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "contact_Mobileno")
        }
    }
    
    
}
