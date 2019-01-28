//
//  TutorialViewController.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

final class TutorialViewController: UIViewController {
	
	// MARK: - UIViewController overrides
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		UserDefaults.standard.set(true, forKey: "userHasSeenTutorial")
	}
}
