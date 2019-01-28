//
//  AppDelegate.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
	
	// MARK: - Public properties
	
	var rootViewController: RootViewController {
		return window!.rootViewController as! RootViewController
	}

	// MARK: - UIApplicationDelegate properties and methods
	
	var window: UIWindow?
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		guard let scheme = url.scheme, scheme == "demo", let host = url.host else {
			return false
		}
		switch host.lowercased() {
		case "opentutorial":
			rootViewController.showTutorial()
			return true
		default:
			return false
		}
	}
}
