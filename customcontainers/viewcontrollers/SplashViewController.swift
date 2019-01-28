//
//  SplashViewController.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

final class SplashViewController: UIViewController {
	
	// MARK: - UIViewController overrides
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// This splash view controller simply leaves after 3 seconds
		DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(3)) {
			self.performSegue(withIdentifier: .showTutorial, sender: self)
		}
	}
}
