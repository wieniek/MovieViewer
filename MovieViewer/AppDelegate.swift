//
//  AppDelegate.swift
//  MovieViewer
//
//  Created by Wieniek Sliwinski on 3/28/17.
//  Copyright © 2017 Home User. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // Programatically set global colors
    let skyBlue = UIColor(red: 102/255, green: 204/255, blue: 255/255, alpha: 1.0)
    UINavigationBar.appearance().tintColor = UIColor.black
    UINavigationBar.appearance().barTintColor = skyBlue
    UIScrollView.appearance().backgroundColor = skyBlue
    return true
  }
}

