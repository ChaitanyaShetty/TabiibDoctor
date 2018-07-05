//
//  Constants.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit


class Constatns {
    
    static let Appdelegate = UIApplication.shared.delegate as? AppDelegate
    
    //    static let requestUrl :String = "http://staging.tabiib.com/Api/WebServices/"
    static let requestUrl :String = "http://staging.tabiib.com/Api/v102/WebServices/"
    //"https://tabiib.com/Api/v101/WebServices/"
    //https://www.tabiib.com/Api/v101/WebServices/userRegister
    
    
    static let HTTP_REQUEST_GET:String = "GET"
    static let HTTP_REQUEST_POST:String = "POST"
    static let HTTP_HEADER_CONTENT_LENGTH:String = "Content-Length"
    static let HTTP_HEADER_CONTENT_TYPE:String = "Content-Type"
    static let HTTP_HEADER_CONTENT_TYPE_VALUE:String = "application/json"
    
    
    static let ViewWidth : CGFloat = UIScreen.main.bounds.size.width
    static let ViewHeight : CGFloat = UIScreen.main.bounds.size.height
    
    static let iPhone5Width : CGFloat     = 320
    static let iPhone6Width : CGFloat     = 375
    static let iPhone6PlusWidht : CGFloat = 414
    static let iPhoneXHeight : CGFloat    = 812
    
    static func WeekDaysColour() -> UIColor {
        let SelectedColour  = UIColor.init(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        return SelectedColour
    }
    static func AppointmentColour() -> UIColor{
        let SelectedColour  = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
        return SelectedColour
    }
    
    static func ThemeColour() -> UIColor {
        let SelectedColour  = UIColor.init(red: 50/255, green: 184/255, blue: 152/255, alpha: 1)
        return SelectedColour
    }
    static func profileColor() -> UIColor{
        let SelectedColour  = UIColor.init(red: 202/255, green: 202/255, blue: 202/255, alpha: 1)
        return SelectedColour
    }
    static func UnSelectThemeColour() -> UIColor {
        let SelectedColour  = UIColor.init(red: 219/255, green: 219/255, blue: 219/255, alpha: 1)
        return SelectedColour
    }
    
    //for fonts
    static func LatoRegular(_ x : CGFloat) -> UIFont{
        let customFont : UIFont = UIFont.init(name: "Lato-Regular", size: x)!
        return customFont
    }
    static func Lato_Bold(_ x : CGFloat) -> UIFont{
        let customFont : UIFont = UIFont.init(name: "Lato-Bold", size: x)!
        return customFont
    }
    static func Lato_Medium(_ x : CGFloat) -> UIFont{
        let customFont : UIFont = UIFont.init(name: "Lato-Medium", size: x)!
        return customFont
    }
    
    static func CategoryShadowCColour()-> UIColor{
        return UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
    }
    
    
}



public struct APIRequestKeys {
    
    static let ApiKey = "ApiKey"
    static let userRef = "userRef"
}

public struct DocSpecialisations {
    
    //{"ApiKey":"OIxv03jBrOUGAKg8","userRef":"UspJ0gzXZkTdHpOL"}
    //
    //    struct APIRequest {
    //
    //        static let ApiKey = "ApiKey"
    //        static let userRef = "userRef"
    //    }
    
    struct APIResponse {
        
        static let data = "data"
        static let spId = "spId"
        static let spImage = "spImage"
        static let spName = "spName"
        static let type = "type"
    }
    
    
}

public struct APIServiceLoading{
    
    static let Loading = NSLocalizedString("Loading...", comment: "")
    
    
}





//MARK: - - - Login & Registration APi's

public struct Login {
    /*{"emailMobileNumber":"manishkumar@1wayit.com","password":"1234567","ApiKey":"OIxv03jBrOUGAKg8","userRef":"UspJ0gzXZkTdHpOL"
     ,"deviceId":"123456","deviceType":"3","registerId":"zt3IK2SxxBMvzI8f","userType":"2"}
     
     
     {
     data =     {
     ApiKey = StBJiyhXdl9DPEbv;
     clinicCount = 0;
     id = 957;
     userPrefix = 91;
     userRef = OGrFNdDl3ar9ZWXy;
     };
     success = true;
     "success_message" = "Login Successfully. Please wait we are redirecting you to dashboard.";
     }
     
     */
    
    struct APIRequest {
        static let emailMobileNumber = "emailMobileNumber"
        static let password = "password"
        static let deviceId = "deviceId"
        static let deviceType = "deviceType"  //3 for ios
        static let registerId = "registerId"
        static let userType = "userType" //2 - doc app
        static let mobilePrefix = "mobilePrefix"
    }
    
    struct APIResponse {
        static let data = "data"
        static let ApiKey = "ApiKey"
        static let clinicCount = "clinicCount"
        static let Userid = "id"
        static let userPrefix = "userPrefix"
        static let userRef = "userRef"
        static let emailId = "emailId"
        static let mobileNumber = "mobileNumber"
    }
}

public struct SettingsLogOut{
    /*  {"ApiKey":"jpagwVykUaYKt6HO","userRef":"M2dN3eGQxzRV1i8C","deviceType":"1"}*/
    struct APIRequest {
        
        static let ApiKey = "ApiKey"
        static let userRef = "userRef"
        static let deviceType = "deviceType"
    }
    
}



public struct ForgotPassword {
    /*{"ApiKey":"OIxv03jBrOUGAKg8","userRef":"UspJ0gzXZkTdHpOL","mobilePrefix":"91","mobileNumber":"8528330637","userType":"2"}*/
    
    struct APIRequest {
        static let mobilePrefix = "mobilePrefix"
        static let mobileNumber = "mobileNumber"
        static let userType = "userType"
    }
}


public struct ForgotPasswordCheckOTP {
    /*{"userOTP":"95986","mobileNumber":"565465456","userRef":"UspJ0gzXZkTdHpOL","ApiKey":"OIxv03jBrOUGAKg8","userType":"2"}*/
    struct APIRequest {
        static let userOTP = "userOTP"
        static let mobileNumber = "mobileNumber"
        static let userType = "userType"
    }
}

public struct UpdateForgotPassword {
    /*{"userRef":"UspJ0gzXZkTdHpOL","ApiKey":"OIxv03jBrOUGAKg8","mobileNumber":"8528330637","password":"12345678","userType":"2"}*/
    /*UpdateForgotPassword.APIRequest.registerId : "zt3IK2SxxBMvzI8f",
     UpdateForgotPassword.APIRequest.deviceId : UserDefaultStore.deviceID!,
     UpdateForgotPassword.APIRequest.deviceType : "3"*/
    
    struct APIRequest {
        static let password = "password"
        static let mobileNumber = "mobileNumber"
        static let userType = "userType"
        static let registerId = "registerId"
        static let deviceId = "deviceId"
        static let deviceType = "deviceType"
    }
    
}

public struct CheckOTP {
    /*{"userOTP":"95986","mobileNumber":"565465456","userRef":"UspJ0gzXZkTdHpOL","ApiKey":"OIxv03jBrOUGAKg8","userType":"2"}
     CheckOTP.APIRequest.registerId : UserDefaultStore.DeviceToken,
     CheckOTP.APIRequest.deviceId : UserDefaultStore.deviceID!,
     CheckOTP.APIRequest.deviceType : "3"*/
    struct APIRequest {
        static let userOTP = "userOTP"
        static let mobileNumber = "mobileNumber"
        static let userType = "userType"
        static let registerId = "registerId"
        static let deviceId = "deviceId"
        static let deviceType = "deviceType"
    }
    
}



public struct ResendOTP {
    /*{"mobileNumber":"8528330637","messageType":"message/voicecall","userRef":"UspJ0gzXZkTdHpOL","ApiKey":"OIxv03jBrOUGAKg8","userType":"2"}*/
    
    struct APIRequest {
        static let mobileNumber = "mobileNumber"
        static let messageType = "messageType"
        static let userType = "userType"
    }
}



/*{"namePrefix":"Mr","Name":"Manish Katwal","mobilePrefix":"91","mobileNumber":"565465456",
 "emailId":"manishskumar@111wayit.com","password":"123456","userGender":"male","sepcialId":[{"sepcialId":"1"},{"sepcialId":"2"}],"medicalRegNo":"1234567890","ApiKey":"OIxv03jBrOUGAKg8","userRef":"UspJ0gzXZkTdHpOL","userType":"2"}*/


public struct Registration {
    
    
    struct APIRequest {
        
        static let namePrefix = "namePrefix"
        static let Name = "Name"
        static let mobilePrefix = "mobilePrefix"
        static let mobileNumber = "mobileNumber"
        static let emailId = "emailId"
        static let password = "password"
        static let userGender = "userGender"
        static let sepcialId = "sepcialId"
        static let medicalRegNo = "medicalRegNo"
        static let ApiKey = "ApiKey"
        static let userRef = "userRef"
        static let userType = "userType"
        static let prevUserRef = "prevUserRef"
        
    }
    
    struct APIResponse {
        
        static let NewuserRef = "NewuserRef"
        
    }
    
}

public struct UpdateRegisterId {
    
    /*{"ApiKey":"ALosBCfRzZdSg6Ra","userRef":"pkHdDcJi2yf6caBd","deviceId":"123456","deviceType":"3","registerId":"zt3IK2SxxBMvzI890","userType":"2"}*/
    
    struct APIRequest {
        
        static let deviceId = "deviceId"
        static let registerId = "registerId"
        static let deviceType = "deviceType"
        static let userType = "userType"
        
        
    }
    
    struct APIResponse {
        
        
    }
}


public struct logOut {
    
    /*{"ApiKey":"jpagwVykUaYKt6HO","userRef":"M2dN3eGQxzRV1i8C","deviceType":"1"}*/
    
    
    struct APIRequest {
        
        static let deviceType = "deviceType"
        
    }
    
    struct APIResponse {
        
        
    }
    
}

//MARK: - - -  profile APi's

public struct UserProfile {
    /*{"ApiKey":"OIxv03jBrOUGAKg8","userRef":"UspJ0gzXZkTdHpOL","userType":"2"}
     
     {
     docInfo =     (
     {
     Name = Gopi;
     city = "";
     cityName = "<null>";
     eduQualProof = "";
     eduQualification = "";
     emailId = "kothakiran28@gmail.com";
     highestEduQualification = "";
     ipAddress = "183.82.2.22";
     isMRNVerified = 0;
     medicalRegNo = 134667;
     mobileNumber = 9490851731;
     mobilePrefix = 91;
     month = 6;
     namePrefix = "Ms.";
     profilePic = "";
     regProof = "";
     registrationCouncil = "";
     registrationYear = "";
     universityName = "";
     userActive = 1;
     userGender = Female;
     userRef = OGrFNdDl3ar9ZWXy;
     userType = 2;
     year = 5;
     }
     );
     special =     (
     {
     sepcialId = 22;
     spName = "Conservative Dentistry & Endodontics";
     userRef = OGrFNdDl3ar9ZWXy;
     }
     );
     success = true;
     "success_message" = "User details get successfully.";
     }
     
     Name = Gopi;
     city = 5;
     cityName = Addanki;
     docInformation = "kothakiran28@gmail.com";
     doctorLatitude = "";
     doctorLongitude = "";
     eduQualProof = "http://staging.tabiib.com/assets/docEduFiles/edu_15179891575571.jpg";
     "eduQualProof_1" = "http://staging.tabiib.com/";
     "eduQualProof_2" = "http://staging.tabiib.com/";
     eduQualification = hvybhub;
     emailId = "kothakiran28@gmail.com";
     highestEduQualification = yvybybu;
     ipAddress = "183.82.2.22";
     mobileNumber = 9490851731;
     mobilePrefix = 91;
     month = 6;
     namePrefix = "Ms.";
     profilePic = "http://staging.tabiib.com/";
     regProof = "http://staging.tabiib.com/assets/registrationProofs/reg_15179891572842.jpg";
     "regProof_1" = "http://staging.tabiib.com/assets/registrationProofs/reg_15179891577031.jpg";
     "regProof_2" = "http://staging.tabiib.com/assets/registrationProofs/reg_15179891573287.jpg";
     
     */
    
    struct APIRequest  {
        
        static let userType = "userType"
        
    }
    
    struct APIResponse {
        static let docInformation = "docInformation"
        static let docInfo = "docInfo"
        static let Name = "Name"
        static let city = "city"
        static let eduQualification = "eduQualification"
        static let emailId = "emailId"
        static let highestEduQualification = "highestEduQualification"
        static let isMRNVerified = "isMRNVerified"
        static let medicalRegNo = "medicalRegNo"
        static let mobileNumber = "mobileNumber"
        static let mobilePrefix = "mobilePrefix"
        static let month = "month"
        static let namePrefix = "namePrefix"
        static let profilePic = "profilePic"
        static let registrationCouncil = "registrationCouncil"
        static let registrationYear = "registrationYear"
        static let universityName = "universityName"
        static let userGender = "userGender"
        static let userActive = "userActive"
        static let year = "year"
        static let special = "special"
        static let sepcialId = "sepcialId"
        static let spName = "spName"
        
        static let eduQualProof = "eduQualProof"
        static let eduQualProof_1 = "eduQualProof_1"
        static let eduQualProof_2 = "eduQualProof_2"
        static let regProof = "regProof"
        static let regProof_1 = "regProof_1"
        static let regProof_2 = "regProof_2"
        
    }
}





public struct UpdateBasicProfile {
    /*{"ApiKey":"SKZHTiNhgR6G9TSl","userRef":"QmalxZn4UQEWfSq6","namePrefix":"Mrs.","Name":"",emailId":","sepcialId":[{"sepcialId":"1"}{"sepcialId":"2"}],"year":"2","month":"7","docInformation":"testttttt"}*/
    
    struct APIRequest  {
        static let namePrefix = "namePrefix"
        static let Name = "Name"
        static let emailId = "emailId"
        static let sepcialId = "sepcialId"
        static let year = "year"
        static let month = "month"
        static let docInformation = "docInformation"
    }
    
    struct APIResponse {
        
    }
}


public struct UpdateEducationProfile {
    /*{"ApiKey":"SKZHTiNhgR6G9TSl","userRef":"QmalxZn4UQEWfSq6","highestEduQualification":"b.tech","eduQualification":"","universityName":"","registrationCouncil":"23423432423432","medicalRegNo":"","registrationYear":"2015"}*/
    
    struct APIRequest  {
        static let highestEduQualification = "highestEduQualification"
        static let eduQualification = "eduQualification"
        static let universityName = "universityName"
        static let registrationCouncil = "registrationCouncil"
        static let medicalRegNo = "medicalRegNo"
        static let registrationYear = "registrationYear"
    }
    
    struct APIResponse {
        
    }
    
    
}


public struct UpdateEducationProofDocuments {
    
    /*{"ApiKey":"SKZHTiNhgR6G9TSl","userRef":"QmalxZn4UQEWfSq6","regProof":"gbfsdhgdf","regProof_1":"gbfsdhgdf","regProof_2":"gbfsdhgdf","eduQualProof":"fghgd","eduQualProof_1":"fghgd","eduQualProof_2":"fghgd","regProof_Flag":"1","regProof_1_Flag":"1","regProof_2_Flag":"1","eduQualProof_Flag":"1","eduQualProof_1_Flag":"1","eduQualProof_2_Flag":"1"}*/
    
    struct APIRequest  {
        
        static let regProof = "regProof"
        static let regProof_1 = "regProof_1"
        static let regProof_2 = "regProof_2"
        static let regProof_Flag = "regProof_Flag"
        static let regProof_1_Flag = "regProof_1_Flag"
        static let regProof_2_Flag = "regProof_2_Flag"
        static let eduQualProof = "eduQualProof"
        static let eduQualProof_1 = "eduQualProof_1"
        static let eduQualProof_2 = "eduQualProof_2"
        static let eduQualProof_Flag = "eduQualProof_Flag"
        static let eduQualProof_1_Flag = "eduQualProof_1_Flag"
        static let eduQualProof_2_Flag = "eduQualProof_2_Flag"
        
    }
    
    struct APIResponse {
        
        
        
    }
}



public struct UpdateProfilePic {
    
    /*{"ApiKey":"OIxv03jBrOUGAKg8","userRef":"wZ9LQaj5naFGZS2t","profilePic":" http://staging.tabiib.com/assets/docProfPic/img.jpg","userType":"2"}*/
    
    struct APIRequest  {
        static let profilePic = "profilePic"
        static let userType = "userType"
    }
    
    struct APIResponse {
        
    }
    
}

public struct updateDocSetting {
    /*{"userRef":"y3n5BazO80pZMe7i","ApiKey":"WrjkcHZIl7DAv4MG","userType":"2","ConfirmAllApp":"1"}*/
    
    struct APIRequest {
        static let userType = "userType"
        static let ConfirmAllApp = "ConfirmAllApp"
    }
    
}

public struct updatePassword{
    
    struct APIRequest {
        static let userType = "userType"
        static let oldPassword = "oldPassword"
        static let password = "password"
    }
    
    struct APIResponse {
        
    }
    
}




//MARK: - - - - Clininc details API's


public struct CliniListbyDocref {
    
    /*{"userRef":"QmalxZn4UQEWfSq6","ApiKey":"SKZHTiNhgR6G9TSl","page":"0"}
     
     
     data =     (
     {
     consulationFee = 555;
     days = "Sun,Mon,Tue,Wed,Thu,Fri,Sat";
     endEveningTime = "22:00";
     endMorningTime = "16:00";
     eveningStatus = 1;
     hospRef = 6aowTZzuAZjgTF4l;
     hospitalAddress = "# 1-112 / 86, Survey No 55/ EE, Kondapur Village, Serilingampally Mandal, Hyderabad, Telangana 500084";
     hospitalBranchName = kondapur;
     hospitalCity = 4460;
     hospitalHelpLinePhone = "";
     hospitalName = kims;
     hospitalPhone = 4067505050;
     morningStatus = 1;
     phonePrefix = 91;
     startEveningTime = "17:00";
     startMorningTime = "10:00";
     uRef = k8PTXxR0KhT8uZrH;
     }
     );
     iOSAppVersion = "1.0";
     isForcable = 0;
     success = true;
     "success_message" = "Clinics Listed successfully.";
     totalRecords = 1;
     
     
     
     */
    
    struct APIRequest  {
        static let page = "page"
    }
    
    struct APIResponse {
        static let data = "data"
        static let days = "days"
        static let consulationFee = "consulationFee"
        static let endEveningTime = "endEveningTime"
        static let endMorningTime = "endMorningTime"
        static let uRef = "uRef"
        static let eveningStatus = "eveningStatus"
        static let hospRef = "hospRef"
        static let phonePrefix = "phonePrefix"
        static let morningStatus = "morningStatus"
        static let hospitalPhone = "hospitalPhone"
        static let hospitalName = "hospitalName"
        static let hospitalAddress = "hospitalAddress"
        static let hospitalBranchName = "hospitalBranchName"
        static let hospitalCity = "hospitalCity"
        static let hospitalHelpLinePhone = "hospitalHelpLinePhone"
        static let startEveningTime = "startEveningTime"
        static let startMorningTime = "startMorningTime"
        static let totalRecords = "totalRecords"
    }
    
}






public struct SearchClinics {
    /*{"userRef":"QmalxZn4UQEWfSq6","ApiKey":"SKZHTiNhgR6G9TSl","page":"0","clinicSearchKey":"TEST"}*/
    
    struct APIRequest  {
        
        static let page = "page"
        static let clinicSearchKey = "clinicSearchKey"
        static let mobilePrefix = "mobilePrefix"
        
    }
    
    struct APIResponse {
        
        static let iOSAppVersion = "iOSAppVersion"
        static let isForcable = "isForcable"
        static let totalRecords = "totalRecords"
        static let data = "data"
        static let hospRef = "hospRef"
        static let hospitalName = "hospitalName"
        static let hospitalBranchName = "hospitalBranchName"
        static let phonePrefix = "phonePrefix"
        static let hospitalPhone = "hospitalPhone"
        static let hospitalAddress = "hospitalAddress"
        static let hospitalHelpLinePhone = "hospitalHelpLinePhone"
        static let hospitalCity = "hospitalCity"
        static let hospitalPinCode = "hospitalPinCode"
        
    }
    
    
}


public struct getClinicinfo {
    
    /*{"userRef":"QmalxZn4UQEWfSq6","ApiKey":"SKZHTiNhgR6G9TSl","hospRef":"uHtORE84ATzJ5oG7"}*/
    
    struct APIRequest {
        
        static let hospRef = "hospRef"
        
    }
    
    struct APIResponse {
        
        static let data = "data"
        static let hospRef = "hospRef"
        static let hospitalId = "hospitalId"
        static let parentUserRef = "parentUserRef"
        static let hospitalName = "hospitalName"
        static let hospitalBranchName = "hospitalBranchName"
        static let phonePrefix = "phonePrefix"
        static let hospitalPhone = "hospitalPhone"
        static let hospitalWebsite = "hospitalWebsite"
        static let hospitalHelpLinePhone = "hospitalHelpLinePhone"
        static let hospitalFaxNo = "hospitalFaxNo"
        static let hospitalAddress = "hospitalAddress"
        static let hospitalCity = "hospitalCity"
        static let hospitalEmailAddress = "hospitalEmailAddress"
        static let hospitalAbout = "hospitalAbout"
        static let hospitalStatus = "hospitalStatus"
        static let addOn = "addOn"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let clinicRegNo = "clinicRegNo"
        static let clinicState = "clinicState"
        static let clinicAvailableDays = "clinicAvailableDays"
        static let clinicEveningTimeFrom = "clinicEveningTimeFrom"
        static let clinicEveningTimeTo = "clinicEveningTimeTo"
        static let clinicMorningTimeFrom = "clinicMorningTimeFrom"
        static let clinicMorningTimeTo = "clinicMorningTimeTo"
        static let hospitalPinCode = "hospitalPinCode"
        
    }
    
}

public struct checkDuplicateClinic {
    
    /*{"userRef":"QmalxZn4UQEWfSq6","ApiKey":"SKZHTiNhgR6G9TSl","clinicName":"TEST CLINIC","clinicBranch":"Hyderabad"}*/
    
    
    struct  APIRequest {
        
        static let clinicName = "clinicName"
        static let clinicBranch = "clinicBranch"
    }
    
    struct APIResponse {
        static let data = "data"
    }
    
}

public struct AddClinicBasicProfile {
    
    /*{"ApiKey":"SKZHTiNhgR6G9TSl","userRef":"QmalxZn4UQEWfSq6","userType":"2","clinicprefix":"91","clinicName":"TEST CLINIC","clinicBranch":"Hyderabad","clinicnumber":"45454545454","clinicAddress":"sdfsd","pincode":"500072","city":"Hyderabad","clinicLatitude":"56.90","clinicLongitude":"78.9090","clinicAvailableDays":"Sun,Mon","clinicFromTime":"09:00 am","docemailId":"email@id.com","clinicToTime":"05:00 pm"}*/
    
    struct APIRequest  {
        
        static let userType = "userType"
        static let clinicprefix = "clinicprefix"
        static let clinicName = "clinicName"
        static let clinicBranch = "clinicBranch"
        static let clinicnumber = "clinicnumber"
        static let clinicAddress = "clinicAddress"
        static let pincode = "pincode"
        static let city = "city"
        static let clinicLatitude = "clinicLatitude"
        static let clinicLongitude = "clinicLongitude"
        static let clinicAvailableDays = "clinicAvailableDays"
        static let clinicFromTime = "clinicFromTime"
        static let docemailId = "docemailId"
        static let clinicToTime = "clinicToTime"
        static let CountryName = "CountryName"
        
    }
    
    struct APIResponse {
        
        static let hospRef = "hospRef"
        static let hospitalUserRef = "hospitalUserRef"
        static let data = "data"
        
    }
    
}


//MARK: - - - - Doctor Timings API's

public struct getDocTiming {
    
    /*{"userRef":"QmalxZn4UQEWfSq6","ApiKey":"SKZHTiNhgR6G9TSl","hospRef":"uHtORE84ATzJ5oG7"}
     
     {
     data =     (
     {
     "Availablity_updateDate" = "0000-00-00 00:00:00";
     PrefixClinicNo = "";
     "ValidityDays_AvailableTime" = "";
     addOn = "2017-12-08 04:39:48";
     clinicAvailableDays = "";
     clinicEveningTimeFrom = "";
     clinicEveningTimeTo = "";
     clinicMorningTimeFrom = "";
     clinicMorningTimeTo = "";
     clinicName = "";
     clinicNumber = "";
     clinicRegNo = "";
     clinicState = "";
     consulationFee = 96;
     currency = INR;
     days = "Sun,Mon,Tue,Wed,Thu,Fri,Sat";
     endEveningTime = "";
     endMorningTime = "21:28";
     eveningPersonPerHour = "";
     eveningSlotTime = "";
     eveningStatus = 0;
     hospRef = 6aowTZzuAZjgTF4l;
     hospitalAbout = "";
     hospitalAddress = "# 1-112 / 86, Survey No 55/ EE, Kondapur Village, Serilingampally Mandal, Hyderabad, Telangana 500084";
     hospitalBranchName = kondapur;
     hospitalCity = 4460;
     hospitalEmailAddress = "";
     hospitalFaxNo = "";
     hospitalHelpLinePhone = "";
     hospitalId = 33;
     hospitalName = kims;
     hospitalPhone = 4067505050;
     hospitalPinCode = 500084;
     hospitalStatus = 1;
     hospitalUserRef = 6aowTZzuAZjgTF4l;
     hospitalWebsite = "";
     id = 66;
     latitude = "17.4663088";
     longitude = "78.36789449999992";
     morningPersonPerHour = 2;
     morningSlotTime = "00:30";
     morningStatus = 1;
     parentUserRef = Bwqe5oUTjVab4Kg2;
     phonePrefix = 91;
     startEveningTime = "";
     startMorningTime = "21:28";
     status = 1;
     userRef = OGrFNdDl3ar9ZWXy;
     }
     );
     success = true;
     "success_message" = "Your time get successfully.";
     }
     
     
     */
    
    struct APIRequest {
        static let hospRef = "hospRef"
    }
    
    struct APIResponse {
        
        static let data = "data"
        static let isEditable = "isEditable"
        static let Availablity_updateDate = "Availablity_updateDate"
        static let PrefixClinicNo = "PrefixClinicNo"
        static let ValidityDays_AvailableTime = "ValidityDays_AvailableTime"
        static let addOn = "addOn"
        static let clinicAvailableDays = "clinicAvailableDays"
        static let clinicEveningTimeFrom = "clinicEveningTimeFrom"
        static let clinicEveningTimeTo = "clinicEveningTimeTo"
        static let clinicMorningTimeFrom = "clinicMorningTimeFrom"
        static let clinicMorningTimeTo = "clinicMorningTimeTo"
        static let clinicName = "clinicName"
        static let clinicNumber = "clinicNumber"
        static let clinicRegNo = "clinicRegNo"
        static let clinicState = "clinicState"
        static let consulationFee = "consulationFee"
        static let currency = "currency"
        static let days = "days"
        static let endEveningTime = "endEveningTime"
        static let endMorningTime = "endMorningTime"
        static let eveningPersonPerHour = "eveningPersonPerHour"
        static let eveningSlotTime = "eveningSlotTime"
        static let eveningStatus = "eveningStatus"
        static let hospRef = "hospRef"
        static let hospitalAbout = "hospitalAbout"
        static let hospitalAddress = "hospitalAddress"
        static let hospitalBranchName = "hospitalBranchName"
        static let hospitalCity = "hospitalCity"
        static let hospitalEmailAddress = "hospitalEmailAddress"
        static let hospitalFaxNo = "hospitalFaxNo"
        static let hospitalHelpLinePhone = "hospitalHelpLinePhone"
        static let hospitalId = "hospitalId"
        static let hospitalName = "hospitalName"
        static let hospitalPhone = "hospitalPhone"
        static let hospitalPinCode = "hospitalPinCode"
        static let hospitalStatus = "hospitalStatus"
        static let hospitalUserRef = "hospitalUserRef"
        static let hospitalWebsite = "hospitalWebsite"
        static let id = "id"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let morningPersonPerHour = "morningPersonPerHour"
        static let morningSlotTime = "morningSlotTime"
        static let morningStatus = "morningStatus"
        static let parentUserRef = "parentUserRef"
        static let phonePrefix = "phonePrefix"
        static let startEveningTime = "startEveningTime"
        static let startMorningTime = "startMorningTime"
        static let status = "status"
        static let userRef = "userRef"
        
    }
    
    
    
}


public struct setDocTiming {
    
    /*{"userRef":"QmalxZn4UQEWfSq6","ApiKey":"SKZHTiNhgR6G9TSl","hospRef":"uHtORE84ATzJ5oG7","days":"Mon,Tue,Wed,Thu","startMorningTime":"10:00 am","endMorningTime":"12:00 pm","morningSlotTime":"00:30","morningPersonPerHour":"2","morningStatus":"1","currency":"doller","consulationFee":"500"}*/
    
    
    struct APIRequest {
        
        static let hospRef = "hospRef"
        static let days = "days"
        static let startMorningTime = "startMorningTime"
        static let endMorningTime = "endMorningTime"
        static let morningSlotTime = "morningSlotTime"
        static let morningPersonPerHour = "morningPersonPerHour"
        static let morningStatus = "morningStatus"
        static let currency = "currency"
        static let consulationFee = "consulationFee"
        static let ValidityDays_AvailableTime = "ValidityDays_AvailableTime"
        
    }
    
    struct APIResponse {
        
        
    }
}


//MARK: - - - Appointment API's

public struct getDoctorAppointments {
    
    struct APIRequest  {
        static let page = "page"
        static let searchKey = "searchKey"
    }
    
    struct APIResponse {
        
        static let totalRecords = "totalRecords"
        static let data = "data"
        static let amount = "amount"
        static let bookingThrough = "bookingThrough"
        static let bookingRef = "bookingRef"
        static let patUserRef = "patUserRef"
        static let docUserRef = "docUserRef"
        static let bookingType = "bookingType"
        static let bookingDate = "bookingDate"
        static let bookOn = "bookOn"
        static let modifiedOn = "modifiedOn"
        static let startBookingSlot = "startBookingSlot"
        static let endBookingSlot = "endBookingSlot"
        static let disease = "disease"
        static let bookingDeclinedReason = "bookingDeclinedReason"
        static let bookingDeclinedDate = "bookingDeclinedDate"
        static let checkIn = "checkIn"
        static let checkOut = "checkOut"
        static let checkInOutStatus = "checkInOutStatus"
        static let appointmentStatus = "appointmentStatus"
        static let actionReason = "actionReason"
        static let paymentAmount = "paymentAmount"
        static let patProfilePic = "patProfilePic"
        static let patCity = "patCity"
        static let status = "status"
        static let bkPatientName = "bkPatientName"
        static let bkPatientEmail = "bkPatientEmail"
        static let bkPatientMobilePrefix = "bkPatientMobilePrefix"
        static let bkPatientMobileNumber = "bkPatientMobileNumber"
        static let bkPatientDOB = "bkPatientDOB"
        static let bkPatientGender = "bkPatientGender"
        static let cprNumber = "cprNumber"
        static let reason = "reason"
        static let hospitalName = "hospitalName"
        static let hospitalBranchName = "hospitalBranchName"
        static let transaction_id = "transaction_id"
        static let response_code = "response_code"
        static let pt_invoice_id = "pt_invoice_id"
        static let paymentStatus = "paymentStatus"
        static let patmobileNumber = "patmobileNumber"
        static let patemailId = "patemailId"
        static let patName = "patName"
        static let patGender = "patGender"
        static let patDateOfBirth = "patDateOfBirth"
        static let mobilePrefix = "mobilePrefix"
        static let currency = "currency"
        static let uniqueId = "uniqueId"
        static let bookingDeclinedBy = "bookingDeclinedBy"
    }
}

public struct updateDocBooking {
    /*{"ApiKey":"naYJ4gGOBuIrX0FS","userRef":"S2JX8MbHjWi7pVu9","bookingRef": "6pw8qhiXoLzPNcTY","bookingStatus":"3"}*/
    
    struct APIRequest {
        static let bookingRef = "bookingRef"
        static let bookingStatus = "bookingStatus"
    }
    
}

public struct checkInAppointment {
    /*{"ApiKey":"OIxv03jBrOUGAKg8","userRef":"UspJ0gzXZkTdHpOL","bookingRef":"9tul3KOzuIoFNZvA"}*/
    
    struct APIRequest {
        static let bookingRef = "bookingRef"
    }
    
}

//public struct checkOutAppointment {
//
//    struct APIRequest {
//        static let checkOutAppointment = "checkOutAppointment"
//    }
//}
//


//MARK: - - - Menu API

public struct DocMenuUpdates {
    /*{"ApiKey":"OIxv03jBrOUGAKg8","userRef":"UspJ0gzXZkTdHpOL","userType":"2"}
     {
     ConfirmAllApp = 0;
     "clinic_count" = 9;
     pendingApprovals = 0;
     profilefilling = complete;
     success = " true";
     "success_message" = "Data Retrived Successfully.";
     }
     
     iOSAppVersion,AndroidAppVersion,isForcable
     */
    
    struct APIRequest {
        static let userType = "userType"
    }
    
    struct APIResponse {
        
        static let ConfirmAllApp = "ConfirmAllApp"
        static let clinic_count = "clinic_count"
        static let pendingApprovals = "pendingApprovals"
        static let profilefilling = "profilefilling"
        static let notificationCount = "notificationCount"
        static let contact_EmailID = "contact_EmailID"
        static let contact_Mobileno = "contact_Mobileno"
        static let iOSAppVersion = "iOSAppVersion"
        static let isForcable    = "isForcable"
        
    }
}

//MARK: - - - Payments

public struct doctorPaymentList {
    /*{"ApiKey":"OIxv03jBrOUGAKg8","userRef":"UspJ0gzXZkTdHpOL","page":
     "0"}
     
     
     
     */
    
    struct APIRequest {
        static let page = "page"
        
        
    }
    
      struct APIResponse {
        static let data = "data"
        static let totalRecords = "totalRecords"
        static let patName = "patName"
        static let paymentStatus = "paymentStatus"
        static let paymentDateTime = "paymentDateTime"
        static let bookingRef = "bookingRef"
        static let amount = "amount"
        static let currency = "currency"
    }
    
    
}

public struct updateNotificationStatus {
    
    /*{"ApiKey":"O6XFx0JvURrGqtYI","userRef":"7aG0nLXlbtsxI9Nm","page":"0","userType":"2"}*/
    
    struct APIRequest {
        static let page = "page"
        static let userType = "userType"
    }
    
    struct APIResponse {
        
        static let data = "data"
        static let notification = "notification"
        static let notificationMessage = "notificationMessage"
        static let notificationDateTime = "notificationDateTime"
        static let notificationStatus = "notificationStatus"
        static let notificationTitle = "notificationTitle"
        static let totalRecords = "totalRecords"
        
        
    }
}
public struct checkCheckIn {
    
    /*{"ApiKey":"O6XFx0JvURrGqtYI","userRef":"7aG0nLXlbtsxI9Nm","bookingRef":"xKbrQZ94F3gsdTUx"}
     
     CheckIN =     {
     EnableCheckIn = 0;
     bookingDate = "2018-02-21";
     bookingRef = EXucehoWl41gHdBM;
     checkInOutStatus = 0;
     docUserRef = oc1JnjEfn9tNDMwu;
     hospuserRef = wX47RDYp7qt6wmYK;
     patUserRef = GgiBPysoR1wr9I87;
     };
     */
    
    
    struct APIRequest {
        
        static let bookingRef = "bookingRef"
        static let userType = "userType"
    }
    
    struct APIResponse {
        
        static let CheckIN = "CheckIN"
        static let EnableCheckIn = "EnableCheckIn"
        static let bookingDate = "bookingDate"
        static let bookingRef = "bookingRef"
        static let checkInOutStatus = "checkInOutStatus"
        static let docUserRef = "docUserRef"
        static let hospuserRef = "hospuserRef"
        static let patUserRef = "patUserRef"
    }
}


//MARK: - - - API Methods


public enum APICommResponse {
    
    static let success = "success"
    static let success_message = "success_message"
    static let error_message = "error_message"
    
    static let True = "true"
    static let False  = "false"
}


public enum APIMethods {
    
    static let userRegister = "userRegister"
    static let checkOTP = "checkOTP"
    static let resendOTPCode = "resendOTPCode"
    static let docSpecialization = "docSpecialization"
    static let login = "login"
    static let forgotPassword = "forgotPassword"
    static let ForgotPasswordCheckOTP = "ForgotPasswordCheckOTP"
    static let updateForgotPassword = "updateForgotPassword"
    static let checkCurrentPassword = "checkCurrentPassword"
    static let updatePassword = "updatePassword"
    static let docCity = "docCity"
    static let userProfile = "userProfile"
    static let updateBasicProfile = "updateBasicProfile"
    static let updateEduProfile = "updateEduProfile"
    static let updateEduProofs = "updateEduProofs"
    static let updateProfilePic = "updateProfilePic"
    
    static let getDocReqestedBooking = "getDocBookingReq"
    static let getDocUpcomingBooking = "getDocUpcomingBooking"
    static let getDocPastBooking = "getDocPastBooking"
    static let getDocDeclinedBooking = "getDocDeclinedBooking"
    
    static let updateDocBooking = "updateDocBooking"
    static let checkInAppointment = "checkInAppointment"
    static let checkOutAppointment = "checkOutAppointment"
    
    static let cliniListbyDocref = "cliniListbyDocref"
    static let addClinicBasicProfile = "addClinicBasicProfile"
    static let searchClinics = "searchClinics"
    static let getClinicinfo = "getClinicinfo"
    static let checkDuplicateClinic = "checkDuplicateClinic"
    
    static let DocMenuUpdates = "DocMenuUpdates"
    
    static let setDocTiming = "setDocTime"
    static let getDocTiming = "getDocTiming"
    
    static let doctorPaymentList = "doctorPaymentList"
    
    static let updateDocSetting = "updateDocSetting"
    
    static let logOut = "logOut"
    
    static let checkCheckIn = "checkCheckIn"
    
    static let updateNotificationStatus = "updateNotificationStatus"
    
    static let getCountries = "getCountries"
    
}

public struct getCountriesList{
    
    struct APIResponse {
        
        static let Countries  = "Countries"
        static let CountryName = "CountryName"
        static let PhoneCode = "PhoneCode"
        static let ShortName = "ShortName"
        static let TimeZone = "TimeZone"
        static let maxNumberLength = "maxNumberLength"
        static let minNumberLength = "minNumberLength"
        static let Currency = "Currency"
        
        
    }
}


public struct clinicsCoreDataList{
    struct EntityName {
        static let ClinicList = "ClinicList"
    }
    
    struct Attributes {
        static let hospitalBranchName = "hospitalBranchName"
        static let hospitalHelpLinePhone = "hospitalHelpLinePhone"
        static let hospitalName = "hospitalName"
    }
    
}


public struct settingsCoreDataList{
    struct EntityName {
        static let Settings = "Settings"
    }
    
    struct Attributes {
        
        static let clinic_count = "clinic_count"
        static let confirmAllApp = "confirmAllApp"
        static let contact_EmailID = "contact_EmailID"
        static let contact_Mobileno = "contact_Mobileno"
        static let iOSAppVersion = "iOSAppVersion"
        static let isForcable = "isForcable"
        static let notificationCount = "notificationCount"
        static let pendingApprovals = "pendingApprovals"
        static let profilefilling = "profilefilling"

    }
    
}


public struct ProfileDetailsCoreDataList{
    struct EntityName {
        static let ProfileDetails = "ProfileDetails"
    }
    
    struct Attributes {
        
        static let personalDetails = "personalDetails"
        static let specialization = "specialization"
       
    }
    
}

public struct AppointmentDetailsCoreDataList{
    struct EntityName {
        static let Appointments = "Appointments"
    }
    
    struct Attributes {
        
        static let appointmentData = "appointmentData"
        static let  appointID = "appointID"
        static let  appointType = "appointType"
        
        
    }
    
}

public struct SpecializationDetailsCoreDataList{
    struct EntityName {
        static let Specialization = "Specialization"
    }
    
    struct Attributes {
        
        static let specialization = "specialization"
        
    }
    
}
