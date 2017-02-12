//
//  AppDelegate.swift
//  tomatoes-ios
//
//  Created by Giorgia Marenda on 2/5/17.
//  Copyright © 2017 Giorgia Marenda. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let dashboardController = DashboardViewController()
        navigationController = UINavigationController(rootViewController: dashboardController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if TomatoesTimer.instance.secondsCounter > 0 {
            UserDefaults.standard.set(TomatoesTimer.instance.secondsCounter, forKey: "timer_counter")
            UserDefaults.standard.set(Date(), forKey: "background_time")
            UserDefaults.standard.synchronize()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        let timerCounter = UserDefaults.standard.double(forKey: "timer_counter")
        if timerCounter > 0, let lastUpdate = UserDefaults.standard.object(forKey: "background_time") as? Date {
            let diff = Date().timeIntervalSince1970 - lastUpdate.timeIntervalSince1970
            if timerCounter - diff > 0 {
                TomatoesTimer.instance.secondsCounter = timerCounter - diff
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

