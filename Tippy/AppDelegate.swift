//
//  AppDelegate.swift
//  Tippy
//
//  Created by James Pamplona on 5/27/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit
//import Mixpanel
#if DEBUG
    import func AudioToolbox.AudioServicesPlayAlertSound
#endif
//@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        /*
        #if !DEBUG
            _ = Mixpanel.initialize(token: "7d099edd7dcdb4e8fd8e8776a40361b9")
        #endif
        */
        
        if isTakingScreenshots() {
            // Clean up status bar
        }
//        debug {
            StartupTimeProfiler.addEvent("App finished launching")
            print("Total startup time: \(StartupTimeProfiler.totalTime)")
//        }
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        debug {
            StartupTimeProfiler.addEvent("App did finish loading")
            print("Total time to active: \(StartupTimeProfiler.totalTime)")
//        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        #if DEBUG
        AudioServicesPlayAlertSound(1103)
        #else
            Mixpanel.mainInstance().track(event: "Low memory")
        #endif
    }
}

