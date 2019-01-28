//
//  Splash-StoryboardExtensions.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

extension SplashViewController: SegueHandling {
	
	/// Segues defined in the UIStoryboard that we can invoke programmatically
	///
	/// - leaveSplash: unwinds to RootViewController, which will decide what to do next
	/// - showTutorial: directly navigates to the Tutorial screen
	internal enum SegueIdentifier: String {
		case leaveSplash
		case showTutorial
	}
}
