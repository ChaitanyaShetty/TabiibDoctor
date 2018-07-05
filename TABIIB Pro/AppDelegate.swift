//
//  AppDelegate.swift
//  TABIIB Pro
//
//  Created by SMSCountry Networks Pvt. Ltd on 28/03/18.
//  Copyright © 2018 SMSCountry Networks Pvt. Ltd. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import FirebaseInstanceID
import FirebaseCrash
import Fabric
import Crashlytics
import GoogleMaps
import GooglePlaces
import CoreData


enum ThreeDTocuhIdentifer : String {
    case ViewAppointments
    case ViewPayments
    case ViewClinics
    init?(identifer : String) {
        guard let shortIdentifier = identifer.components(separatedBy: ".").last else {
            return nil
        }
        self.init(rawValue: shortIdentifier)
    }
}


extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigationcontorObj = UINavigationController()
    var selectedStoryboard : UIStoryboard!
    var isAlertVisible : Bool = false
    
    func logUser() {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
//        Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
//        Crashlytics.sharedInstance().setUserIdentifier("12345")
//        Crashlytics.sharedInstance().setUserName("Test User")
        Crashlytics.sharedInstance().setUserEmail(UserDefaultStore.emailId)
        Crashlytics.sharedInstance().setUserIdentifier(UserDefaultStore.mobileNumber)
        Crashlytics.sharedInstance().setUserName(UserDefaultStore.userID)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // TODO: Move this to where you establish a user session
        self.logUser()


        
        L102Localizer.DoTheMagic()
        
        GMSPlacesClient.provideAPIKey("AIzaSyCbY-aVg_Yfe5zuvCyAcZ-wCVNjhz5BgBU")
        GMSServices.provideAPIKey("AIzaSyCbY-aVg_Yfe5zuvCyAcZ-wCVNjhz5BgBU")
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        Fabric.sharedSDK().debug = true
        
        Fabric.with([Crashlytics.self])
        
        UserDefaultStore.deviceID = DeviceUID.uid()
      //  selectedStoryboard =  UIStoryboard.init(name: "Main", bundle: nil)
        
        // UIApplication.shared.statusBarView?.backgroundColor = Constatns.ThemeColour()
        
        //        if UserDefaultStore.checkMedicalNumber == nil{
        //            Regis0tration.APIRequest.prevUserRef = ""
        //        }
        
        UserDefaultStore.checkMedicalNumber = ""
        
        if UserDefaultStore.isLogined == nil {
            UserDefaultStore.isLogined = "0"
        }
        
        if UserDefaultStore.selectedLanguage == nil{
            if L102Language.currentAppleLanguage() == "ar" {
                UserDefaultStore.selectedLanguage = "1"
            }
            else{
                UserDefaultStore.selectedLanguage = "0"
            }
        }
        if UserDefaultStore.selectedLanguage == nil{
            UserDefaultStore.selectedLanguage = "0"
        }
        if UserDefaultStore.DeviceToken == nil {
            UserDefaultStore.DeviceToken = "0"
        }
        
        
        
        if UserDefaultStore.appVersion == nil {
            //firstime using to cehck app update
            UserDefaultStore.appVersion = Utilities.sharedInstace.getVersion()
        }
        else{
            let strofPreviousVersion = UserDefaultStore.appVersion
            let newVersion = Utilities.sharedInstace.getVersion()
            if strofPreviousVersion == newVersion {
                print("no update")
            }
            else{
                print("app updated")
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            selectedStoryboard =  UIStoryboard.init(name: "Main", bundle: nil)
        }
        else if UIDevice.current.userInterfaceIdiom == .pad {
            selectedStoryboard =  UIStoryboard.init(name: "Main_iPad", bundle: nil)
        }
        
        //for testing
        //  UserDefaultStore.isLogined = "0"
        
        if UserDefaultStore.isLogined == "0" {
            let aboutVC = selectedStoryboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
            // let aboutVC = selectedStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            navigationcontorObj = UINavigationController.init(rootViewController: aboutVC)
        }
        else{
            let homeview = selectedStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            navigationcontorObj = UINavigationController.init(rootViewController: homeview)
            navigationcontorObj.isNavigationBarHidden = true
        }
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = 0
        
       
        
        NSSetUncaughtExceptionHandler { (exception) in
            
            DispatchQueue.global(qos: .background).async {
                
                let nreError = NSError.init(domain: Bundle.main.bundleIdentifier!, code: exception.hashValue, userInfo: exception.userInfo as? [String : Any])
                
                Crashlytics.sharedInstance().recordError(nreError)
                
//                Crashlytics.sharedInstance().crash()
                
                FirebaseCrashMessage(exception.reason!)
                
                
            }
        }
        //
        
        
        navigationcontorObj.isNavigationBarHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = navigationcontorObj
        //
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        
        return true
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            //            print("InstanceID token: \(refreshedToken)")
            UserDefaultStore.DeviceToken = refreshedToken as String
            //            print(UserdefaultsStored.DeviceToken)
        }
        
        
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return;
        }
        
        
        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().shouldEstablishDirectChannel = false
        Messaging.messaging().shouldEstablishDirectChannel = true
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        window?.endEditing(true)
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if self.isAlertVisible == false {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "AppisFromBackground"), object: nil)
        }
        
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //
    //    func applicationReceivedRemoteMessagefromappclose(remoteMessg : MessagingRemoteMessage)  {
    //
    //
    //    }
    
    // [START receive_message]
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "test2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        
        
        //        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        
        
        //        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //        print("Unable to register for remote notifications: \(error.localizedDescription)")
        
        if UserDefaultStore.DeviceToken == nil {
            UserDefaultStore.DeviceToken = ""
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.`
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.sandbox)
        //        InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.prod)
        
        //        print("Firebase Token:",FIRInstanceID.instanceID().token() ?? "")
        
    }
    
}


// [START ios_10_message_handling]
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let dicotfNotifi : NSDictionary = notification.request.content.userInfo as NSDictionary
        //   print("data fomr push notifications :\(dicotfNotifi)")
        
        //        TabiibUtility.showAlertviewWithMessage(stroftitle: "notification received", strofMsg: "")
        
        
        //        if dicotfNotifi.allKeys.count > 0{
        //        imageUrlIs = "https://s3-ap-southeast-1.amazonaws.com/wanasatime/movie_images/VICEROYs__HOUSE080317030334_featurebanner.png"
        //        createLocalNotificationwithReservationCode(strofMsg: "Hello",strofTitle: "Hello")
        //        }
        //
        completionHandler([.alert,.badge,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo as NSDictionary
        //  print("notification response didreceive with completion :\(userInfo)")
        // Print message ID.
        completionHandler()
        
    }
    
    
}


// [START ios_10_data_message_handling]
extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        
        if let refreshedToken = InstanceID.instanceID().token() {
            UserDefaultStore.DeviceToken = refreshedToken as String
        }
        
        print( InstanceID.instanceID().token())
        
        //check if user is login update his device token
        if UserDefaultStore.isLogined == "1" {
            // updateUserDeviceToken()
        }
        connectToFcm()
        
    }
    
    
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
        
        //  print(remoteMessage.appData)
        let dictofDNotificati : NSDictionary = remoteMessage.appData as NSDictionary
        
        print("notifcaiotn user info")
        //   print(dictofDNotificati)
        
    }
    
    // Receive data message on iOS 10 devices while app is in the foreground.
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        
        // print(remoteMessage.appData)
        let dictofDNotificati : NSDictionary = remoteMessage.appData as NSDictionary
        
        // print("notifcaiotn user info")
        // print(dictofDNotificati)
        
        //        TabiibUtility.showAlertviewWithMessage(stroftitle: "notification received", strofMsg: dictofDNotificati.object(forKey: "message") as! String)
        
        
        //        print(dictofDNotificati["image"] as! String)
        
        //        imageUrlIs = dictofDNotificati["image"]! as? String
        
        //        if #available(iOS 10, *) {
        //            createLocalNotificationwithReservationCode(strofMsg: dictofDNotificati["body"]! as! String,strofTitle: dictofDNotificati["title"]! as! String)
        //        } else {
        //            // Fallback on earlier versions
        //        }
        
    }
    //
    
}
//MARK: - - -  3D Touch Delegate Methods
extension AppDelegate {
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        completionHandler(shouldPerformActionForIdentifer(shortcutItem))
    }
    public func shouldPerformActionForIdentifer(_ shortcutItem : UIApplicationShortcutItem) -> Bool {
        let shortcutItemis = shortcutItem.type
        
        guard  let shortcutIDentifiet = ThreeDTocuhIdentifer.init(identifer: shortcutItemis) else {
            return false
        }
        return selectedShortcutIdentifer(shortcutIDentifiet)
    }
    
    private func selectedShortcutIdentifer(_ Identifier : ThreeDTocuhIdentifer) -> Bool {
        if UserDefaultStore.isLogined == "1" {
            
            
            let homeview = selectedStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            
            homeview.addObserver()
            
            
            
            
            switch Identifier {
            case .ViewAppointments:
                
                NotificationCenter.default.post(name: NSNotification.Name.init("ViewAppointments"), object: nil)
                
                
                return true
                
            case .ViewPayments :
                
                NotificationCenter.default.post(name: NSNotification.Name.init("ViewPayments"), object: nil)
                
                return true
                
            case .ViewClinics :
                
                NotificationCenter.default.post(name: NSNotification.Name.init("ViewClinics"), object: nil)
                
                return true
                
                
            }
            
            
        }else{
            return false
            
        }
        
    }
    
}






