//
//  main.swift
//  Tippy
//
//  Created by James Pamplona on 5/17/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit


autoreleasepool {
    #if DEBUG
        StartupTimeProfiler.addEvent("App start")
    #endif
    
    UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(UIApplication), NSStringFromClass(AppDelegate))
}
