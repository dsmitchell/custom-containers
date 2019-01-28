//
//  Tutorial-StoryboardExtensions.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

extension TutorialViewController: SegueHandling {
	
	/// Segues defined in the UIStoryboard that we can invoke programmatically
	///
	/// - leaveTutorial: unwinds to RootViewController, which will decide what to do next
	/// - showSketch: directly navigates to the Sketch screen
	internal enum SegueIdentifier: String {
		case leaveTutorial
		case showSketch
	}
}
