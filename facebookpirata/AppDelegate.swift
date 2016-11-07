//
//  AppDelegate.swift
//  facebookpirata
//
//  Created by movil7 on 04/11/16.
//  Copyright © 2016 movil7. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        
        if #available(iOS 10.0, *) {
        
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_,_ in })
            
            UNUserNotificationCenter.current().delegate = self
            FIRMessaging.messaging().remoteMessageDelegate = self
            
            
        } else {
        
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge,.sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        
            
        }

        
        
        //        if #available(iOS 8.0, *) {
        //
        //            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge,.sound], categories: nil)
        //            application.registerUserNotificationSettings(settings)
        //            application.registerForRemoteNotifications()
        //
        //        } else {
        //
        //            let types: UIRemoteNotificationType = [.alert, .badge, .sound]
        //            application.registerForRemoteNotifications(matching: types)
        //            
        //        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(notification:)), name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //si no esta activa se pasa a desconectado
        FIRMessaging.messaging().disconnect()
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
        FBSDKAppEvents.activateApp()
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //llamado facebook
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    
    func tokenRefreshNotification(notification: NSNotification) {
        let refreshToken = FIRInstanceID.instanceID().token()
        print("InstanceID Token: \(refreshToken)")
        connectToFCM()
    }
    
    func connectToFCM() {
        FIRMessaging.messaging().connect {
         error in
            if error != nil {
                print("No se pudo conectar \(error)")
            } else {
                print("conectado a FCM")
            }
        }
        
        
    }


}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        print("Message ID: \(userInfo["gcm.message_id"])")
        print("%@", userInfo)
        
        let alertController = UIAlertController(title: "Push Not", message: "\(userInfo)", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
}
extension AppDelegate: FIRMessagingDelegate {

    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
    }
    
}













