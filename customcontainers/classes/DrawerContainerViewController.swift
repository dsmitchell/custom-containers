//
//  DrawerContainerViewController.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

/// A container view controller that contains drawers opened by buttons
open class DrawerContainerViewController: ContainerViewController {
	
	//  This sample may only have one kind of "drawer container" ViewController, but
	//  imagine if your app or framework needed to support multiple kinds. We've created
	//  a separate DrawerContainerViewController to embody the basic behavior of a drawer
	//  that shows and hides a set of controls in a stack view. It also provides a method
	//  to mark a particular button as the "selected" button (via updateButtons)
	
	// MARK: - Interface Builder outlets
	
	@IBOutlet var buttonStackView: UIStackView!
	
	// MARK: - ContainerViewController overrides
	
	override open var activeViewControllerTransitionDuration: TimeInterval {
		return 0.3
	}
	
	override open func setActiveViewController(_ activeViewController: UIViewController?, duration: TimeInterval, completion: (() -> Void)? = nil) {
		// This override splits up the base behavior into 3 stages:
		//  - animate away any existing active view controller (set activeViewController = nil)
		//  - animate any change to the preferred content size (modify self.preferredContentSize inside an animation block)
		//  - animate in the new active view controller (set activeViewController to new value)
		var childSize = CGSize.zero
		if let viewController = activeViewController {
			addChild(viewController) // Add child now because we may access the view, and we want to provide a consistent order of events
			childSize = viewController.preferredContentSize
			if childSize == .zero { // Fallback if Interface Builder doesn't have a value for this
				childSize = viewController.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
			}
		} else { // let's reset the lastSegueIdentifier
			lastSegueIdentifier = nil
		}
		let desiredSize = preferredContentSizeForDrawerContentSize(childSize)
		let divisor: Double = self.activeViewController == nil || activeViewController == nil ? 1.0 : 2.0
		// super.setActiveViewController shortcuts when there's no change (e.g. if the activeViewController is already nil)
		if preferredContentSize == desiredSize {
			let durationSlice = duration / divisor
			super.setActiveViewController(nil, duration: durationSlice) {
				super.setActiveViewController(activeViewController, duration: durationSlice, completion: completion)
			}
		} else {
			let durationSlice = duration / (divisor + 1.0)
			super.setActiveViewController(nil, duration: durationSlice) {
				UIView.animate(withDuration: durationSlice, animations: {
					self.preferredContentSize = desiredSize
				}, completion: { finished in
					super.setActiveViewController(activeViewController, duration: durationSlice, completion: completion)
				})
			}
		}
	}
	
	// MARK: - UIViewController overrides
	
	override open func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		// If this identifier matches the previous, return false so that we can dismiss instead
		guard identifier != lastSegueIdentifier else {
			closeDrawer()
			return false
		}
		// Otherwise make sender the "active" button and allow the segue to continue
		updateButtons(makeActive: sender as? UIButton)
		lastSegueIdentifier = identifier
		return true
	}
	
	override open func showDetailViewController(_ vc: UIViewController, sender: Any?) {
		// Like Show, we want ShowDetail segues to replace the currently active ViewController.
		// Why not a Show segue? Because logically our Drawer itself doesn't hide when showing
		// the child. But more importantly, we want any possible Show segues from a child to
		// pass to this ViewController's ancestor, and implementing Show here would prevent that
		activeViewController = vc
	}
	
	// MARK: - Public methods
	
	open func closeDrawer() {
		// Removes the activeViewController, which also causes the size to shrink
		activeViewController = nil
	}
	
	// MARK: - Private properties and methods
	
	private var lastSegueIdentifier: String?
	
	internal func preferredContentSizeForDrawerContentSize(_ contentSize: CGSize) -> CGSize {
		return CGSize(width: view.bounds.width, height: contentSize.height + buttonStackView.frame.height)
	}
	
	internal func updateButtons(makeActive activeButton: UIButton?) {
		for button in buttonStackView.arrangedSubviews.compactMap({ $0 as? UIButton }) {
			let isActive = button === activeButton
			button.backgroundColor = isActive ? .clear : UIColor.black.withAlphaComponent(0.1)
		}
	}
}
