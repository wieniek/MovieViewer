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
    UITabBar.appearance().tintColor = UIColor.black
    UITabBar.appearance().barTintColor = skyBlue
    
    // Get handle to the storyboard
    window = UIWindow(frame: UIScreen.main.bounds)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    // Create navigation and view controllers for now_playing
    let nowPlayingNavigationController = storyboard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
    
    let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MoviesViewController
    nowPlayingViewController.endPoint = "now_playing"
    nowPlayingViewController.tabBarItem.title = "Now Playing"
    nowPlayingViewController.tabBarItem.image = UIImage(named: "now_playing")
    
    // Create navigation and view controllers for top_rated
    let topRatedNavigationController = storyboard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
    
    let topRatedViewController = topRatedNavigationController.topViewController as! MoviesViewController
    
    topRatedViewController.endPoint = "top_rated"
    topRatedViewController.tabBarItem.title = "Top Rated"
    topRatedViewController.tabBarItem.image = UIImage(named: "top_rated")
    
    // Create tab bar controller with two navigation controllers
    let tabBarController = UITabBarController()
    tabBarController.viewControllers = [nowPlayingNavigationController, topRatedNavigationController]
    
    // Set initial view controller
    window?.rootViewController = tabBarController
    window?.makeKeyAndVisible()
    
    return true
  }
}

