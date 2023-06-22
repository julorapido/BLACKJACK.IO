//
//  AppDelegate.swift
//  Blackjack.io
//
//  Created by Jules Sainthorant on 10/10/2021.
//

import UIKit
//import GoogleMobileAds
import SpriteKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UISceneDelegate , SKSceneDelegate {

    var window: UIWindow?
    
    var bruh = LaunchScreen()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //FirebaseApp.configure()
       // GADMobileAds.sharedInstance().start(completionHandler: nil)
        //GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID ]
        //GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID ]
        
        return true
    }
    func applicationDidFinishLaunching(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


}

