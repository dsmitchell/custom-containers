//
//  OpenDrawerSegue.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

// This is an example of creating a custom UIStoryboardSegue instead of
// using one of the built-in Show/ShowDetail segues. Note, that while it
// is relatively easy to create your own, Show & ShowDetail will always
// have one advantage: access to the `sender` from within the container
// UIViewController. At best, you could override prepare(for:sender:) in
// the source UIViewController and communicate it that way...

/// Represents a container that can open a "drawer" UIViewController
@objc public protocol DrawerOpening {
	
	/// Opens a "drawer" UIViewController
	///
	/// - Parameter vc: The UIViewController to open as a "drawer"
	func openDrawer(_ vc: UIViewController)
}

extension DrawerContainerViewController: DrawerOpening {
	
	open func openDrawer(_ vc: UIViewController) {
		// Just replace the currently active ViewController
		activeViewController = vc
	}
}

/// Custom Segue for a container that implements DrawerOpening
public final class OpenDrawerSegue: UIStoryboardSegue {
	
	override public func perform() {
		// Find the ancestor ViewController that implements `DrawerOpening` and call it
		guard let drawerOpener = source.targetViewController(forAction: #selector(DrawerOpening.openDrawer(_:)), sender: nil) as? DrawerOpening else {
			fatalError("OpenDrawer segue used without a container that implements openDrawer(_:)")
		}
		drawerOpener.openDrawer(destination)
	}
}
