//
//  APIRequest.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import Foundation
public class Connectivity {
    
    class func isCheckForNewwork() -> Bool{
        return (Reachability()?.isReachable)!
    }
}


public enum NetworkControllerError : Error {
    case invalidUrl(String)
    case invalidPayload(URL)
    case forwarded(Error)
    case noInternet()
    case unAuthorisedUser()
}

typealias successResponse = (_ dictOfResponse : AnyObject) -> Void
typealias fasilureResponse = (_ statusCode : Int, _ failureMessage : String) -> Void

struct APIServices {
    
    let session = URLSession.shared
    
    var progressHUD = MBProgressHUD()
    
    static var SharedInstance = APIServices()
    
    
    func invalidatePreviousRequest(){
        session.invalidateAndCancel()
    }
    
    func callApiResponse(MethodName:String,
                         RequestType:String,
                         postString : String,
                         isQueryString : Bool,
                         parameters: [String : Any],
                         success: @escaping successResponse,
                         failure: @escaping fasilureResponse) -> Void{
        
        if Connectivity.isCheckForNewwork() {
            
            let APIrequestQue : DispatchQueue = DispatchQueue(label: "com.app.Tabiib_Doc")
            
            APIrequestQue.sync {
                
                var urlRequestObj : URLRequest!
                
                do {
                    if isQueryString {
                        
                        let postString2 = postString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                        
                        guard let finalUrl = URL(string : String.init(format: "%@%@%@", Constatns.requestUrl,MethodName,postString2!)) else {
                            print("error to get recotdsassa")
                            return
                        }
                        urlRequestObj = URLRequest.init(url: finalUrl)
                    }
                    else{
                        guard let finalUrl = URL(string : String.init(format: "%@%@", Constatns.requestUrl,MethodName)) else {
                            print("error to get recotd")
                            return
                        }
                        urlRequestObj = URLRequest.init(url: finalUrl)
                        
                        var postData : NSData = NSData()
                        if postString == ""{
                            
                            postData  = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) as NSData
                            let jsonString : String = NSString.init(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
                            let streamData = InputStream.init(data: jsonString.data(using:String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
                            urlRequestObj.httpBodyStream = streamData
                        }
                        else{
                            
                            postData = postString.data(using: .ascii, allowLossyConversion: true)! as NSData
                            urlRequestObj.httpBody = postData as Data
                        }
                    }
                    
                    
                    urlRequestObj.httpMethod = RequestType
                    urlRequestObj.setValue(Constatns.HTTP_HEADER_CONTENT_TYPE_VALUE, forHTTPHeaderField: Constatns.HTTP_HEADER_CONTENT_TYPE)
                    
                    let username = "tabiib"
                    let password = "tabiib@smsc"
                    let loginString = String(format: "%@:%@", username, password)
                    let loginData = loginString.data(using: String.Encoding.utf8)!
                    let base64LoginString = loginData.base64EncodedString()
                    urlRequestObj.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                    
                    urlRequestObj.timeoutInterval = 120
                    
                    
                    let dataTask = session.dataTask(with: urlRequestObj as URLRequest) {data,response,error in
                        
                        DispatchQueue.main.sync {
                            let httpResponse = response as? HTTPURLResponse
                            
                            if (error == nil) {
                                
                                if httpResponse?.statusCode == 200 {
                                    do{
                                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                                        success(json as AnyObject)
                                    }catch{
                                    }
                                }else if httpResponse?.statusCode == 403{
                                    failure((httpResponse?.statusCode)!, "unauthorised")
                                }
                                else{
                                    
                                    failure(500,"parameters wrong")
                                }
                            }else{
                                
                                failure(0, "geterror")
                                
                            }
                        }
                    }
                    dataTask.resume()
                }
                catch{
                    
                }
            }
        }
        else{
            
            failure(0,"NetworkErrorIssue")
            
        }
    }
    
    
    //MARK: Show MBProgress Hud function
    mutating func MbProgress(view:UIView,Message : String)
    {
        progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD.label.text = Message
    }
    
    //MARK: Hide MBProgress Hud function
    func hideProgress()
    {
        progressHUD.hide(animated: true)
        progressHUD.isHidden = true
    }
}

