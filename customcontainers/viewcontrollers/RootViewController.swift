//
//  RootViewController.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

final class RootViewController: ContainerViewController {
	
	// MARK: - ContainerViewController overrides
	
	override func setActiveViewController(_ activeViewController: UIViewController?, duration: TimeInterval, completion: (() -> Void)? = nil) {
		// Inform UIAccessibility that the screen is different
		super.setActiveViewController(activeViewController, duration: duration) {
			completion?()
			UIAccessibility.post(notification: .screenChanged, argument: nil)
		}
	}
	
	// MARK: - UIViewController overrides
	
	override func show(_ vc: UIViewController, sender: Any?) {
		// Show segues should simply replace the currently active view controller
		activeViewController = vc
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// On initial load, seamlessly switch from the LaunchScreen storyboard to the Splash
		// storyboard by setting the splash view controller as the "active" view controller
		performSegue(withIdentifier: .showSplash, sender: self)
		// If you were using UIStateRestoration, you might want to switch somewhere else
	}
	
	// MARK: - Public methods
	
	public func showTutorial() {
		performSegue(withIdentifier: .showTutorial, sender: self)
	}
}
