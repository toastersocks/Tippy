//
//  main.swift
//  Tippy
//
//  Created by James Pamplona on 5/17/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit


autoreleasepool {
    debug {
        StartupTimeProfiler.addEvent("App start")
    }
    
    UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(UIApplication), NSStringFromClass(AppDelegate))
}
