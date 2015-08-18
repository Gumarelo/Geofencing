//
//  AppDelegate.swift
//  Geotify
//
//  Created by Ken Toh on 24/1/15.
//  Copyright (c) 2015 Ken Toh. All rights reserved.
//  
//  Tutorial creado a partir de este ejemplo: http://www.raywenderlich.com/95014/geofencing-ios-swift
//
//Configuramos a nuestro AppDelegate pare recibir eventos relacionados a geofence.
//Geofences registered by an app are monitored at all times, including when the app isn’t running. If the device triggers a geofence event while the app isn’t running, iOS automatically relaunches the app directly into the background. This makes the AppDelegate an ideal entry point to handle the event, as the view controller may not be loaded or ready.

//  A geofence event is triggered only when iOS detects a boundary crossing. If the user is already within a geofence at the point of registration, iOS won’t generate an event. If you need to query whether the device location falls within or outside a given geofence, Apple provides a method called requestStateForRegion(_:).

import UIKit
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

  var window: UIWindow?
  
  let locationManager = CLLocationManager()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    locationManager.delegate = self
    
    locationManager.requestAlwaysAuthorization()
    
    application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Sound | .Alert | .Badge, categories: nil))
    UIApplication.sharedApplication().cancelAllLocalNotifications()
    
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
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  // If the app is active, the code above simply shows an alert controller with the note as the message. Otherwise, it presents a location notification with the same message.
  func handleRegionEvent(region: CLRegion!) {
    // Show an alert if application is active
    if UIApplication.sharedApplication().applicationState == .Active {
      if let message = notefromRegionIdentifier(region.identifier) {
        if let viewController = window?.rootViewController {
          showSimpleAlertWithTitle(nil, message: message, viewController: viewController)
        }
      }
    } else {
      // Otherwise present a local notification
      var notification = UILocalNotification()
      notification.alertBody = notefromRegionIdentifier(region.identifier)
      notification.soundName = "Default";
      UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
  }
  
  func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
    if region is CLCircularRegion {
      handleRegionEvent(region)
    }
  }
  
  func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
    if region is CLCircularRegion {
      handleRegionEvent(region)
    }
  }
  
  // This helper method retrieves the geotification note from the persistence store, given the geotification identifier. It fetches and unarchives the stored geotifications from NSUserDefaults and loops through each geotification by comparing its identifier with the input identifier. Once the method finds the geotification, it returns the accompanying note.
  func notefromRegionIdentifier(identifier: String) -> String? {
    if let savedItems = NSUserDefaults.standardUserDefaults().arrayForKey(kSavedItemsKey) {
      for savedItem in savedItems {
        if let geotification = NSKeyedUnarchiver.unarchiveObjectWithData(savedItem as! NSData) as? Geotification {
          if geotification.identifier == identifier {
            return geotification.note
          }
        }
      }
    }
    return nil
  }
}

