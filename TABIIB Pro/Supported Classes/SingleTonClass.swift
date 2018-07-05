//
//  SingleTonClass.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token){
            return
        }
        _onceTracker.append(token)
        block()
    }
    
}

class SingleTonClass {
    
    class var SharedInstance : SingleTonClass {
        
        struct Static {
            static var instance : SingleTonClass? = nil
        }
        
        DispatchQueue.once(token:"com.TabiibDoctor.com",block: {
            Static.instance = SingleTonClass()
        })
        
        return Static.instance!
    }
    
   
    
    var UserObjct : Profile! = Profile()
    var arrofSpecilazations : NSMutableArray! = NSMutableArray.init()
    
    var singIdentifier : String!
    
    var arrOfSupportedCountries = NSMutableArray()
}
