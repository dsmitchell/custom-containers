//
//  ContainerViewController.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

open class ContainerViewController: UIViewController {
	
	// MARK: - Public properties and methods
	
	/// The currently active UIViewController
	public var activeViewController: UIViewController? {
		get { return _activeViewController }
		set { setActiveViewController(newValue, duration: activeViewControllerTransitionDuration) }
	}
	
	/// The animation transition duration when setting a new activeViewController
	open var activeViewControllerTransitionDuration: TimeInterval {
		return 0.2
	}
	
	/// Optional override to the activeViewController's container view
	@IBOutlet public var viewControllerContainerView: UIView?
	
	/// Sets a new activeViewController using the provided duration for the animated transition
	///
	/// - Parameters:
	///   - activeViewController: The new activeViewController instance
	///   - duration: How long to animate the transition
	///   - completion: A completion closure when the transition is complete
	open func setActiveViewController(_ activeViewController: UIViewController?, duration: TimeInterval, completion: (() -> Void)? = nil) {
		
		guard _activeViewController !== activeViewController else {
			completion?()
			return
		}
		// ViewController lifecycle for this Container's children mimics that of a UIViewController pushed and popped in a UINavigationController
		manualAppearanceHandling = view.window != nil
		
		// Let the outgoing ViewController know first that it's about to be replaced by another
		let deactivatingViewController = _activeViewController
		deactivatingViewController?.willMove(toParent: nil)
		
		_activeViewController = activeViewController
		if let activeViewController = activeViewController {
			// Prepare the incoming ViewController for the transition
			if activeViewController.parent != self {
				addChild(activeViewController)
			}
			let containerView = viewControllerContainerView ?? view!
			// viewDidLoad() should happen below. If not, someone has prematurely read .view
			activeViewController.view.alpha = 0
			// Ensure the child's frame matches and resizes with the container
			activeViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
			activeViewController.view.frame = containerView.bounds
			activeViewController.view.translatesAutoresizingMaskIntoConstraints = true
			containerView.addSubview(activeViewController.view)
		}
		if manualAppearanceHandling {
			deactivatingViewController?.beginAppearanceTransition(false, animated: duration > 0)
			activeViewController?.beginAppearanceTransition(true, animated: duration > 0)
		}
		
		UIView.animate(withDuration: max(0, duration), animations: {
			// Crossfade the two ViewControllers
			activeViewController?.view.alpha = 1
			deactivatingViewController?.view.alpha = 0
		}, completion: { finished in
			// Complete the transition for the outgoing ViewController
			deactivatingViewController?.view.removeFromSuperview()
			if self.manualAppearanceHandling {
				deactivatingViewController?.endAppearanceTransition()
			}
			deactivatingViewController?.removeFromParent()
			// Give the incoming ViewController the last say in this transition
			if self.manualAppearanceHandling {
				activeViewController?.endAppearanceTransition()
			}
			activeViewController?.didMove(toParent: self)
			self.manualAppearanceHandling = false
			completion?()
		})
	}
	
	// MARK: - UIViewController overrides
	
	override open var shouldAutomaticallyForwardAppearanceMethods: Bool {
		// We sometimes want to handle child viewDid/WillAppear, etc. ourselves
		return !manualAppearanceHandling
	}
	
	// MARK: - Private properties
	
	private var _activeViewController: UIViewController?
	private var manualAppearanceHandling = false
}
