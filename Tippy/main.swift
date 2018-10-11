//
//  main.swift
//  Tippy
//
//  Created by James Pamplona on 5/17/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit


autoreleasepool {
//    debug {
        StartupTimeProfiler.addEvent("App start")
//    }
    UIApplicationMain(CommandLine.argc,
                      UnsafeMutableRawPointer(CommandLine.unsafeArgv)
                        .bindMemory(to: UnsafeMutablePointer<Int8>.self,
                                    capacity: Int(CommandLine.argc)),
                      NSStringFromClass(UIApplication.self),
                      NSStringFromClass(AppDelegate.self))
}
