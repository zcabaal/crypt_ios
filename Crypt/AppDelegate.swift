//
//  AppDelegate.swift
//  Crypt
//
//  Created by Mac Owner on 15/10/2015.
//  Copyright © 2015 Crypt transfer. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Optimizely
import TwitterKit
import Braintree
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        App.sharedInstance.lock.applicationLaunchedWithOptions(launchOptions)
        Fabric.with([Twitter.self, STPAPIClient.self, Crashlytics.self, Optimizely.self])
        Optimizely.startOptimizelyWithAPIToken(App.optimizelyKey, launchOptions:launchOptions)
        BTAppSwitch.setReturnURLScheme(App.braintreeURL)
        Stripe.setDefaultPublishableKey(App.stripePKey)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        GlobalPrefs.sharedInstance.fetch(2)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if url.scheme.localizedCaseInsensitiveCompare(App.braintreeURL) == .OrderedSame {
            return BTAppSwitch.handleOpenURL(url, sourceApplication:sourceApplication)
        }else{
            return App.sharedInstance.lock.handleURL(url, sourceApplication: sourceApplication)
        }
        
    }



}

