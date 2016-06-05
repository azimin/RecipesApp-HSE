//
//  AppDelegate.swift
//  RecipesApp
//
//  Created by Alex Zimin on 16/05/16.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    DataModelController.sharedInstance.setup()
    DataModelController.sharedInstance.loadDataIfNeeded()
    
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
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func application(application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
    return true
  }
  
  func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
    if userActivity.activityType == CSSearchableItemActionType {
      let dishId = userActivity.userInfo![CSSearchableItemActivityIdentifier]!
      let dish = realmDataBase.objects(DishEntity).filter("id = '\(dishId)'").first
      
      let recieptViewController = Storyboard.Reciept.storyboard.instantiateViewController() as RecipeTableViewController
      recieptViewController.dish = dish
      
      (self.window!.rootViewController as! UINavigationController).pushViewController(recieptViewController, animated: false)
      
      return true
    }
    return false
  }
  
}

