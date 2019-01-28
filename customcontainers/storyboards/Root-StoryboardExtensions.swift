//
//  Root-StoryboardExtensions.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

extension RootViewController /* Interface Builder Actions */ {
	
	// IBActions do not have to go into extensions, but this is a way you can move
	// storyboard-specific details out of the ViewController code if it suits you.
	// In the case of this sample, it is a way to separate out interesting code
	// for the presentation.
	
	@IBAction private func unwindToRoot(_ segue: UIStoryboardSegue) {
		// Switch on the ViewController that initiated the unwind. Where should we go next?
		switch segue.source {
		case is SplashViewController:
			// Skip the Tutorial if the user has already seen it
			if UserDefaults.standard.bool(forKey: "userHasSeenTutorial") {
				performSegue(withIdentifier: .showSketch, sender: self)
			} else {
				performSegue(withIdentifier: .showTutorial, sender: self)
			}
		case is TutorialViewController:
			// Always go to the sketch ViewController when leaving the Tutorial ViewController
			performSegue(withIdentifier: .showSketch, sender: self)
		default:
			break
		}
	}
}

extension RootViewController: SegueHandling {
	
	/// Segues defined in the UIStoryboard that we can invoke programmatically
	///
	/// - showSketch: directly navigates to the Sketch screen
	/// - showSplash: directly navigates to the Splash screen
	/// - showTutorial: directly navigates to the Tutorial screen
	internal enum SegueIdentifier: String {
		case showSketch
		case showSplash
		case showTutorial
	}
}
