//
//  AppDelegate.swift
//  SubScriptionDemo
//
//  Created by SOTSYS113 on 17/11/17.
//  Copyright © 2017 SOTSYS113. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        DispatchQueue.main.async {
            SalesManager.sharedInstance().cacheProducts()

        }
        self.checkSubscription()

        return true
    }
    func checkSubscription(){
        SKPaymentQueue.default().add(SalesManager.sharedInstance())
        SalesManager.sharedInstance().validateReceipe {
            //get purchased id
            var productSubscribed: String = SalesManager.sharedInstance().subscribedProductIdIfAny()
            if productSubscribed.characters.count > 0
            {
                print("----product id subscribed to : \(productSubscribed)")
                let subscriptionStatusCode: String = SalesManager.sharedInstance().subscriptionStatusCode(fromProductID: productSubscribed)
                print("----subscription status code to : \(subscriptionStatusCode)")
                if (subscriptionStatusCode == keySubscriptionOneMonthly){
                }
                if (subscriptionStatusCode == keySubscriptionThreeMonthly){
                }
                if (subscriptionStatusCode == keySubscriptionSixMonthly){
                }
                if (subscriptionStatusCode == keySubscriptionTwelveMonthly){
                }
                if (subscriptionStatusCode == keySubscriptionBoosterPack){
                }
            }
            else{
                
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

