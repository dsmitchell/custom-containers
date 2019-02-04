//
//  PenDrawerContainerViewController.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

@objc protocol PenDrawerContainerViewControllerDelegate {
	
	func penDrawerContainer(_ viewController: PenDrawerContainerViewController, changedPenColor penColor: UIColor, penSize: CGFloat)
}

final class PenDrawerContainerViewController: DrawerContainerViewController {
	
	// MARK: - Interface Builder outlets
	
	@IBInspectable var currentPenColor: UIColor = .black {
		didSet { updateColor(currentPenColor) }
	}
	@IBInspectable var currentPenSize: CGFloat = 3 {
		didSet { updateSize(currentPenSize) }
	}
	@IBOutlet weak var delegate: PenDrawerContainerViewControllerDelegate?
	@IBOutlet var penSizeButton: PenSelectorButton!

	// MARK: - DrawerContainerViewController overrides
	
	override public func closeDrawer() {
		guard activeViewController != nil else { return }
		// When closing the drawer, make the penSizeButton the "highlighted" button
		updateButtons(makeActive: penSizeButton)
		super.closeDrawer()
	}
	
	// MARK: - UIViewController overrides
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		// When presenting one of the pen selector ViewControllers, let them know the current state
		switch segue.destination {
		case let penColorSelectorViewController as PenColorDrawerViewController:
			penColorSelectorViewController.currentPenColor = currentPenColor
		case let penSizeSelectorViewController as PenSizeDrawerViewController:
			penSizeSelectorViewController.currentPenSize = currentPenSize
		default:
			return // Nothing special to do with this segue
		}
		// Notify the pen size and color -- we may be ending an "erase" operation and resuming regular drawing
		advertisePenChange(color: currentPenColor, size: currentPenSize)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateColor(currentPenColor)
		updateSize(currentPenSize)
		updateButtons(makeActive: penSizeButton)
	}
	
	// MARK: - Private properties and methods
	
	internal func advertisePenChange(color: UIColor, size: CGFloat) {
		// Inform the delegate (SketchViewController) to use a new pen color or size
		delegate?.penDrawerContainer(self, changedPenColor: color, penSize: size)
	}
	
	private func updateColor(_ color: UIColor) {
		penSizeButton.penColor = color
	}
	
	private func updateSize(_ size: CGFloat) {
		penSizeButton.penSize = size
	}
}
